import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SettingsDatabase {
  static final SettingsDatabase instance = SettingsDatabase._init();
  static Database? _database;

  SettingsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('settings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY,
            isDarkTheme INTEGER NOT NULL,
            language TEXT NOT NULL,
            notificationsEnabled INTEGER NOT NULL
          )
        ''');
        // Insérer des valeurs par défaut au départ
        db.insert('settings', {
          'id': 1,
          'isDarkTheme': 0,
          'language': 'Français',
          'notificationsEnabled': 0
        });
      },
    );
  }

  Future<void> saveSettings(bool isDarkTheme, String language, bool notificationsEnabled) async {
    final db = await instance.database;

    // Vérifie si la ligne existe déjà
    final result = await db.query('settings', where: 'id = ?', whereArgs: [1]);

    if (result.isEmpty) {
      // Si la ligne n'existe pas, on l'insère
      await db.insert('settings', {
        'id': 1,
        'isDarkTheme': isDarkTheme ? 1 : 0,
        'language': language,
        'notificationsEnabled': notificationsEnabled ? 1 : 0,
      });
    } else {
      // Sinon, on met à jour les paramètres existants
      await db.update(
        'settings',
        {
          'isDarkTheme': isDarkTheme ? 1 : 0,
          'language': language,
          'notificationsEnabled': notificationsEnabled ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [1],
      );
    }
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final db = await instance.database;
    final result = await db.query('settings', where: 'id = ?', whereArgs: [1]);

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
