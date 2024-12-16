import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/bloc/bible_bloc.dart';

class BibleSearch extends SearchDelegate {
  BibleBloc bibleState;

  BibleSearch(this.bibleState);

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Container(
        child: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query != '') {
      return FutureBuilder<List<Verses>>(
        future: bibleState.updateResults(query),
        builder: (context, snapshot) {
          var results = snapshot.data;
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (results?.length == 0) {
            return Container(
              child: Center(
                child: Text("No Results"),
              ),
            );
          } else {
            return Container(
              child: ListView.builder(
                itemCount: results?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      dense: true,
                      leading: Text(
                        "${bibleState.bookNumberMap[results?[index].verseBookNumber]} " +
                            "${results?[index].chapter}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      title: Text("${results?[index].verseNumber} " +
                          (results?[index].text ?? '')),
                      onTap: () {
                        bibleState.quitSearch(
                            "${results?[index].verseBookNumber}",
                            "${results?[index].chapter}");
                        close(context, null);
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      );
    }

    return Container(
      child: Center(
        child: Text("No Results"),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
