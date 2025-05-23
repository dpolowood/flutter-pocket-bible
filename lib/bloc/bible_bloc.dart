import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/utils/database_helper.dart';
import 'package:pocketbible/utils/user_preferences.dart';

class BibleBloc with ChangeNotifier {
    DatabaseHelper _databaseHelper = DatabaseHelper();
    late String bookValue;
    late String chapterValue;
    ScrollController myScrollController = ScrollController();
    List<Verse> versesItems = [];
    List<Book> bookList = [];
    List<String> chapterList = [];
    String bookQuery = '';

    Map _bookNumberMap = Map();
    Map _bookNameMap = Map();
    List _bookNumbers = [];

    String databaseName = 'RV1960.db';
    String _theme = 'brown';
    String _font = 'Montserrat';
    double _overline = 8.0;
    double _slider = 0.0;
    String _textView = '\n';
    bool _viewSlider = true;
    List<Verse> _textoList = [];

    BibleBloc() {
        bookValue = '10';
        chapterValue = '1';
        _textoList =  List<Verse>.empty();
        getValueSP();
        // this.onStart(databaseName);
        print(databaseName);
    }

    Future<void> getValueSP() async {
        final fontSize = await UserPreferences.getFontSize();
        final textBox = await UserPreferences.getTextView();
        final fontPref = await UserPreferences.getFont();
        final themePref = await UserPreferences.getTheme();
        final languagePref = await UserPreferences.getLanguage();

        if (fontSize != null) {
            slider = fontSize - 14;
        }
        if (textBox != null) {
            viewSlider = textBox;
        }
        if (fontPref != null) {
            font = fontPref;
        }
        if (themePref != null) {
            theme = themePref;
        }

        databaseName = languagePref ?? 'RV1960.db';
        await onStart(databaseName);
    }

    set textoList(newText) {
        _textoList = newText;

        notifyListeners();
    }

    set theme(newTheme) {
        _theme = newTheme;

        UserPreferences.setTheme(_theme);

        notifyListeners();
    }

    set font(newFont) {
        _font = newFont;

        UserPreferences.setFont(_font);

        notifyListeners();
    }

    set slider(newSlider) {
        _slider = newSlider;

        UserPreferences.setFontSize(_slider + 14);

        notifyListeners();
    }

    set viewSlider(newSlider) {
        _viewSlider = newSlider;

        if (_viewSlider) {
            textView = "\n";
        } else {
            textView = "";
        }

        UserPreferences.setTextView(_viewSlider);

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
    double get fontSize => slider + 14;
    double get overline => _overline;
    String get theme => _theme;
    List<Verse> get textoList => _textoList;
    Map get bookNumberMap => _bookNumberMap;
    Map get bookNameMap => _bookNameMap;

    getBookValue() => bookValue;
    getChapterValue() => chapterValue;
    getScrollController() => myScrollController;

    Future onStart(databaseName) async {
        await _databaseHelper.initializeDatabase(databaseName);
        bookList = await _databaseHelper.getBooks();
        await updateChapterView(int.parse(bookValue), int.parse(chapterValue));

        bookList.forEach(
            (Book book) {
                _bookNumbers.add("${book.id}");
                _bookNumberMap[book.id] = book.title;
                _bookNameMap[book.title] = book.id;
            },
        );
    }

    void onBookSelect(String newBook) async {
        bookValue = newBook;
        chapterValue = "1";
        await updateChapterView(int.parse(bookValue), 1);
        myScrollController.jumpTo(0);
    }

    void onChapterSelect(String newChapter) async {
        chapterValue = newChapter;
        textoList = await updateText(int.parse(chapterValue));
        myScrollController.jumpTo(0);
    }

    void nextBook() async {
        if (bookValue != _bookNumbers.last) {
            bookValue = _bookNumbers[_bookNumbers.indexOf(bookValue) + 1];
            chapterValue = "1";
            await updateChapterView(int.parse(bookValue), 1);
            myScrollController.jumpTo(0);
        }
    }

    void nextChapter() async {
        if (int.parse(chapterValue) < chapterList.length) {
            chapterValue = "${int.parse(chapterValue) + 1}";
            textoList = await updateText(int.parse(chapterValue));
            myScrollController.jumpTo(0);
        } else {
            nextBook();
        }
    }

    void previousBook() async {
        if (bookValue != _bookNumbers.first) {
            bookValue = _bookNumbers[_bookNumbers.indexOf(bookValue) - 1];
            chapterValue = "1";
            await updateChapterView(int.parse(bookValue), 1);
            myScrollController.jumpTo(0);
        }
    }

    void previousChapter() async {
        if (int.parse(chapterValue) > 1) {
            chapterValue = "${int.parse(chapterValue) - 1}";
            textoList = await updateText(int.parse(chapterValue));
            myScrollController.jumpTo(0);
        } else if (bookValue != _bookNumbers.first) {
            bookValue = _bookNumbers[_bookNumbers.indexOf(bookValue) - 1];
            await updateChapterView(int.parse(bookValue), -1);
            myScrollController.jumpTo(0);
        }
    }

    void quitSearch(String bookNumber, String chapterNumber) async {
        bookValue = bookNumber;
        chapterValue = chapterNumber;
        await updateChapterView(int.parse(bookNumber), int.parse(chapterNumber));
    }

    void changeVersion(newDatabaseName) async {
        databaseName = newDatabaseName;

        await UserPreferences.setLanguage(databaseName);

        await onStart(databaseName);
    }

    Future updateChapterView(int bookNumber, int checkValue) async {
        chapterList = await _databaseHelper.getChapters(bookNumber);

        if (checkValue == -1) {
            textoList = await updateText(chapterList.length);
            chapterValue = "${chapterList.length}";
        } else {
            textoList = await updateText(int.parse(chapterValue));
        }
    }

    Future updateText(int chapter) async {
        return await _databaseHelper.getVerses(bookValue, chapter);
    }

    Future<List<Verse>> updateResults(String query) async {
        final resultsList = await _databaseHelper.getResults(query);
        bookQuery = query;
        return resultsList;
    }

    swipeResults(start, update, smallSwipe, longSwipe) {
        double swipe = start-update;
        if (swipe > smallSwipe && swipe < longSwipe) {
            nextChapter();
        } else if (swipe > longSwipe) {
            nextBook();
        } else if (swipe < -smallSwipe &&
            swipe > -longSwipe) {
            previousChapter();
        } else if (swipe < -longSwipe) {
            previousBook();
        }
    }
}
