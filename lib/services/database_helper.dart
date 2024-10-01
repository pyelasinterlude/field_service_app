import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/service_request.dart';

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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE service_requests (
        id TEXT PRIMARY KEY,
        clientName TEXT,
        description TEXT,
        category TEXT,
        status TEXT,
        date TEXT,
        location TEXT
      )
    ''');
  }

  Future<int> insertServiceRequest(ServiceRequest request) async {
    final db = await database;
    return await db.insert('service_requests', request.toMap());
  }

  Future<List<ServiceRequest>> getServiceRequests() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('service_requests');
    return List.generate(maps.length, (i) {
      return ServiceRequest.fromMap(maps[i]);
    });
  }
}