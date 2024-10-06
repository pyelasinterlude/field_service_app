import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/service_request.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('field_service.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE service_requests(
        id TEXT PRIMARY KEY,
        clientName TEXT,
        description TEXT,
        category TEXT,
        status TEXT,
        date TEXT,
        location TEXT,
        imageUrl TEXT,
        isSynced INTEGER
      )
    ''');
  }

  Future<List<User>> getUsers() async {
    Database db = await database;
    var maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<int> deleteUser(String userId) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> insertServiceRequest(ServiceRequest request) async {
    final db = await database;
    await db.insert('service_requests', request.toMap());
  }

  Future<List<ServiceRequest>> getUnSyncedRequests() async {
    final db = await database;
    final maps = await db.query(
      'service_requests',
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    return List.generate(maps.length, (i) => ServiceRequest.fromMap(maps[i]));
  }

  Future<void> markAsSynced(String id) async {
    final db = await database;
    await db.update(
      'service_requests',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}