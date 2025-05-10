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
            }
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

    final Color crust = Color(0xFF11111b);
    final Color mantle = Color(0xFF181825);
    final Color base = Color(0xFF1e1e2e);
    final Color text = Color(0xFFcdd6f4);
    final Color surface = Color(0xFF45475A);
    final Color lavender = Color(0xFFb4befe);
    final Color sky = Color(0xFF89dceb);
    final Color overlay = Color(0xFF6c7086);

    ThemeData dark(bibleState) => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: base,
        canvasColor: base,
        appBarTheme: AppBarTheme(
            color: crust,
            foregroundColor: text,
        ),
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                fontWeight: FontWeight.bold,
            ),
            headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
                color: text,
                fontSize: bibleState.fontSize,
            ),
            bodySmall: TextStyle(
                color: text,
                backgroundColor: overlay,
                fontSize: bibleState.fontSize,
            ),
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData(
            selectionColor:  surface,
            selectionHandleColor: lavender,
        ),
        iconTheme: IconThemeData(
            color: text,
        ),
    );

    ThemeData softGreen(bibleState) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: 
            //Colors.red, 
            Colors.green,
        ),
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.green.shade900,
                fontSize: bibleState.fontSize
            ),
            headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
                fontSize: bibleState.fontSize,
            ),
            bodySmall: TextStyle(
                color: text,
                backgroundColor: Colors.green.shade400,
                fontSize: bibleState.fontSize,
            ),
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.green.shade200,
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.green.shade400,
            selectionColor: Colors.green.shade100
        ),
    );

    ThemeData brown(bibleState) => ThemeData(
        iconTheme: IconThemeData(color: Colors.brown.shade100),
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.brown.shade900,
                fontSize: bibleState.fontSize
            ),
            headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
                fontSize: bibleState.fontSize,
            ),
            bodySmall: TextStyle(
                color: text,
                backgroundColor: Colors.brown.shade300,
                fontSize: bibleState.fontSize,
            ),
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: 
            Colors.brown,
        ),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.brown.shade400,
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.brown.shade400,
            selectionColor: Colors.brown.shade100
        ),
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
        textTheme: TextTheme(
            headlineMedium: TextStyle(
                color: Colors.white,
                backgroundColor: Colors.indigo.shade900,
                fontSize: bibleState.fontSize
            ),
            headlineSmall: TextStyle(
                fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
                fontSize: bibleState.fontSize,
            ),
            bodySmall: TextStyle(
                color: text,
                backgroundColor: Colors.indigo.shade400,
                fontSize: bibleState.fontSize,
            ),
        ),
        fontFamily: bibleState.font,
        textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: Colors.indigo.shade400,
            selectionColor: Colors.indigo.shade200
        ),
    );
}
