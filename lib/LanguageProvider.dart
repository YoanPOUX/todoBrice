import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class LanguageProvider with ChangeNotifier {
  final FlutterLocalization localization;

  LanguageProvider(this.localization);

  void changeLanguage(String languageCode) {
    if (languageCode == 'Français') {
      localization.translate('fr');
    } else {
      localization.translate('en');
    }
    notifyListeners();
  }
}
