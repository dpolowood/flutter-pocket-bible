import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:pocketbible/models/bible_tables.dart';

class DatabaseHelper {
    DatabaseHelper._internal();
    static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();
    static Database? _database;

    String searchQuery = "";

    String bookNumber = 'book_number';
    String bookName = 'long_name';
    String booksTable = 'books';
    String verseBookNumber = 'book_number';
    String chapter = 'chapter';
    String verseNumber = 'verse';
    String text = 'text';


    factory DatabaseHelper() {
        return _databaseHelper;
    }

    Future<Database> get database async {
        if (_database == null) {
            _database = await initializeDatabase('RV1960.db');
        }

        return _database!;
    }

    Future<Database> initializeDatabase(String databaseName) async {
        var databasesPath = await getDatabasesPath();
        var path = join(databasesPath, databaseName);

        // var path = join(databasesPath, 'RV1960.db');
        // print(path);
        // deleteDatabase(path);

        var exists = await databaseExists(path);

        if (!exists) {
            print("Creating new copy from asset");

            try {
                await Directory(dirname(path)).create(recursive: true);
            } catch (_) {}

            ByteData data = await rootBundle.load(join("assets", databaseName));
            List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

            await File(path).writeAsBytes(bytes, flush: true);
        } else {
            print("Opening existing database");
        }

        _database = await openDatabase(path);

        return _database!;
    }

    Future<List<Map<String, dynamic>>> getBibleMapList() async {
        Database db = await this.database;
        return await db.query(booksTable);
    }

    Future<List<Books>> getBookList() async {
        var bibleMapList = await getBibleMapList();
        int count = bibleMapList.length;
        List<Books> bookList = [];

        for (int ii = 0; ii < count; ii++) {
            bookList.add(Books.fromMapObject(bibleMapList[ii]));
        }

        return bookList;
    }

    Future<List<Map<String, dynamic>>> getChapterMapList(int bookNumber) async {
        Database db = await this.database;
        var query = 'SELECT DISTINCT chapter FROM "verses" WHERE book_number = $bookNumber';
        return await db.rawQuery(query);
    }

    Future<List<String>> getChapterList(int bookNumber) async {
        var chapterMapList = await getChapterMapList(bookNumber);
        int count = chapterMapList.length;
        List<String> versesList = [];

        for (int ii = 0; ii < count; ii++) {
            versesList.add('${chapterMapList[ii][chapter]}');
        }
        return versesList;
    }

    Future<List<Map<String, dynamic>>> getTextMapList(String bookNumber, int chapter) async {
        Database db = await this.database;
        var query = 'SELECT text FROM "verses" WHERE chapter = $chapter AND book_number = $bookNumber';
        return await db.rawQuery(query);
    }

    Future<List<Verses>> getTextList(String bookNumber, int chapter) async {
        var textoMapList = await getTextMapList(bookNumber, chapter);
        List<String> textList = [];
        List<Verses> verseModel = [];
        RegExp regExp =
        RegExp(r'(\<[fmSnh]\>[^\<]*\<\/[fmSnh]\>|\<pb\/\>|\<br\/\>|\<[tiJe]\>|\<\/[tiJe]\>)', multiLine: true);

        for (int ii = 0; ii < textoMapList.length; ii++) {
            verseModel.add(Verses.fromMapObject(textoMapList[ii]));
            var texto = verseModel[ii].text;
            var matches = regExp.allMatches(texto);
            matches.forEach((match) {
                texto = texto.replaceAll(match.group(0)!, '');
            });
            textList.add(texto.replaceAll('  ',' '));

            verseModel[ii].text = texto.replaceAll('  ', ' ');
            verseModel[ii].verseNumber = ii;
        }

        return verseModel;
    }

    Future<List<Map<String, dynamic>>> getResultsMap(String query) async {
        Database db = await this.database;
        var sqlQuery = 'SELECT book_number, chapter, verse, `text` FROM verses WHERE `text` LIKE "%$query%"';

        return await db.rawQuery(sqlQuery);
    }

    Future<List<Verses>> getResults(String query) async {
        var resultsMapList = await getResultsMap(query);
        List<Verses> verseModel = [];
        RegExp regExp =
        RegExp(r'(\<[fmSnh]\>[^\<]*\<\/[fmSnh]\>|\<pb\/\>|\<br\/\>|\<[tiJe]\>|\<\/[tiJe]\>)', multiLine: true);

        for (int ii = 0; ii < resultsMapList.length; ii++) {
            verseModel.add(Verses.fromMapObject(resultsMapList[ii]));
            var texto = verseModel[ii].text;
            var matches = regExp.allMatches(texto);
            matches.forEach((match) {
                texto = texto.replaceAll(match.group(0)!, '');
            });
            var index = texto.toLowerCase().indexOf(query.toLowerCase());
            if (index > 30) {
                texto = "..." + texto.substring(index - 30);
            }

            if (texto.length > query.length + 63) {
                texto = texto.substring(0, query.length + 63) + "...";
            }
            verseModel[ii].text = texto.replaceAll('  ',' ');
        }

        return verseModel;
    }
}
