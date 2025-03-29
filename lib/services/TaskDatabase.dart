import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // Version initiale de la base de données
      onCreate: (db, version) async {
        // Table pour les tâches
        await db.execute(''' 
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL
          )
        ''');
      },
    );
  }

  // Ajouter une tâche
  Future<void> addTask(String task, DateTime dateTime) async {
    final db = await instance.database;
    await db.insert(
      'tasks',
      {
        'task': task,
        'date': dateTime.toIso8601String().split('T')[0], // La date sans l'heure
        'time': dateTime.toIso8601String().split('T')[1], // L'heure seule
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Modifier une tâche
  Future<void> updateTask(int id, String newTask, DateTime newDateTime) async {
    final db = await instance.database;
    await db.update(
      'tasks',
      {
        'task': newTask,
        'date': newDateTime.toIso8601String().split('T')[0],
        'time': newDateTime.toIso8601String().split('T')[1],
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Supprimer une tâche
  Future<void> deleteTask(int id) async {
    final db = await instance.database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Récupérer toutes les tâches
  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> tasks = await db.query('tasks');

    // Convertir les dates en DateTime
    return tasks.map((task) {
      DateTime taskDateTime = DateTime.parse('${task['date']} ${task['time']}');
      return {
        'id': task['id'],
        'task': task['task'],
        'date': taskDateTime, // DateTime reconstituée
      };
    }).toList();
  }

  // Fermer la base de données
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
