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
    var theme = bibleState.currentTheme;
    switch (theme) {
      case 'softGreen':
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
          // button: TextStyle(color: Colors.black),
          // overline: TextStyle(fontSize: bibleState.overline),
        ),
        fontFamily: bibleState.fontFamily,
        accentColor: Colors.deepPurple,
      );

  ThemeData softGreen(bibleState) => ThemeData(
        primaryColor: Colors.green.shade200,
        accentColor: Colors.lightGreen.shade900,
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          // overline: TextStyle(fontSize: bibleState.overline),
        ),
        brightness: Brightness.light,
        fontFamily: bibleState.fontFamily,
        // canvasColor: Colors.white,
      );

  ThemeData brown(bibleState) => ThemeData(
        iconTheme: IconThemeData(color: Colors.brown.shade200),
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          // overline: TextStyle(fontSize: bibleState.overline),
        ),
        primaryColor: Colors.brown.shade600,
        accentColor: Colors.brown.shade900,
        canvasColor: Colors.brown.shade200,
        fontFamily: bibleState.fontFamily,
      );

  ThemeData genie(bibleState) => ThemeData(
        // iconTheme: IconThemeData(color: Colors.indigo.shade200),
        primaryColor: Colors.indigo.shade300,
        canvasColor: Colors.indigo.shade100,
        textTheme: TextTheme(
          display1:
              TextStyle(color: Colors.black, fontSize: bibleState.fontSize),
          button: TextStyle(color: Colors.black),
          // overline: TextStyle(fontSize: bibleState.overline),
        ),
        fontFamily: bibleState.fontFamily,
      );
}
