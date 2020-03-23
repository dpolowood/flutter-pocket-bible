import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import 'bloc/bible_bloc.dart';
import 'screens/bible_homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider<BibleBloc>(
      create: (_) => BibleBloc(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bibleState = Provider.of<BibleBloc>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getCustomTheme(bibleState),
      home: BibleHomePage(bibleState),
    );
  }

  ThemeData getCustomTheme(bibleState) {
    var theme = bibleState.theme;
    switch (theme) {
      case 'softGreen':
        return softGreen(bibleState);
      case 'soft green':
        return softGreen(bibleState);
      case 'brown':
        return brown(bibleState);
      case 'dark':
        return dark(bibleState);
      case 'genie':
        return genie(bibleState);
    }

    return softGreen(bibleState);
  }

  ThemeData dark(bibleState) => ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          display1: TextStyle(fontSize: bibleState.fontSize),
          display4: TextStyle(backgroundColor: Colors.deepPurple.shade400, fontSize: bibleState.fontSize),
        ),
        fontFamily: bibleState.font,
        accentColor: Colors.deepPurple,
        textSelectionColor: Colors.deepPurple.shade800,
        textSelectionHandleColor: Colors.deepPurple.shade400,
      );

  ThemeData softGreen(bibleState) => ThemeData(
        primaryColor: Colors.green.shade200,
        accentColor: Colors.lightGreen.shade900,
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          display4: TextStyle(backgroundColor: Colors.green.shade400, fontSize: bibleState.fontSize),
        ),
        brightness: Brightness.light,
        fontFamily: bibleState.font,
        textSelectionHandleColor: Colors.green.shade400,
        textSelectionColor: Colors.green.shade100,
      );

  ThemeData brown(bibleState) => ThemeData(
        iconTheme: IconThemeData(color: Colors.brown.shade200),
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          display4: TextStyle(backgroundColor: Colors.brown.shade100, fontSize: bibleState.fontSize),
        ),
        primaryColor: Colors.brown.shade600,
        accentColor: Colors.brown.shade900,
        canvasColor: Colors.white,
        fontFamily: bibleState.font,
        textSelectionColor: Colors.brown.shade100,
        textSelectionHandleColor: Colors.brown.shade400,
      );

  ThemeData genie(bibleState) => ThemeData(
        primaryColor: Colors.indigo.shade300,
        canvasColor: Colors.indigo.shade100,
        accentColor: Colors.indigo[900],
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          display4: TextStyle(backgroundColor: Colors.indigo.shade200, fontSize: bibleState.fontSize),
        ),
        fontFamily: bibleState.font,
        textSelectionHandleColor: Colors.indigo.shade400,
        textSelectionColor: Colors.indigo.shade200,
      );
}
