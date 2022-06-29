import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageColorSchemeProvider  extends ChangeNotifier {
  final Color defaultColorScheme = Colors.blue;
  Color colorScheme = Colors.blue;

  set setColorScheme(Color newColorScheme) {
    colorScheme = newColorScheme;
    notifyListeners();
  }
}

