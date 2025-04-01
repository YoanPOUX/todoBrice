import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/settings.dart'; // Import de SettingsPage
import 'ThemeProvider.dart'; // Import du ThemeProvider
import 'package:todo_list/services/TaskDatabase.dart'; // Import de TaskDatabase

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
          home: ToDoScreen(), // Remplace par ton widget home
        );
      },
    );
  }
}

class ToDoScreen extends StatefulWidget {
  @override
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? selectedDate;
  List<Map<String, dynamic>> taskList = [];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _addTask() async {
    if (_taskController.text.isNotEmpty && selectedDate != null) {
      // Crée un objet DateTime avec uniquement la date sélectionnée (sans heure)
      DateTime taskDateTime = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day);

      // Ajoute la tâche dans la base de données
      await TaskDatabase.instance.addTask(_taskController.text, taskDateTime);

      // Récupère toutes les tâches depuis la base de données après l'ajout
      List<Map<String, dynamic>> tasks = await TaskDatabase.instance.getAllTasks();

      setState(() {
        taskList = tasks; // Met à jour la liste des tâches
      });

      _taskController.clear();
      selectedDate = null;
    }
  }


  void _editTask(int index) {
    TextEditingController editController = TextEditingController(text: taskList[index]["task"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: "Update task label",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () async {
                // Passe également la date dans la méthode updateTask si nécessaire
                DateTime taskDateTime = DateTime(taskList[index]["date"].year,
                    taskList[index]["date"].month, taskList[index]["date"].day);

                // Met à jour la tâche en passant l'ID, le texte et la date
                await TaskDatabase.instance.updateTask(
                  taskList[index]["id"],
                  editController.text,
                  taskDateTime, // Ajouter la date si nécessaire
                );

                setState(() {
                  taskList[index]["task"] = editController.text;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _deleteTask(int index) {
    // Affichage du SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tâche supprimée'),
        duration: Duration(seconds: 3),
      ),
    );

    TaskDatabase.instance.deleteTask(taskList[index]["id"]);

    setState(() {
      taskList.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    print("initState appelé !");
    _loadTasks();
  }


  Future<void> _loadTasks() async {
    List<Map<String, dynamic>> tasks = await TaskDatabase.instance.getAllTasks();

    print("Tâches récupérées : $tasks"); // Vérifie si des tâches sont bien récupérées

    setState(() {
      taskList = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<ThemeProvider>(context).isDarkTheme;

    return Scaffold(
      backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        title: Text('ToDoBrice', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                "ToDoBrice Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Accueil'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ToDoScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Calendrier'),
              onTap: () {
                // Ajoute une page de calendrier plus tard
              },
            ),
            Spacer(), // Cela pousse "Settings" en bas
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          ToDoHeader(
            taskController: _taskController,
            selectDate: () => _selectDate(context),
            addTask: _addTask,
            selectedDate: selectedDate,
            isDarkTheme: isDarkTheme,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              color: isDarkTheme ? Colors.grey[800] : Colors.grey[200],
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          taskList[index]["task"],
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          "Due: ${taskList[index]["date"].day}/${taskList[index]["date"].month}/${taskList[index]["date"].year}",
                          style: TextStyle(
                            color: isDarkTheme ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editTask(index),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: isDarkTheme ? Colors.white30 : Colors.black38,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToDoHeader extends StatelessWidget {
  final TextEditingController taskController;
  final VoidCallback selectDate;
  final VoidCallback addTask;
  final DateTime? selectedDate;
  final bool isDarkTheme;

  ToDoHeader({
    required this.taskController,
    required this.selectDate,
    required this.addTask,
    required this.selectedDate,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkTheme ? Colors.grey[800] : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        children: [
          Text(
            "Add a task:",
            style: TextStyle(
              fontSize: 16,
              color: isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: "Label",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    hintStyle: TextStyle(
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, size: 30, color: isDarkTheme ? Colors.white : Colors.black),
                onPressed: selectDate,
              ),
            ],
          ),
          if (selectedDate != null)
            Text(
              "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(fontSize: 14, color: isDarkTheme ? Colors.white : Colors.grey),
            ),
          IconButton(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.purple),
            onPressed: addTask,
          ),
        ],
      ),
    );
  }
}
