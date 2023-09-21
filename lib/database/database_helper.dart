import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_app/database/model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // notes.db is db name
    return await _initDB('notes.db');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTERGER NOT NULL';
    db.execute('''
        CREATE TABLE $tableName
        (
          ${DatabaseFields.id} $idType,
          ${DatabaseFields.title} $textType,
          ${DatabaseFields.description} $textType,
          ${DatabaseFields.createdTime} $textType,
          ${DatabaseFields.number} $intType,
          ${DatabaseFields.isImportant} $boolType
        )
      ''');
    //can add mutiple tables..
  }

  Future<Notes> createNotes(Notes note) async {
    final db = await instance.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id); //check model for note.copy()
  }

  Future<Notes> readNotes(int id) async {
    final db = await instance.database;
    // we can put 'id' directly in pace of '?' , but it dont prevent sql injecttion,
    // hence its not safe.
    final maps = await db.query(
      tableName,
      where: '${DatabaseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Notes.fromJson(maps.first);
    } else {
      throw Exception('Id $id : Data not found');
    }
  }

  Future<List<Notes>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(
      tableName,
      orderBy: '${DatabaseFields.createdTime} ASC',
    );
    return result.map((json) => Notes.fromJson(json)).toList();
  }

  Future<int> updateNotes(Notes note) async {
    final db = await instance.database;
    return db.update(
      tableName,
      note.toJson(),
      where: '${DatabaseFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNotes(int id) async {
    final db = await instance.database;
    return db.delete(
      tableName,
      where: '${DatabaseFields.id}=?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
