import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mylistv2/mylist.dart';

class DatabaseHelper {
  static final _databaseName = "mylistv2.db";
  static final _databaseVersion = 1;
  static final tablename = 'tbl_mylist';

  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? db;

  Future<Database> get database async {
    if (db != null) return db!;
    db = await _initDb();
    return db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tablename(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            status TEXT,
            date TEXT,
            imagename TEXT
          )
        ''');
      },
    );
  }

  // 🔹 CREATE
  Future<int> insertMyList(MyList mylist) async {
    final db = await database;
    return await db.insert(tablename, mylist.toMap());
  }
}
