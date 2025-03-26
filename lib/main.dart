import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoScreen(),
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
  List<Map<String, dynamic>> taskList = []; // Liste des tâches

  // Fonction pour ouvrir le sélecteur de date
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

  // Fonction pour ajouter une tâche à la liste
  void _addTask() {
    if (_taskController.text.isNotEmpty && selectedDate != null) {
      setState(() {
        taskList.add({
          "task": _taskController.text,
          "date": selectedDate!,
        });
        _taskController.clear();
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          ToDoHeader(
            taskController: _taskController,
            selectDate: () => _selectDate(context),
            addTask: _addTask,
            selectedDate: selectedDate,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(taskList[index]["task"]),
                    subtitle: Text(
                      "Due: ${taskList[index]["date"].day}/${taskList[index]["date"].month}/${taskList[index]["date"].year}",
                    ),
                    trailing: Checkbox(
                      value: true,
                      onChanged: (bool? value) {},
                    ),
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

  ToDoHeader({
    required this.taskController,
    required this.selectDate,
    required this.addTask,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre et icône Menu
          Row(
            children: [
              Icon(Icons.menu, size: 30, color: Colors.black),
              SizedBox(width: 10),
              Text(
                "To Do Brice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Section centrale avec "Add a task" et le champ texte
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    "Add a task :",
                    style: TextStyle(fontSize: 16, color: Colors.black),
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
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today,
                            size: 30, color: Colors.black),
                        onPressed: selectDate,
                      ),
                    ],
                  ),
                  if (selectedDate != null)
                    Text(
                      "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ),

          // Bouton pour ajouter la tâche
          IconButton(
            icon: Icon(Icons.add_circle, size: 40, color: Colors.purple),
            onPressed: addTask,
          ),
        ],
      ),
    );
  }
}
