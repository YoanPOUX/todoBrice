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
      version: 2, // Mets à jour la version de la base de données ici
      onCreate: (db, version) async {
        // Créer la table des tâches lors de la création de la base
        await db.execute(''' 
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          task TEXT NOT NULL,
          date TEXT
        )
      ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Si la version est inférieure à 2, recréer la table
          await db.execute(''' 
          CREATE TABLE tasks (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            task TEXT NOT NULL,
            date TEXT
          )
        ''');
        }
      },
    );
  }


  // Ajouter une tâche (stocke uniquement la date)
  Future<void> addTask(String task, DateTime date) async {
    final db = await instance.database;
    await db.insert(
      'tasks',
      {
        'task': task,
        'date': date.toIso8601String().split('T')[0],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print("Tâche ajoutée : $task - ${date.toIso8601String().split('T')[0]}");
  }


  // Modifier une tâche (mise à jour du texte et de la date)
  Future<void> updateTask(int id, String newTask, DateTime newDate) async {
    final db = await instance.database;
    await db.update(
      'tasks',
      {
        'task': newTask,
        'date': newDate.toIso8601String().split('T')[0],
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

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> tasks = await db.query('tasks');

    print("Données brutes de la BD : $tasks"); // Vérifie les données récupérées

    return tasks.map((task) {
      String? dateString = task['date'];

      // Vérifie que la date est bien au format attendu
      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(dateString!);
      } catch (e) {
        print("Erreur de parsing de la date : $dateString - Erreur : $e");
      }

      return {
        'id': task['id'],
        'task': task['task'],
        'date': parsedDate, // Utilise null si la conversion échoue
      };
    }).toList();
  }



  // Fermer la base de données
  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<void> resetDatabase() async {
    final db = await instance.database;
    // Supprimer la table des tâches
    await db.execute('DROP TABLE IF EXISTS tasks');
    print("Table 'tasks' supprimée");

    // Recréer la table
    await db.execute(''' 
    CREATE TABLE tasks (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task TEXT NOT NULL,
      date TEXT
    )
  ''');
    print("Table 'tasks' recréée !");
  }


}


