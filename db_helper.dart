import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT)');
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final db = await database;
    return await db.query('items');
  }

  Future<void> addItem(String name) async {
    final db = await database;
    await db.insert('items', {'name': name});
  }

  Future<void> updateItem(int id, String newName) async {
    final db = await database;
    await db.update('items', {'name': newName}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}