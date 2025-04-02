import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/SettingsDatabase.dart';
import '../services/TaskDatabase.dart';
import 'ThemeProvider.dart'; // Import du ThemeProvider
import 'package:intl/intl.dart';

class PageCalendrier extends StatefulWidget {
  @override
  _PageCalendrierState createState() => _PageCalendrierState();
}

class _PageCalendrierState extends State<PageCalendrier> {
  DateTime selectedDate = DateTime.now(); // Date sélectionnée pour le calendrier
  Map<DateTime, List<String>> tasksByMonth = {}; // Map pour stocker les tâches par mois

  @override
  void initState() {
    super.initState();
    _loadTasksForAllMonths();
  }

  Future<void> _loadTasksForAllMonths() async {
    // Récupérer toutes les tâches depuis la base de données
    final tasks = await TaskDatabase.instance.getAllTasks();
    print("Données brutes récupérées : $tasks");

    setState(() {
      tasksByMonth.clear(); // Réinitialiser les tâches

      // Parcourir les tâches récupérées
      for (var task in tasks) {
        DateTime? taskDate = task['date']; // Récupérer le DateTime de la tâche

        if (taskDate != null) {
          DateTime firstDayOfMonth = DateTime(taskDate.year, taskDate.month, 1); // Premier jour du mois
          if (!tasksByMonth.containsKey(firstDayOfMonth)) {
            tasksByMonth[firstDayOfMonth] = [];
          }
          tasksByMonth[firstDayOfMonth]!.add(task['task']); // Ajouter la tâche au mois correspondant
        }
      }
    });
  }

  // Sélectionner le mois précédent
  void _previousMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month - 1);
    });
    _loadTasksForAllMonths(); // Recharger les tâches pour le mois précédent
  }

  // Sélectionner le mois suivant
  void _nextMonth() {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + 1);
    });
    _loadTasksForAllMonths(); // Recharger les tâches pour le mois suivant
  }

  // Sélectionner un mois via un date picker
  void _selectMonth() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = DateTime(
            picked.year, picked.month); // Mettre à jour le mois sélectionné
      });
      _loadTasksForAllMonths(); // Recharger les tâches après la sélection
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendrier', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sélecteur de mois avec flèches pour changer de mois et icône calendrier
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Flèche gauche
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: _previousMonth, // Aller au mois précédent
                  ),
                  Text(
                    DateFormat('MMMM yyyy').format(selectedDate),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // Flèche droite
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: _nextMonth, // Aller au mois suivant
                  ),
                  // Icône calendrier pour sélectionner un mois
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: _selectMonth, // Ouvre le sélecteur de mois
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Affichage des tâches du mois sélectionné
              ListView.builder(
                shrinkWrap: true, // Permet à la liste de ne pas occuper tout l'espace
                itemCount: tasksByMonth.keys.length, // Nombre de mois dans tasksByMonth
                itemBuilder: (context, index) {
                  DateTime month = tasksByMonth.keys.elementAt(index);
                  // Afficher les tâches uniquement pour le mois sélectionné
                  if (month.month == selectedDate.month && month.year == selectedDate.year) {
                    List<String> tasks = tasksByMonth[month] ?? [];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(month), // Affiche le mois
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: tasks.map((task) {
                                return ListTile(
                                  title: Text(task),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(); // Ne rien afficher pour les autres mois
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
