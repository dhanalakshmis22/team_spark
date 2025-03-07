import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fall_detection.db');
    return _database!;
  }

  Future<Database> _initDB(String path) async {
    final dbPath = await getDatabasesPath();
    final dbLocation = join(dbPath, path);

    return await openDatabase(dbLocation, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE elders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        age INTEGER,
        unique_id TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE caregivers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        elder_unique_id TEXT,
        FOREIGN KEY (elder_unique_id) REFERENCES elders (unique_id)
      )
    ''');
  }

  // ✅ Function to Register Elder
  Future<int> registerElder(String name, String email, String password, int age, String uniqueId) async {
    final db = await instance.database;
    return await db.insert('elders', {
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'unique_id': uniqueId,
    });
  }

  // ✅ Function to Register Caregiver
  Future<int> registerCaregiver(String name, String email, String password, String elderUniqueId) async {
    final db = await instance.database;
    return await db.insert('caregivers', {
      'name': name,
      'email': email,
      'password': password,
      'elder_unique_id': elderUniqueId,
    });
  }

  // ✅ Elder Login Function
  Future<Map<String, dynamic>?> elderLogin(String name, String password) async {
    final db = await instance.database;
    final result = await db.query('elders',
        where: 'name = ? AND password = ?', whereArgs: [name, password], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // ✅ Fetch Elder by Unique ID
  Future<Map<String, dynamic>?> getElderByUniqueId(String uniqueId) async {
    final db = await instance.database;
    final result = await db.query('elders', where: 'unique_id = ?', whereArgs: [uniqueId], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  // ✅ Fetch Caregiver by Elder ID
  Future<Map<String, dynamic>?> getCaregiverByElderId(String elderId) async {
    final db = await instance.database;
    final result = await db.query('caregivers', where: 'elder_unique_id = ?', whereArgs: [elderId], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }
}
