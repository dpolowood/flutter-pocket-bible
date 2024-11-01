import 'package:flutter/material.dart';

import 'package:pocketbible/bloc/bible_bloc.dart';

class SettingsPage extends StatelessWidget {
  final BibleBloc bibleState;

  SettingsPage(this.bibleState);

  @override
  Widget build(BuildContext context) {
    var buttonSize = MediaQuery.of(context).size.width / 5;

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
            activeColor: Theme.of(context).secondaryHeaderColor,
            title: Text("Text View"),
            subtitle: Text("Bulleted verses"),
            value: bibleState.viewSlider,
            onChanged: (bool newView) {
              bibleState.viewSlider = newView;
            },
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            title: Text("Font Size"),
            subtitle: Text("Adjust font size"),
          ),
          Slider(
            activeColor: Theme.of(context).secondaryHeaderColor,
            min: 0.0,
            max: 10.0,
            label: "${bibleState.fontSize}",
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
              onChanged: (String? newFont) {
                bibleState.font = newFont;
              },
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Theme"),
            subtitle: Text("Change theme"),
            trailing: Text(bibleState.theme),
          ),
          Card(
            color: Theme.of(context).canvasColor,
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: buttonSize,
                  width: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      bibleState.theme = 'soft green';
                    },
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    // padding: EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade200, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: buttonSize,
                  width: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      bibleState.theme = 'brown';
                    },
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    // padding: EdgeInsets.all(0.0),
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
                  height: buttonSize,
                  width: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      bibleState.theme = 'genie';
                    },
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    // padding: EdgeInsets.all(0.0),
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
                  height: buttonSize,
                  width: buttonSize,
                  child: ElevatedButton(
                    onPressed: () {
                      bibleState.theme = 'dark';
                    },
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(5.0),
                    // ),
                    // padding: EdgeInsets.all(0.0),
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
