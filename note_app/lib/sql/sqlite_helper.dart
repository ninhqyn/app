import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../model/note.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';


class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'notes.db';
  static const String tableName = 'notes';

  // Hàm để mở hoặc tạo mới cơ sở dữ liệu
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Hàm khởi tạo cơ sở dữ liệu
  _initDatabase() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, dbName);

    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  // Hàm tạo bảng
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        image BLOB
      )
    ''');
  }

  // Hàm thêm ghi chú
  Future<int> addNote(Note note) async {
    final db = await database;
    return await db.insert(tableName, note.toMap());
  }

  // Hàm lấy tất cả ghi chú
  Future<List<Note>> getNotes() async {
    final db = await database;
    var result = await db.query(tableName);
    List<Note> notes = result.isNotEmpty
        ? result.map((map) => Note.fromMap(map)).toList()
        : [];
    return notes;
  }

  // Hàm lấy một ghi chú theo ID
  Future<Note?> getNoteById(int id) async {
    final db = await database;
    var result = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return Note.fromMap(result.first);
    }
    return null;
  }

  // Hàm cập nhật ghi chú
  Future<int> updateNote(Note note) async {
    final db = await database;
    return await db.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Hàm xóa ghi chú
  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
