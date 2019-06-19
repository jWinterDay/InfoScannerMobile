import 'package:flutter/material.dart';
import 'package:flutter_redux_dev_tools/flutter_redux_dev_tools.dart';
import 'package:preferences/dropdown_preference.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';

import 'package:info_scanner_mobile/resources/constants.dart';
import 'package:info_scanner_mobile/global_store.dart';



class PrefSettings extends StatefulWidget {
  @override
  _PrefSettingsState createState() => _PrefSettingsState();
}

class _PrefSettingsState extends State<PrefSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      endDrawer: Constants.isProduction ? null : ReduxDevTools(globalStore),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Start Page',
          'start_page',
          defaultVal: 'Timeline',
          values: ['Posts', 'Timeline', 'Private Messages'],
        ),

        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),

        PreferenceTitle('Else'),
        CheckboxPreference('fgds', 'gfd'),
      ]),
    );
  }
}