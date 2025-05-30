import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/bloc/bible_bloc.dart';
import 'package:pocketbible/screens/search_page.dart';

// Homepage of the app

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
                controller: bibleState.myScrollController,
                slivers: <Widget>[
                    SliverAppBar(
                        pinned: false,
                        floating: true,
                        snap: true,
                        leading: IconButton(
                            icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
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
                                padding: const EdgeInsets.only(top: 16.0, right: 2.0),
                            ),
                            Container(
                                child: chapterDropDown(bibleState, context),
                                padding: const EdgeInsets.only(top: 16.0, right: 1.0),
                            ),
                            IconButton(
                                icon: Icon(Icons.language,
                                color: Theme.of(context).iconTheme.color),
                                tooltip: 'Change Version',
                                onPressed: () {
                                    if (bibleState.databaseName == 'RV1960.db') {
                                        bibleState.changeVersion('NEWESV.db');
                                    } else {
                                        bibleState.changeVersion('RV1960.db');
                                    }
                                },
                            ),
                            IconButton(
                                icon: Icon(Icons.settings,
                                color: Theme.of(context).iconTheme.color),
                                tooltip: "Settings page",
                                onPressed: () {
                                    Navigator.pushNamed(context, '/settings');
                                },
                            ),
                        ],
                    ),
                    SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) => GestureDetector(
                            onHorizontalDragStart: (DragStartDetails start) {
                                startPosition = start.globalPosition.dx;
                            },
                            onHorizontalDragUpdate: (DragUpdateDetails update) {
                                updatePosition = update.globalPosition.dx;
                            },
                            onHorizontalDragEnd: (DragEndDetails end) {
                                bibleState.swipeResults(
                                startPosition, updatePosition, smallSwipe, longSwipe);
                            },
                            child: textBox(bibleState, context),
                        ),
                        childCount: 1,
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
                children: bibleState.textoList.map<InlineSpan>(
                    (Verse verse) {
                        return TextSpan(
                            children: <TextSpan>[
                                TextSpan(
                                    text: " ${verse.verseNumber + 1} ",
                                    style: Theme.of(context).textTheme.labelSmall,
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

    /**
    * 
    * The purpose of this method is to highlight specific parts of the verse text that match the user's query, 
    * allowing for a visually distinct representation of the queried text within the overall verse. 
    * This is useful for enhancing the readability and usability of the app, 
    * especially when users are searching for specific verses or phrases.
    */
    List<TextSpan> textSpanQuery(verseObject, context) {
        var verseString = verseObject.text;
        var verseQuery = bibleState.bookQuery.toLowerCase();
        var verseString1 = "";
        var insert = '';
        List<TextSpan> newList = [];

        if (verseQuery != "") {
            int index = verseString.toLowerCase().indexOf(verseQuery);
            while (index != -1) {
                verseString1 = verseString.substring(0, index);
                insert = verseString.substring(index, index + verseQuery.length);
                verseString = verseString.substring(
                index + verseQuery.length,
                verseString.length);

                newList.add(
                    TextSpan(
                        text: verseString1,
                        style: Theme.of(context).textTheme.bodyMedium,
                    ),
                );
                newList.add(
                    TextSpan(
                        text: insert,
                        style: Theme.of(context).textTheme.bodySmall,
                    ),
                );
                index = verseString.toLowerCase().indexOf(verseQuery);
            }
        }

        newList.add(
            TextSpan(
                text: verseString + bibleState.textView,
                style: Theme.of(context).textTheme.bodyMedium,
            ),
        );

        return newList;
    }

    DropdownButton bookDropDown(bibleState, context) => DropdownButton<String>(
        items: makeBookDropDown(),
        onChanged: (userValue) {
            bibleState.onBookSelect(userValue);
        },
        value: bibleState.getBookValue(),
        style: Theme.of(context).textTheme.titleSmall,
        isDense: true,
        elevation: 8,
    );

    DropdownButton chapterDropDown(bibleState, context) => DropdownButton<String>(
        items: makeChapterDropDown(),
        onChanged: (userValue) {
            bibleState.onChapterSelect(userValue);
        },
        value: bibleState.getChapterValue(),
        style: Theme.of(context).textTheme.titleSmall,
        isDense: true,
        elevation: 8,
    );

    makeBookDropDown() {
        List<DropdownMenuItem> bookItems = bibleState.bookList.map(
            (Book book) {
                return DropdownMenuItem(
                    value: "${book.id}",
                    child: Text(book.title),
                );
            },
        ).toList();

        return bookItems;
    }

    makeChapterDropDown() {
        List<DropdownMenuItem> chapterItems = bibleState.chapterList.map(
            (String chapter) {
                return DropdownMenuItem(
                    value: "$chapter",
                    child: Text("$chapter"),
                );
            },
        ).toList();

        return chapterItems;
    }
}
