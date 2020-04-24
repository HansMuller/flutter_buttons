# flutter_buttons
A prototype implementation of the new design for buttons and button themes.

For more information about the design and to provide feedback please visit:

 - The "Updating the Material Buttons and their Themes" design document at https://flutter.dev/go/material-button-system-updates.
 - The corresponding Flutter GitHub issue: Updating the Material Buttons and their Themes [#54776](https://github.com/flutter/flutter/issues/54776).

Here's a trivial example of the new button classes and their themes:

```dart
// pubspec.yaml must contain a dependency on the prototype flutter_buttons package
//
//  flutter_buttons:
//    git: git@github.com:HansMuller/flutter_buttons.git


import 'package:flutter/material.dart';

import 'package:flutter_buttons/flutter_buttons.dart';

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextButton (
            onPressed: () { },
            child: Text('TextButton'),
          ),
          SizedBox(height: 16),
          ContainedButton(
            onPressed: () { print('ContainedButton'); },
            child: Text('ContainedButton'),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: () { },
            child: Text('OutlinedButton'),
          ),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextStyle headline4 = Theme.of(context).textTheme.headline4;
    return Scaffold(
      // Change the text style for the 3 button types to headline4.
      // No ThemeData integration yet, so the button themes have
      // be nested.
      body: TextButtonTheme(
        data: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: headline4,
          ),
        ),
        child: ContainedButtonTheme(
          data: ContainedButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: headline4,
            ),
          ),
          child: OutlinedButtonTheme(
            data: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                textStyle: headline4,
              ),
            ),
            child: Buttons(),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Home()));
}
```