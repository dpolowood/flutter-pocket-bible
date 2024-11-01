import "package:flutter/material.dart";
import 'package:pocketbible/screens/settings_page.dart';
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

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bibleState = Provider.of<BibleBloc>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getCustomTheme(bibleState),
        initialRoute: '/home',
        routes: {
          '/home': (context) => BibleHomePage(bibleState),
          '/settings': (context) => SettingsPage(bibleState),
        });
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
          headlineMedium: TextStyle(fontSize: bibleState.fontSize,backgroundColor: Colors.white,color: Colors.black),
          headlineSmall: TextStyle(fontSize: bibleState.fontSize),
        ),
        // appBarTheme: AppBarTheme(
        //   backgroundColor: Colors.green.shade900,
        // ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData(selectionColor:  Colors.deepPurple.shade800, selectionHandleColor: Colors.deepPurple.shade400),
      );

  ThemeData softGreen(bibleState) => ThemeData(

        colorScheme: ColorScheme.fromSeed(
          seedColor: 
          //Colors.red, 
          Colors.green,
        ),
        textTheme: TextTheme(
          headlineMedium:
              TextStyle(color: Colors.white, backgroundColor: Colors.green.shade900, fontSize: bibleState.fontSize),
          // button: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(fontSize: bibleState.fontSize),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green.shade200,
        ),
        // brightness: Brightness.light,
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData( selectionHandleColor: Colors.green.shade400, selectionColor: Colors.green.shade100),
      );

  ThemeData brown(bibleState) => ThemeData(
        iconTheme: IconThemeData(color: Colors.brown.shade100),
        textTheme: TextTheme(
          headlineMedium:
              TextStyle(color: Colors.white, backgroundColor: Colors.brown.shade900, fontSize: bibleState.fontSize),
          // button: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(fontSize: bibleState.fontSize),
        ),
        // primaryColor: Colors.brown.shade600,
        // secondaryHeaderColor: Colors.brown.shade900,
        // canvasColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: 
          //Colors.red, 
          Colors.brown,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown.shade400,
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData( selectionHandleColor: Colors.brown.shade400, selectionColor: Colors.brown.shade100),
      );

  ThemeData genie(bibleState) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: 
          //Colors.red, 
          Colors.indigo.shade900,
        ),
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigo.shade200,
        ),
        
        canvasColor: Colors.indigo.shade100,
        // secondaryHeaderColor: Colors.indigo[900],
        textTheme: TextTheme(
          headlineMedium:
              TextStyle(color: Colors.white, backgroundColor: Colors.indigo.shade900, fontSize: bibleState.fontSize),
          // button: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(fontSize: bibleState.fontSize),
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData( selectionHandleColor: Colors.indigo.shade400, selectionColor: Colors.indigo.shade200),
      );
}
