import 'package:flutter/material.dart';
import 'package:todo_list/main.dart';

class EditTasksPage extends StatefulWidget{
  @override
  _EditTasksState createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasksPage> {

  String getLabel(){
    return "test11";
  }

  String getDetails(){
    return "a faire";
  }

  DateTime getDate(){
    return DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Tasks', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Label :", style: TextStyle(fontSize: 16, color: Colors.black),),
            TextFormField(initialValue: getLabel()),
            SizedBox(height:5),
            Text("Details :", style: TextStyle(fontSize: 16, color: Colors.black),),
            TextFormField(initialValue: getDetails()),
            SizedBox(height:5),
            Text("Date: ${getDate()!.day}/${getDate()!.month}/${getDate()!.year}", style: TextStyle(fontSize: 16, color: Colors.black),)
          ]
        ),
      ),
    );
  }
}
