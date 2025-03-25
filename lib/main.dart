import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900], // Couleur d'arrière-plan
        appBar: AppBar(
          title: Text('Home', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(
          children: [
            ToDoHeader(),
          ],
        ),
      ),
    );
  }
}

class ToDoHeader extends StatelessWidget {
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
                  Container(
                    height: 35,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Label",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Icones de droite : calendrier et profil
          Row(
            children: [
              Icon(Icons.calendar_today, size: 30, color: Colors.black),
              SizedBox(width: 15),
              CircleAvatar(
                backgroundColor: Colors.purple[200],
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
