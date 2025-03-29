import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/SettingsDatabase.dart';
import 'ThemeProvider.dart'; // Import du ThemeProvider

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false;
  String language = "Français";
  bool notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsDatabase.instance.loadSettings();
    if (settings != null) {
      setState(() {
        isDarkTheme = settings['isDarkTheme'] == 1;
        language = settings['language'];
        notificationsEnabled = settings['notificationsEnabled'] == 1;
      });
    }
  }

  Future<void> _saveSettings() async {
    // Sauvegarde des paramètres dans la base de données
    await SettingsDatabase.instance.saveSettings(isDarkTheme, language, notificationsEnabled);

    // Si le thème a changé, applique le changement
    bool currentTheme = Provider.of<ThemeProvider>(context, listen: false).isDarkTheme;
    if (currentTheme != isDarkTheme) {
      // Applique uniquement si le thème change
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    }

    // Affichage des paramètres pour vérification
    print("Paramètres enregistrés :");
    print("Thème sombre: $isDarkTheme");
    print("Langue: $language");
    print("Notifications activées: $notificationsEnabled");
  }



  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDarkTheme;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
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
              onPressed: _saveSettings,
              child: Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Thème sombre:", style: TextStyle(fontSize: 16, color: isDarkTheme ? Colors.white : Colors.black)),
        Switch(
          value: isDarkTheme,
          onChanged: (value) {
            setState(() {
              isDarkTheme = value;
            });

            // Mettre à jour le provider pour changer le thème globalement
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
          activeColor: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Langue:", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
        Row(
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
            Text("Français", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
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
            Text("Anglais", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notifications:", style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
        Checkbox(
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value!;
            });
          },
          activeColor: Colors.purple,
        ),
      ],
    );
  }
}
