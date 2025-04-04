import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/SettingsDatabase.dart';
import 'LanguageProvider.dart';
import 'ThemeProvider.dart'; // Import du ThemeProvider
import 'package:flutter_localization/flutter_localization.dart';

import 'app_locale.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false; // Valeur locale pour le thème
  bool isDarkThemeApplied = false; // Valeur temporaire pour l'application du thème
  String language = "Français";
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Charger les paramètres enregistrés depuis la base de données
  Future<void> _loadSettings() async {
    final settings = await SettingsDatabase.instance.loadSettings();
    if (settings != null) {
      setState(() {
        isDarkTheme = settings['isDarkTheme'] == 1;
        language = settings['language'];
        notificationsEnabled = settings['notificationsEnabled'] == 1;
        isDarkThemeApplied = settings['isDarkTheme'] == 1; // Appliquer le thème initial
      });
    }
  }

  // Enregistrer les paramètres dans la base de données et mettre à jour le thème
  Future<void> _saveSettings() async {
    // Sauvegarder dans la base de données
    await SettingsDatabase.instance.saveSettings(isDarkTheme, language, notificationsEnabled);

    // Mettre à jour le thème globalement en fonction de la valeur de isDarkTheme
    Provider.of<ThemeProvider>(context, listen: false).updateTheme(isDarkTheme);

    setState(() {
      // Appliquer le thème définitivement après l'enregistrement
      isDarkThemeApplied = isDarkTheme;
    });
    Provider.of<LanguageProvider>(context, listen: false).changeLanguage(language);


    // Afficher les paramètres pour débogage
    print("Paramètres enregistrés :");
    print("Thème sombre: $isDarkTheme");
    print("Langue: $language");
    print("Notifications activées: $notificationsEnabled");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkThemeApplied ? Colors.grey[900] : Colors.white, // Fond adapté au thème
      appBar: AppBar(
        title: Text(AppLocale.textOne.getString(context), style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4, // Ajout d'une légère ombre pour plus de profondeur
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionTitle(AppLocale.textTwo.getString(context)),
            _buildThemeToggle(),
            SizedBox(height: 20),
            _buildSectionTitle(AppLocale.textFour.getString(context)),
            _buildLanguageSelector(),
            SizedBox(height: 20),
            _buildSectionTitle('Notifications'),
            _buildNotificationsToggle(),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text(
                AppLocale.textEight.getString(context),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Couleur du texte en blanc
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Couleur de fond principale
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Bordures plus arrondies
                ),
                elevation: 10, // Ombrage plus marqué
              ).copyWith(
                shadowColor: MaterialStateProperty.all(Colors.purpleAccent.withOpacity(0.6)), // Ombre plus accentuée
              ),
            )


          ],
        ),
      ),
    );
  }

  // Section titre
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDarkThemeApplied ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Switch pour changer le thème sombre
  Widget _buildThemeToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocale.textThree.getString(context), style: TextStyle(fontSize: 16)),
          Switch(
            value: isDarkTheme, // Change la valeur locale
            onChanged: (value) {
              setState(() {
                isDarkTheme = value; // Modifie uniquement la valeur locale du thème
              });
            },
            activeColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  // Sélecteur de langue
  Widget _buildLanguageSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Radio<String>(
            value: "Français",
            groupValue: language,
            onChanged: (value) {
              setState(() {
                language = value!;
              });
            },
            activeColor: Colors.purple,
          ),
          Text(AppLocale.textFive.getString(context)),
          SizedBox(width: 20),
          Radio<String>(
            value: "Anglais",
            groupValue: language,
            onChanged: (value) {
              setState(() {
                language = value!;
              });
            },
            activeColor: Colors.purple,
          ),
          Text(AppLocale.textSix.getString(context)),
        ],
      ),
    );
  }

  // Toggle pour activer/désactiver les notifications
  Widget _buildNotificationsToggle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(AppLocale.textSix.getString(context), style: TextStyle(fontSize: 16)),
          Checkbox(
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value!; // Modifier uniquement la valeur locale
              });
            },
            activeColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}
