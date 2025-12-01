import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mylistv2/mylist.dart';

class DatabaseHelper {
  static final _databaseName = "mylistv2.db";
  static final _databaseVersion = 1;
  static final tablename = 'tbl_mylist';

  // Create a single shared instance of DatabaseHelper (Singleton pattern)
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  // Factory constructor → always returns the SAME instance above
  factory DatabaseHelper() {
    return _instance;
  }
  // Private named constructor → used only internally
  DatabaseHelper._internal();

  // Holds the database object (initially null until opened)
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!; // Database already loaded → return it
    _db = await _initDb(); // Otherwise, open/create the database
    return _db!; // Return the ready database
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tablename (
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

    final data = mylist.toMap();
    data.remove("id"); // ⬅️ Force auto-increment

    return await db.insert(tablename, data);
  }

  // 🔹 READ (Get all)
  // ---------------------------------------------------------
  // PAGINATION (limit + offset)
  // ---------------------------------------------------------
  Future<List<MyList>> getMyListsPaginated(int limit, int offset) async {
    final db = await database;
    // offset = offset - 1;
    print(offset);
    final List<Map<String, dynamic>> result = await db.query(
      tablename,
      orderBy: 'status DESC, id DESC',
      limit: limit,
      offset: offset,
      
    );

    return result.map((e) => MyList.fromMap(e)).toList();
  }

  // ---------------------------------------------------------
  // OPTIONAL HELPER: GET BY PAGE NUMBER
  // Example: page 0 = first page, page 1 = next page
  // ---------------------------------------------------------
  Future<List<MyList>> getPage(int pageNumber, int pageSize) async {
    int offset = pageNumber * pageSize;

    return await getMyListsPaginated(pageSize, offset);
  }

  // ---------------------------------------------------------
  // COUNT TOTAL NUMBER OF ROWS
  // ---------------------------------------------------------
  Future<int> getTotalCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM $tablename',
    );

    // result looks like: [{total: 25}]
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // 🔹 READ (Get one by ID)
  Future<MyList?> getMyListById(int id) async {
    final db = await database;
    final result = await db.query(tablename, where: 'id = ?', whereArgs: [id]);
    if (result.isNotEmpty) {
      return MyList.fromMap(result.first);
    }
    return null;
  }

  // 🔹 UPDATE
  Future<int> updateMyList(MyList mylist) async {
    final db = await database;
    return await db.update(
      tablename,
      mylist.toMap(),
      where: 'id = ?',
      whereArgs: [mylist.id],
    );
  }

  // 🔹 DELETE (by ID)
  Future<int> deleteMyList(int id) async {
    final db = await database;
    return await db.delete(tablename, where: 'id = ?', whereArgs: [id]);
  }

  // 🔹 DELETE ALL
  Future<int> deleteAll() async {
    final db = await database;
    return await db.delete(tablename);
  }

  // 🔹 SEARCH (by title or description)
  Future<List<MyList>> searchMyList(String keyword) async {
    final db = await database;
    final result = await db.query(
      tablename,
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%'],
      orderBy: 'id DESC',
    );
    return result.map((e) => MyList.fromMap(e)).toList();
  }

  // 🔹 CLOSE DATABASE
  Future<void> closeDb() async {
    final db = await database;
    await db.close();
  }
}
