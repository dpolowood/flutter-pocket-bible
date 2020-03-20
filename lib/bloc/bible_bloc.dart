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
  List<String> chapterList = List<String>();
  String databaseNameState;
  String bookQuery;

  Map linkedList = Map();
  Map secondLinkedList = Map();
  var _theme = 'brown';
  var _font = 'Montserrat';
  var _overline = 8.0;
  double _slider = 0.0;
  var _fontSize = 14.0;
  var _textView = "\n";
  var _viewSlider = true;
  var _textoList;

  List<Verses> get textoList => _textoList;

  set textoList(newText) {
    _textoList = newText;

    notifyListeners();
  }

  BibleBloc() {
    bookValue = "10";
    chapterValue = "1";
    textoList = List<Verses>();
    databaseNameState = 'RV1960.db';
    this.onStart(databaseNameState);
    getValueSP();
  }

  Future addFontSizetoSP(newFontSize) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('fontSize', newFontSize);
  }

  Future addFonttoSP(newFont) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('font', newFont);
  }

  Future addThemetoSP(newTheme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('theme', newTheme);
  }

  Future addTextViewtoSP(newView) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('textBoxMarker', newView);
  }

  Future getValueSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('fontSize') == true) {
      _fontSize = prefs.getDouble('fontSize');
      slider = _fontSize - 14;
    }
    if (prefs.containsKey('textBoxMarker') == true) {
      viewSlider = prefs.getBool('textBoxMarker');
    }
    if (prefs.containsKey('font') == true) {
      font = prefs.getString('font');
    }
    if (prefs.containsKey('theme') == true) {
      theme = prefs.getString('theme');
    }
  }

  set theme(newTheme) {
    _theme = newTheme;

    addThemetoSP(_theme);

    notifyListeners();
  }

  set font(newFont) {
    _font = newFont;

    addFonttoSP(_font);

    notifyListeners();
  }

  set slider(newSlider) {
    _slider = newSlider;
    fontSize = _slider + 14.0;

    notifyListeners();
  }

  set fontSize(newFontSize) {
    _fontSize = newFontSize;

    addFontSizetoSP(_fontSize);

    notifyListeners();
  }

  set viewSlider(newSlider) {
    _viewSlider = newSlider;

    if (newSlider == true) {
      _textView = "\n";
    } else {
      _textView = "";
    }

    addTextViewtoSP(_viewSlider);

    notifyListeners();
  }

  set textView(newView) {
    _textView = newView;

    notifyListeners();
  }

  bool get viewSlider => _viewSlider;
  String get textView => _textView;
  String get font => _font;
  double get slider => _slider;
  double get fontSize => _fontSize;
  double get overline => _overline;
  String get theme => _theme;

  getBookValue() => bookValue;
  getChapterValue() => chapterValue;
  getScrollController() => myScrollController;

  Map _bookNumberMap = Map();
  Map _bookNameMap = Map();

  Future onStart(databaseName) async {
    await _databaseHelper.initializeDatabase(databaseName);
    bookList = await _databaseHelper.getBookList();
    await updateChapterView(int.parse(bookValue), int.parse(chapterValue));

    bookList.forEach(
      (Books book) {
        _bookNumberMap[book.bookNumber] = book.bookName;
        _bookNameMap[book.bookName] = book.bookNumber;
      },
    );

    notifyListeners();
  }

  Map get bookNumberMap => _bookNumberMap;
  Map get bookNameMap => _bookNameMap;

  void onBookSelect(String newBook) async {
    bookValue = newBook;
    chapterValue = "1";
    await updateChapterView(int.parse(bookValue), 1);
    notifyListeners();
    myScrollController.jumpTo(0);
  }

  void onChapterSelect(String newChapter) async {
    chapterValue = newChapter;
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
    textoList = await _databaseHelper.getTextList(bookValue, chapter);
  }

  Future<List<Verses>> updateResults(String query) async {
    final resultsList = await _databaseHelper.getResults(query);
    bookQuery = query;
    return resultsList;
  }

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
