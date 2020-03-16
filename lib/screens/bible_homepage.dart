import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/bloc/bible_bloc.dart';
import 'package:pocketbible/screens/settings_page.dart';
import 'package:pocketbible/screens/search_page.dart';

class BibleHomePage extends StatelessWidget {
  final BibleBloc bibleState;

  BibleHomePage(this.bibleState);

  @override
  Widget build(BuildContext context) {
    double smallSwipe = MediaQuery.of(context).size.width * .15;
    double longSwipe = MediaQuery.of(context).size.width * .60;
    var startPosition;
    var updatePosition;

    return Scaffold(
      body: CustomScrollView(
        controller: bibleState.getScrollController(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: true,
            leading: IconButton(
              icon:
                  Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: BibleSearch(bibleState),
                );
              },
            ),
            actions: <Widget>[
              Container(
                child: bookDropDown(bibleState, context),
                padding: const EdgeInsets.only(top: 16.0, right: 12.0),
              ),
              Container(
                child: chapterDropDown(bibleState, context),
                padding: const EdgeInsets.only(top: 16.0, right: 2.0),
              ),
              IconButton(
                icon: Icon(
                  Icons.language,
                  color: Theme.of(context).iconTheme.color,
                ),
                tooltip: 'Change Version',
                onPressed: () {
                  if (bibleState.databaseNameState == 'RV1960.db') {
                    bibleState.changeVersion('NEWESV.db');
                  } else {
                    bibleState.changeVersion('RV1960.db');
                  }
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Theme.of(context).iconTheme.color,
                ),
                tooltip: "Settings page",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(bibleState),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: GestureDetector(
              onHorizontalDragStart: (DragStartDetails start) {
                startPosition = start.globalPosition.dx;
              },
              onHorizontalDragUpdate: (DragUpdateDetails update) {
                updatePosition = update.globalPosition.dx;
              },
              onHorizontalDragEnd: (DragEndDetails end) {
                bibleState.swipeResults(startPosition, updatePosition, smallSwipe, longSwipe);
              },
              child: textBox(bibleState, context),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView textBox(bibleState, context) => SingleChildScrollView(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        controller: bibleState.getScrollController(),
        child: SelectableText.rich(
          TextSpan(
            children: bibleState.getVerses().map<InlineSpan>(
              (Verses verse) {
                return TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: " ${verse.verseNumber + 1} ",
                      style: Theme.of(context).textTheme.overline,
                    ),
                    TextSpan(
                      children: textSpanQuery(verse, context),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
          toolbarOptions: ToolbarOptions(copy: true),
        ),
      );

  List<TextSpan> textSpanQuery(verseObject, context) {
    var verseString = verseObject.text;
    var verseQuery = bibleState.bookQuery;
    var verseString1 = "";
    List<TextSpan> newList = new List<TextSpan>();

    if (bibleState.bookQuery != null) {
      while (verseString.contains(verseQuery)) {
        verseString1 =
            verseString.substring(0, verseString.indexOf(verseQuery));
        verseString = verseString.substring(
            verseString.indexOf(verseQuery) + verseQuery.length,
            verseString.length);

        newList.add(
          TextSpan(
            text: verseString1,
            style: Theme.of(context).textTheme.display1,
          ),
        );
        newList.add(
          TextSpan(
            text: verseQuery,
            style: Theme.of(context).textTheme.display4,
          ),
        );
      }
    }

    newList.add(
      TextSpan(
        text: verseString + bibleState.textView,
        style: Theme.of(context).textTheme.display1,
      ),
    );

    return newList;
  }

  DropdownButton bookDropDown(bibleState, context) => DropdownButton<String>(
        items: bibleState.getBookDropDown(),
        onChanged: (userValue) {
          bibleState.onBookSelect(userValue);
        },
        value: bibleState.getBookValue(),
        style: Theme.of(context).textTheme.button,
        isDense: true,
        elevation: 8,
      );

  DropdownButton chapterDropDown(bibleState, context) => DropdownButton<String>(
        items: bibleState.getChapterDropDown(),
        onChanged: (userValue) {
          bibleState.onChapterSelect(userValue);
        },
        value: bibleState.getChapterValue(),
        style: Theme.of(context).textTheme.button,
        isDense: true,
        elevation: 8,
      );
}
