import 'package:flutter/material.dart';

import 'package:pocketbible/bloc/bible_bloc.dart';

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
            value: bibleState.viewSlider,
            onChanged: (bool newView) {
              bibleState.viewSlider = newView;
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
            label: "${bibleState.slider.toInt() + 14}",
            divisions: 10,
            value: bibleState.slider,
            onChanged: (double newSlider) {
              bibleState.slider = newSlider;
            },
          ),
          Divider(),
          ListTile(
            title: Text("Font"),
            subtitle: Text("Change font to your preference"),
            trailing: DropdownButton(
              value: bibleState.font,
              items: [
                DropdownMenuItem(
                  value: 'Montserrat',
                  child: Text(
                    'Montserrat',
                    style: TextStyle(fontFamily: 'Montserrat'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'OpenSans',
                  child: Text(
                    'OpenSans',
                    style: TextStyle(fontFamily: 'OpenSans'),
                  ),
                ),
                DropdownMenuItem(
                  value: 'Roboto',
                  child: Text(
                    'Roboto',
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                )
              ],
              onChanged: (String newFont) {
                bibleState.font = newFont;
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Change theme"),
            trailing: DropdownButton(
              value: bibleState.theme,
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
              onChanged: (String newTheme) {
                bibleState.theme = newTheme;
              },
            ),
          ),
          Card(
            color: Theme.of(context).canvasColor,
            child: ButtonBar(
              children: <Widget>[
                Container(
                  height: 90.0,
                  width: 90.0,
                  child: RaisedButton(
                    onPressed: () {
                      bibleState.theme = 'softGreen';
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green[200], Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 90.0,
                  width: 90.0,
                  child: RaisedButton(
                    onPressed: () {
                      bibleState.theme = 'brown';
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.brown.shade600, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 90.0,
                  width: 90.0,
                  child: RaisedButton(
                    onPressed: () {
                      bibleState.theme = 'genie';
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade300,
                            Colors.indigo.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 90.0,
                  width: 90.0,
                  child: RaisedButton(
                    onPressed: () {
                      bibleState.theme = 'dark';
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black, Colors.grey],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
