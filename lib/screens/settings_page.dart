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
