import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/SettingsDatabase.dart';
import 'ThemeProvider.dart'; // Import du ThemeProvider

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

    // Afficher les paramètres pour débogage
    print("Paramètres enregistrés :");
    print("Thème sombre: $isDarkTheme");
    print("Langue: $language");
    print("Notifications activées: $notificationsEnabled");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkThemeApplied ? Colors.grey[900] : Colors.white, // Utiliser isDarkThemeApplied pour le fond
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildThemeToggle(),
            SizedBox(height: 20),
            _buildLanguageSelector(),
            SizedBox(height: 20),
            _buildNotificationsToggle(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings, // Applique le thème uniquement après l'enregistrement
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }

  // Switch pour changer le thème sombre
  Widget _buildThemeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Thème sombre:", style: TextStyle(fontSize: 16)),
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
    );
  }

  // Sélecteur de langue
  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langue:"),
        Row(
          children: [
            Radio<String>( // Langue Française
              value: "Français",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
              activeColor: Colors.purple,
            ),
            Text("Français"),
            Radio<String>( // Langue Anglaise
              value: "Anglais",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
              activeColor: Colors.purple,
            ),
            Text("Anglais"),
          ],
        ),
      ],
    );
  }

  // Toggle pour activer/désactiver les notifications
  Widget _buildNotificationsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notifications:"),
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
    );
  }
}
