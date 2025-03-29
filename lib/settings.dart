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
    await SettingsDatabase.instance.saveSettings(isDarkTheme, language, notificationsEnabled);
    print("Paramètres enregistrés :");
    print("Thème sombre: $isDarkTheme");
    print("Langue: $language");
    print("Notifications activées: $notificationsEnabled");
  }

  @override
  Widget build(BuildContext context) {
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
        Text("Thème sombre:", style: TextStyle(fontSize: 16)),
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
        Text("Langue:"),
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
            Text("Français"),
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
            Text("Anglais"),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Notifications:"),
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
