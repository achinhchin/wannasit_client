import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInColorSchemeProvider extends ChangeNotifier {
  final Color defaultColorScheme = Colors.blue;
  Color colorScheme = Colors.blue;

  set setColorScheme(Color newColorScheme) {
    colorScheme = newColorScheme;
    notifyListeners();
  }
}

