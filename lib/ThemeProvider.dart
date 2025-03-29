import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  // Initialisation du thème en fonction de SharedPreferences
  ThemeProvider() {
    _loadTheme();
  }

  // Méthode pour charger le thème depuis SharedPreferences
  _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool('isDarkTheme') ?? false; // Par défaut, thème clair
    notifyListeners();
  }

  // Méthode pour changer le thème et enregistrer dans SharedPreferences
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = !_isDarkTheme;
    await prefs.setBool('isDarkTheme', _isDarkTheme);
    notifyListeners();
  }
}
