import 'package:flutter/material.dart';
import 'package:todo_list/settings.dart';
import 'package:todo_list/editTasks.dart';


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

  void _editTask(int index) {
    TextEditingController editController =
    TextEditingController(text: taskList[index]["task"]);

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
              onPressed: () {
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
    setState(() {
      taskList.removeAt(index);
    });
  }

  void _openSettings() {
    print("Navigate to Settings page"); // Future implementation: Navigate to settings.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('ToDoBrice', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white), // Set the burger icon color to white
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => EditTasksPage(index)),
                            );
                          }
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
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
      child: Column(
        children: [
          Text(
            "Add a task:",
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, size: 30, color: Colors.black),
                onPressed: selectDate,
              ),
            ],
          ),
          if (selectedDate != null)
            Text(
              "Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
              style: TextStyle(fontSize: 14, color: Colors.grey),
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
