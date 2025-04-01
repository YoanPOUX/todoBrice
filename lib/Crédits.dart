import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupérer le thème actuel
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Crédits', style: TextStyle(color: Theme.of(context).primaryColorLight)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorLight),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.black, Colors.grey[900]!]
                : [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCreditCard(
                context,
                Icons.code,
                "Développeurs",
                "Thomas Bourdinot, Yoan Poux-Borries",
              ),
              _buildCreditCard(
                context,
                Icons.brush,
                "Design UI/UX",
                "Thomas Bourdinot, Yoan Poux-Borries",
              ),
              _buildCreditCard(
                context,
                Icons.build,
                "Technologies utilisées",
                "Flutter, Dart, SQLite, Provider",
              ),
              _buildCreditCard(
                context,
                Icons.favorite,
                "Remerciements",
                "Merci à la communauté open-source et aux contributeurs de Flutter.",
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text("Retour"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreditCard(BuildContext context, IconData icon, String title, String content) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
