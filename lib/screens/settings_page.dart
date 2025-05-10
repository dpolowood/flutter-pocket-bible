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
                            style: Theme.of(context).textTheme.headlineSmall,
                        ),
                    ),
                    SwitchListTile(
                        activeColor: Theme.of(context).secondaryHeaderColor,
                        title: Text(
                            "Text View",
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                            "Bulleted verses",
                            style: Theme.of(context).textTheme.titleSmall,
                        ),
                        value: bibleState.viewSlider,
                        onChanged: (bool newView) {
                            bibleState.viewSlider = newView;
                        },
                    ),
                    Divider(
                        height: 10,
                    ),
                    ListTile(
                        title: Text(
                            "Font Size",
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                            "Adjust font size",
                            style: Theme.of(context).textTheme.titleSmall,
                        ),
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
                        title: Text(
                            "Font",
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                            "Change font family",
                            style: Theme.of(context).textTheme.titleSmall,
                        ),
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
                        title: Text(
                            "Theme",
                            style: Theme.of(context).textTheme.titleLarge,
                        ),
                        subtitle: Text(
                            "Change theme",
                            style: Theme.of(context).textTheme.titleSmall,
                        ),
                        trailing: Text(bibleState.theme),
                    ),
                    Card(
                        color: Theme.of(context).canvasColor,
                        child: OverflowBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                                SizedBox(
                                    height: buttonSize,
                                    width: buttonSize,
                                    child: ElevatedButton(
                                        onPressed: () {
                                            bibleState.theme = 'soft green';
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(buttonSize)
                                            ),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                        ),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [Colors.green.shade200, Colors.white],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(buttonSize),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(
                                    height: buttonSize,
                                    width: buttonSize,
                                    child: ElevatedButton(
                                        onPressed: () {
                                            bibleState.theme = 'brown';
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(buttonSize)
                                            ),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                        ),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [Colors.brown.shade600, Colors.white],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(buttonSize),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(
                                    height: buttonSize,
                                    width: buttonSize,
                                    child: ElevatedButton(
                                        onPressed: () {
                                            bibleState.theme = 'genie';
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(buttonSize)
                                            ),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                        ),
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
                                                borderRadius: BorderRadius.circular(buttonSize),
                                            ),
                                        ),
                                    ),
                                ),
                                SizedBox(
                                    height: buttonSize,
                                    width: buttonSize,
                                    child: ElevatedButton(
                                        onPressed: () {
                                            bibleState.theme = 'dark';
                                        },
                                        style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(buttonSize)
                                            ),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                        ),
                                        child: Ink(
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: [Colors.black, Color(0x45475a)],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                ),
                                                borderRadius: BorderRadius.circular(buttonSize)
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
