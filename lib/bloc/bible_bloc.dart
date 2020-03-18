import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BibleBloc with ChangeNotifier {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String bookValue;
  String chapterValue;
  ScrollController myScrollController = ScrollController();
  List<Verses> versesItems = List<Verses>();
  List<Books> bookList = List<Books>();
  String databaseNameState;

  Map linkedList = Map();
  Map secondLinkedList = Map();
  var theme = 'brown';
  var font = 'Montserrat';
  var overlineValue = 8.0;
  double slider = 0.0;
  var fontSizeValue = 14.0;

  BibleBloc() {
    bookValue = "10";
    chapterValue = "1";
    databaseNameState = 'RV1960.db';
    this.onStart(databaseNameState);
    getValueSP();
  }

  Future addFontSizetoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('fontSize', fontSizeValue);
  }

  Future addFonttoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('font', font);
  }

  Future addThemetoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('theme', theme);
  }

  Future addTextViewtoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('textBoxMarker', textBoxMarker);
  }

  Future getValueSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('fontSize') == true) {
      fontSizeValue = prefs.getDouble('fontSize');
      slider = fontSizeValue - 14;
    }
    if (prefs.containsKey('textBoxMarker') == true) {
      textBoxMarker = prefs.getBool('textBoxMarker');
    }
    if (prefs.containsKey('font') == true) {
      font = prefs.getString('font');
    }
    if (prefs.containsKey('theme') == true) {
      theme = prefs.getString('theme');
    }
  }

  void changeTheme(newTheme) {
    theme = newTheme;

    addThemetoSP();

    notifyListeners();
  }

  void changeFont(newFont) {
    font = newFont;

    addFonttoSP();

    notifyListeners();
  }

  void changeSlider(double newSlider) {
    slider = newSlider;
    setFontSize();
    notifyListeners();
  }

  void setFontSize() {
    fontSizeValue = slider + 14.0;

    addFontSizetoSP();
  }

  String get fontFamily => font;
  double get sliderValue => slider;
  double get fontSize => fontSizeValue;
  double get overline => overlineValue;
  String get currentTheme => theme;

  getBookValue() => bookValue;
  getChapterValue() => chapterValue;
  getVerses() => versesItems;
  getScrollController() => myScrollController;

  Future onStart(databaseName) async {
    await _databaseHelper.initializeDatabase(databaseName);
    bookList = await _databaseHelper.getBookList();
    await updateChapterView(int.parse(bookValue), int.parse(chapterValue));

    notifyListeners();
  }

  void onBookSelect(String value) async {
    bookValue = value;
    chapterValue = "1";
    await updateChapterView(int.parse(bookValue), 1);
    notifyListeners();
    myScrollController.jumpTo(0);
  }

  void onChapterSelect(String value) async {
    chapterValue = value;
    await updateText(int.parse(chapterValue));
    notifyListeners();
    myScrollController.jumpTo(0);
  }

  void nextBook() async {
    if (int.parse(bookValue) < 730) {
      do {
        bookValue = "${int.parse(bookValue) + 10}";
      } while (bookValue == "170" ||
          bookValue == "180" ||
          bookValue == "200" ||
          bookValue == "210" ||
          bookValue == "270" ||
          bookValue == "280" ||
          bookValue == "320");
      chapterValue = "1";
      await updateChapterView(int.parse(bookValue), 1);
      notifyListeners();
      myScrollController.jumpTo(0);
    }
  }

  void nextChapter() async {
    if (int.parse(chapterValue) < chapterList.length) {
      chapterValue = "${int.parse(chapterValue) + 1}";
      await updateText(int.parse(chapterValue));
      myScrollController.jumpTo(0);
      notifyListeners();
    } else {
      nextBook();
    }
  }

  void previousBook() async {
    if (int.parse(bookValue) > 10) {
      do {
        bookValue = "${int.parse(bookValue) - 10}";
      } while (bookValue == "170" ||
          bookValue == "180" ||
          bookValue == "200" ||
          bookValue == "210" ||
          bookValue == "270" ||
          bookValue == "280" ||
          bookValue == "320");
      chapterValue = "1";
      await updateChapterView(int.parse(bookValue), 1);
      notifyListeners();
      myScrollController.jumpTo(0);
    }
  }

  void previousChapter() async {
    if (int.parse(chapterValue) > 1) {
      chapterValue = "${int.parse(chapterValue) - 1}";
      await updateText(int.parse(chapterValue));
      notifyListeners();
      myScrollController.jumpTo(0);
    } else if (int.parse(bookValue) > 10) {
      do {
        bookValue = "${int.parse(bookValue) - 10}";
      } while (bookValue == "170" ||
          bookValue == "180" ||
          bookValue == "200" ||
          bookValue == "210" ||
          bookValue == "270" ||
          bookValue == "280" ||
          bookValue == "320");
      await updateChapterView(int.parse(bookValue), -1);
      notifyListeners();
      myScrollController.jumpTo(0);
    }
  }

  void quitSearch(String bookNumber, String chapterNumber) async {
    bookValue = bookNumber;
    chapterValue = chapterNumber;
    await updateChapterView(int.parse(bookNumber), int.parse(chapterNumber));
    notifyListeners();
  }

  void changeVersion(databaseName) async {
    databaseNameState = databaseName;
    await onStart(databaseName);
  }
  // TODO: Make linked lists

  get linkedL => linkedList;
  get secondLL => secondLinkedList;

  List<String> chapterList = List<String>();

  Future updateChapterView(int bookNumber, int checkValue) async {
    chapterList = await _databaseHelper.getChapterList(bookNumber);
    notifyListeners();

    if (checkValue == -1) {
      await updateText(chapterList.length);
      chapterValue = "${chapterList.length}";
    } else {
      await updateText(
        int.parse(chapterValue),
      );
    }
  }

  Future updateText(int chapter) async {
    final textoList = await _databaseHelper.getTextList(bookValue, chapter);
    versesItems.length = 0;

    for (var ii = 0; ii < textoList.length; ii++) {
      versesItems.add(textoList[ii]);
    }
  }

  var bookQuery;

  Future<List<Verses>> updateResults(String query) async {
    final resultsList = await _databaseHelper.getResults(query);
    bookQuery = query;
    return resultsList;
  }

  bool textBoxMarker = true;
  var textView = "\n";

  changeView(bool value) {
    if (textBoxMarker == true) {
      textBoxMarker = false;
      textView = "";
    } else {
      textBoxMarker = true;
      textView = "\n";
    }

    addTextViewtoSP();

    notifyListeners();
  }

  getTextBoxMarker() => textBoxMarker;

  swipeResults(start, update, smallSwipe, longSwipe) {
    if ((start - update) > smallSwipe && (start - update) < longSwipe) {
      nextChapter();
    } else if ((start - update) > longSwipe) {
      nextBook();
    } else if ((start - update) < -smallSwipe &&
        (start - update) > -longSwipe) {
      previousChapter();
    } else if ((start - update) < -longSwipe) {
      previousBook();
    }
  }
}
