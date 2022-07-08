import 'package:flutter/material.dart';
import 'package:wannasit_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

//models
import 'package:wannasit_client/models/appThemeModel/appThemeModel.dart';

class AppThemeProvider extends ChangeNotifier {
  late final SharedPreferences _prefs;
  Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  AppThemeModel get appTheme {
    int? getThemeMode = _prefs.getInt("themeMode");
    ThemeMode themeMode;
    if (getThemeMode == -1) {
      themeMode = ThemeMode.dark;
    } else if (getThemeMode == 1) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }

    int lightColor = _prefs.getInt("lightColor") ?? 0xff2196f3;

    int darkColor = _prefs.getInt("darkColor") ?? 0xff2196f3;

    return AppThemeModel(
      themeMode: themeMode,
      lightColor: lightColor,
      darkColor: darkColor,
    );
  }

  setAppTheme(AppThemeModel appTheme) async {
    int setThemeModel;
    if (appTheme.themeMode == ThemeMode.dark) {
      setThemeModel = -1;
    } else if (appTheme.themeMode == ThemeMode.light) {
      setThemeModel = 1;
    } else {
      setThemeModel = 0;
    }

    await _prefs.setInt("themeMode", setThemeModel);
    await _prefs.setInt("lightColor", appTheme.lightColor);
    await _prefs.setInt("darkColor", appTheme.darkColor);
    notifyListeners();
  }
}
