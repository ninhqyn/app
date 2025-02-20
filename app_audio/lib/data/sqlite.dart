import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'dart:async';

class FileDatabase {
  static final FileDatabase instance = FileDatabase._init();
  static Database? _database;

  // Định nghĩa các loại file
  static const String TYPE_AUDIO = 'audio';
  static const String TYPE_RINGTONE = 'ringtone';
  static const String TYPE_VIDEO = 'video';

  FileDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('files.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE files ADD COLUMN type TEXT NOT NULL DEFAULT "${TYPE_AUDIO}"');
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE files(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        path TEXT NOT NULL,
        size INTEGER NOT NULL,
        type TEXT NOT NULL
      )
    ''');
  }

  // Thêm file mới với type
  Future<int> saveFileInfo({
    required String name,
    required String path,
    required int size,
    required String type,
  }) async {
    final db = await database;
    final data = {
      'name': name,
      'path': path,
      'size': size,
      'type': type,
    };
    return await db.insert('files', data);
  }

  // Lấy tất cả files
  Future<List<Map<String, dynamic>>> getAllFiles() async {
    final db = await database;
    return await db.query('files');
  }

  // Lấy files theo type
  Future<List<Map<String, dynamic>>> getFilesByType(String type) async {
    final db = await database;
    return await db.query(
      'files',
      where: 'type = ?',
      whereArgs: [type],
    );
  }

  // Lấy file theo ID
  Future<Map<String, dynamic>?> getFile(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'files',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // Kiểm tra file đã tồn tại
  Future<bool> isFileExists(String path, String type) async {
    final db = await database;
    final result = await db.query(
      'files',
      where: 'path = ? AND type = ?',
      whereArgs: [path, type],
    );
    return result.isNotEmpty;
  }

  // Cập nhật file
  Future<int> updateFile(int id, {
    String? name,
    String? path,
    int? size,
    String? type,
  }) async {
    final db = await database;

    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (path != null) data['path'] = path;
    if (size != null) data['size'] = size;
    if (type != null) data['type'] = type;

    return await db.update(
      'files',
      data,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Xóa file
  Future<int> deleteFile(int id) async {
    final db = await database;
    return await db.delete(
      'files',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Xóa file theo đường dẫn và type
  Future<int> deleteFileByPath(String path, String type) async {
    final db = await database;
    return await db.delete(
      'files',
      where: 'path = ? AND type = ?',
      whereArgs: [path, type],
    );
  }

  // Tìm kiếm files theo tên và type
  Future<List<Map<String, dynamic>>> searchFiles({
    String? keyword,
    String? type,
  }) async {
    final db = await database;

    if (keyword != null && type != null) {
      return await db.query(
        'files',
        where: 'name LIKE ? AND type = ?',
        whereArgs: ['%$keyword%', type],
      );
    } else if (keyword != null) {
      return await db.query(
        'files',
        where: 'name LIKE ?',
        whereArgs: ['%$keyword%'],
      );
    } else if (type != null) {
      return await db.query(
        'files',
        where: 'type = ?',
        whereArgs: [type],
      );
    }

    return await db.query('files');
  }

  // Đóng database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
