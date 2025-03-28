import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkTheme = false; // État du thème sombre
  String language = "Français"; // Langue par défaut
  bool notificationsEnabled = false; // Notifications

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void _setLanguage(String? selectedLanguage) {
    if (selectedLanguage != null) {
      setState(() {
        language = selectedLanguage;
        print("Langue sélectionnée : $language"); // Debug print pour vérifier
      });
    }
  }

  void _toggleNotifications(bool? value) {
    setState(() {
      notificationsEnabled = value ?? false;
    });
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
            Container(
              padding: EdgeInsets.all(10),
              color: isDarkTheme ? Colors.grey : Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Thème Brice:",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: isDarkTheme,
                    onChanged: (value) => _toggleTheme(),
                    activeColor: Colors.purple,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              color: isDarkTheme ? Colors.grey : Colors.grey[300],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Langage:", style: TextStyle(color: Colors.white, fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Radio<String?>(
                            value: "Français",
                            groupValue: language, // Vérifie que le groupValue reflète correctement la variable "language"
                            onChanged: _setLanguage,
                            activeColor: Colors.purple,
                          ),
                          Text("Français", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<String?>(
                            value: "Anglais",
                            groupValue: language,
                            onChanged: _setLanguage,
                            activeColor: Colors.purple,
                          ),
                          Text("Anglais", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              color: isDarkTheme ? Colors.grey : Colors.grey[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Notifications:", style: TextStyle(color: Colors.white, fontSize: 16)),
                  Checkbox(
                    value: notificationsEnabled,
                    onChanged: _toggleNotifications,
                    activeColor: Colors.purple,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Langue actuelle : $language", // Affiche la langue sélectionnée
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
