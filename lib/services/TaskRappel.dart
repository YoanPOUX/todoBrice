import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TaskRappelDatabase {
  static final TaskRappelDatabase instance = TaskRappelDatabase._init();

  static Database? _database;

  TaskRappelDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('task_rappel.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE task_rappel(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          taskId INTEGER, 
          dateTime TEXT,
          FOREIGN KEY (taskId) REFERENCES tasks(id)
        )
      ''');
    });
  }

  // Ajouter un rappel (ou le mettre à jour si une tâche existe déjà)
  Future<int> addOrUpdateRappel(int taskId, DateTime dateTime) async {
    final db = await instance.database;

    // Vérifier si un rappel existe déjà pour cette tâche
    final existingRappel = await db.query(
      'task_rappel',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );

    if (existingRappel.isNotEmpty) {
      // Mettre à jour le rappel existant si une ligne est trouvée
      return await db.update(
        'task_rappel',
        {'dateTime': dateTime.toIso8601String()},
        where: 'taskId = ?',
        whereArgs: [taskId],
      );
    } else {
      // Ajouter un nouveau rappel pour cette tâche si aucun n'existe
      return await db.insert(
        'task_rappel',
        {
          'taskId': taskId,
          'dateTime': dateTime.toIso8601String(),
        },
      );
    }
  }

  // Récupérer tous les rappels
  Future<List<TaskRappel>> getAllRappels() async {
    final db = await instance.database;
    final result = await db.query('task_rappel');
    return result.map((map) => TaskRappel.fromMap(map)).toList();
  }
}
