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

    Future<Database> initializeDatabase(String dbName) async {
        var databasesPath = await getDatabasesPath();
        var path = join(databasesPath, dbName);

        var exists = await databaseExists(path);

        if (!exists) {
            print("Creating new copy from asset");

            try {
                await Directory(dirname(path)).create(recursive: true);
            } catch (_) {}

            ByteData data = await rootBundle.load(join("assets", dbName));
            List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

            await File(path).writeAsBytes(bytes, flush: true);
        } else {
            print("Opening existing database");
        }

        _database = await openDatabase(path);

        return _database!;
    }

    Future<List<Map<String, dynamic>>> _queryBooks() async {
        Database db = await this.database;
        return await db.query(booksTable);
    }

    Future<List<Book>> getBooks() async {
        var bibleMaps = await _queryBooks();
        List<Book> books = [];

        for (int ii = 0; ii < bibleMaps.length; ii++) {
            books.add(Book.fromMap(bibleMaps[ii]));
        }

        return books;
    }

    Future<List<Map<String, dynamic>>> _queryChapters(int id) async {
        Database db = await this.database;
        var query = 'SELECT DISTINCT chapter FROM "verses" WHERE book_number = $id';
        return await db.rawQuery(query);
    }

    Future<List<String>> getChapters(int id) async {
        var chapterMaps = await _queryChapters(id);
        List<String> chapterNumbers = [];

        for (int ii = 0; ii < chapterMaps.length; ii++) {
            chapterNumbers.add(chapterMaps[ii]['chapter'].toString());
        }
        return chapterNumbers;
    }

    Future<List<Map<String, dynamic>>> _queryVerses(String id, int chapter) async {
        Database db = await this.database;
        var query = 'SELECT text FROM "verses" WHERE chapter = $chapter AND book_number = $id';
        return await db.rawQuery(query);
    }

    Future<List<Verse>> getVerses(String id, int chapter) async {
        var verseMaps = await _queryVerses(id, chapter);
        //List<String> verses = [];
        List<Verse> verses = [];
        RegExp regExp = RegExp(r'(\<[fmSnh]\>[^\<]*\<\/[fmSnh]\>|\<pb\/\>|\<br\/\>|\<[tiJe]\>|\<\/[tiJe]\>)', multiLine: true);

        for (int ii = 0; ii < verseMaps.length; ii++) {
            verses.add(Verse.fromMap(verseMaps[ii]));
            var text = verses[ii].text;
            var matches = regExp.allMatches(text);
            matches.forEach((match) {
                text = text.replaceAll(match.group(0)!, '');
            });

            verses[ii].text = text.replaceAll('  ', ' ');
            verses[ii].verseNumber = ii;
        }

        return verses;
    }

    Future<List<Map<String, dynamic>>> _getResultMaps(String query) async {
        Database db = await this.database;
        var sqlQuery = 'SELECT book_number, chapter, verse, `text` FROM verses WHERE `text` LIKE "%$query%"';

        return await db.rawQuery(sqlQuery);
    }

    Future<List<Verse>> getResults(String query) async {
        var resultMaps = await _getResultMaps(query);
        List<Verse> verseModel = [];
        RegExp regExp = RegExp(r'(\<[fmSnh]\>[^\<]*\<\/[fmSnh]\>|\<pb\/\>|\<br\/\>|\<[tiJe]\>|\<\/[tiJe]\>)', multiLine: true);

        for (int ii = 0; ii < resultMaps.length; ii++) {
            verseModel.add(Verse.fromMap(resultMaps[ii]));
            var text = verseModel[ii].text;
            var matches = regExp.allMatches(text);
            matches.forEach((match) {
                text = text.replaceAll(match.group(0)!, '');
            });
            var index = text.toLowerCase().indexOf(query.toLowerCase());
            if (index > 30) {
                text = "..." + text.substring(index - 30);
            }

            if (text.length > query.length + 63) {
                text = text.substring(0, query.length + 63) + "...";
            }
            verseModel[ii].text = text.replaceAll('  ',' ');
        }

        return verseModel;
    }
}
