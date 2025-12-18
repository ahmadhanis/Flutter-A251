import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/sweetspot.dart';

class DBService {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'sweetspot.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE spots(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            imagePath TEXT NOT NULL,
            lat REAL NOT NULL,
            lng REAL NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> updateSpot(SweetSpot spot) async {
    final db = await database;
    return db.update(
      'spots',
      spot.toMap(),
      where: 'id=?',
      whereArgs: [spot.id],
    );
  }

  Future<int> insertSpot(SweetSpot spot) async {
    final db = await database;
    return db.insert(
      'spots',
      spot.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SweetSpot>> getAllSpots() async {
    final db = await database;
    final result = await db.query('spots', orderBy: 'id DESC');
    return result.map((e) => SweetSpot.fromMap(e)).toList();
  }

  Future<int> deleteSpot(int id) async {
    final db = await database;
    return db.delete('spots', where: 'id=?', whereArgs: [id]);
  }
}
