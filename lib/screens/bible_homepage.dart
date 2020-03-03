import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:pocketbible/models/bible_tables.dart';
import 'package:pocketbible/bloc/bible_bloc.dart';

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
                icon: Icon(Icons.language,
                    color: Theme.of(context).iconTheme.color),
                tooltip: 'Change Version',
                onPressed: () {
                  var check = bibleState.getCheck();
                  if (check == true) {
                    bibleState.changeVersion('NEWESV.db');
                  } else {
                    bibleState.changeVersion('RV1960.db');
                  }
                  bibleState.changeCheck();
                },
              ),
              IconButton(
                icon: Icon(Icons.settings,
                    color: Theme.of(context).iconTheme.color),
                tooltip: "Settings page",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(bibleState),
                    ),
                  );
                },
              )
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
                if ((startPosition - updatePosition) > smallSwipe &&
                    (startPosition - updatePosition) < longSwipe) {
                  bibleState.nextChapter();
                } else if ((startPosition - updatePosition) > longSwipe) {
                  bibleState.nextBook();
                } else if ((startPosition - updatePosition) < -smallSwipe &&
                    (startPosition - updatePosition) > -longSwipe) {
                  bibleState.previousChapter();
                } else if ((startPosition - updatePosition) < -longSwipe) {
                  bibleState.previousBook();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: firstTextBox(bibleState, context),
              ),
            ),
          )
        ],
      ),
    );
  }

  SingleChildScrollView firstTextBox(bibleState, context) =>
      SingleChildScrollView(
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
                      text: verse.text + bibleState.textView,
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ],
                );
              },
            ).toList(),
          ),
          cursorWidth: 5,
          cursorColor: Colors.green,
          cursorRadius: Radius.circular(5),
          toolbarOptions: ToolbarOptions(copy: true),
        ),
      );

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
    Map secondLinkedList = bibleState.secondLL;

    if (query != '') {
      return FutureBuilder<List<Verses>>(
        future: bibleState.updateResults(query),
        builder: (context, snapshot) {
          var results = snapshot.data;
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (results.length == 0) {
            return Container(
              child: Center(
                child: Text("No Results"),
              ),
            );
          } else {
            return Container(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child: ListTile(
                      dense: false,
                      leading: Text(
                          "${secondLinkedList[results[index].verseBookNumber]} " +
                              "${results[index].chapter}"),
                      title: Text("${results[index].verseNumber} " +
                          results[index].text),
                      onTap: () {
                        bibleState.quitSearch(
                            "${results[index].verseBookNumber}",
                            "${results[index].chapter}");
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

class SettingsPage extends StatefulWidget {
  final BibleBloc bibleState;

  SettingsPage(this.bibleState);

  @override
  _SettingsPageState createState() => _SettingsPageState(bibleState);
}

class _SettingsPageState extends State<SettingsPage> {
  BibleBloc bibleState;
  _SettingsPageState(this.bibleState);
  var value = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text(
              "Preferences",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            activeColor: Theme.of(context).accentColor,
            title: Text("Text View"),
            subtitle: Text("Switch between views"),
            value: bibleState.getTextBoxMarker(),
            onChanged: (bool _value) {
              bibleState.changeView(_value);
              setState(() {});
            },
          ),
          Divider(
            height: 16,
          ),
          ListTile(
            title: Text("Font Size"),
            subtitle: Text("Adjust font size"),
          ),
          Slider(
            activeColor: Theme.of(context).accentColor,
            min: 0.0,
            max: 10.0,
            label: "${bibleState.sliderValue.toInt() + 14}",
            divisions: 10,
            value: bibleState.sliderValue,
            onChanged: (double newSlider) {
              bibleState.changeSlider(newSlider);
            },
          ),
          Divider(),
          ListTile(
            title: Text("Font"),
            subtitle: Text("Change font to your preference"),
            trailing: DropdownButton(
              value: bibleState.fontFamily,
              items: [
                DropdownMenuItem(
                  value: 'Montserrat',
                  child: Text('Montserrat'),
                ),
                DropdownMenuItem(
                  value: 'OpenSans',
                  child: Text('OpenSans'),
                ),
                DropdownMenuItem(
                  value: 'Roboto',
                  child: Text('Roboto'),
                )
              ],
              onChanged: (newFont) {
                bibleState.changeFont(newFont);
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Change theme"),
            trailing: DropdownButton(
              value: bibleState.currentTheme,
              items: [
                DropdownMenuItem(
                  value: 'softGreen',
                  child: Text('Green'),
                ),
                DropdownMenuItem(
                  value: 'brown',
                  child: Text('Brown'),
                ),
                DropdownMenuItem(
                  value: 'genie',
                  child: Text('Genie'),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text('Dark'),
                ),
              ],
              onChanged: (newValue) {
                bibleState.changeTheme(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }
}
