import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/flash_card.dart';
class SQLiteHelper {
  static Database? _database;

  // Hàm mở cơ sở dữ liệu
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Hàm khởi tạo cơ sở dữ liệu
  static Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'flashcards.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  // Hàm tạo bảng flashcards
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE flashcards(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        questionImage TEXT,
        questionColor TEXT,
        answer TEXT,
        answerColor TEXT,
        audioFile TEXT,
        answerImage TEXT,
        listName TEXT
      )
    ''');
  }

  // Hàm xử lý khi nâng cấp phiên bản database (thêm trường answerImage)
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE flashcards ADD COLUMN answerImage TEXT;
      ''');
    }
  }

  // Thêm Flashcard vào cơ sở dữ liệu
  static Future<bool> insertFlashcard(Flashcard flashcard) async {
    final db = await database;
    try {
      await db.insert('flashcards', flashcard.toMap());
      return true; // Thành công
    } catch (e) {
      print('Error inserting flashcard: $e');
      return false; // Thất bại
    }
  }

  // Lấy flashcards theo tên danh sách
  static Future<List<Flashcard>> getFlashcardsByList(String listName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'flashcards',
      where: 'listName = ?',
      whereArgs: [listName],
    );
    return List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
  }

  // Cập nhật Flashcard
  static Future<bool> updateFlashcard(Flashcard flashcard) async {
    final db = await database;
    try {
      final result = await db.update(
        'flashcards',
        flashcard.toMap(),
        where: 'id = ?',
        whereArgs: [flashcard.id],
      );
      return result > 0; // Kiểm tra xem có bản ghi nào bị thay đổi hay không
    } catch (e) {
      print('Error updating flashcard: $e');
      return false; // Thất bại
    }
  }


  // Xóa Flashcard
  static Future<bool> deleteFlashcard(int id) async {
    final db = await database;
    try {
      final result = await db.delete(
        'flashcards',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0; // Kiểm tra xem có bản ghi nào bị xóa hay không
    } catch (e) {
      print('Error deleting flashcard: $e');
      return false; // Thất bại
    }
  }

  // Lấy tất cả flashcards theo từng listName (danh sách của các list flashcard),
// mỗi danh sách chỉ chứa tối đa 3 phần tử.
  static Future<List<List<Flashcard>>> getAllFlashcardsGroupedByList() async {
    final db = await database;

    // Lấy tất cả các tên danh sách
    final List<Map<String, dynamic>> listNamesMap = await db.rawQuery('SELECT DISTINCT listName FROM flashcards');

    List<List<Flashcard>> allFlashcards = [];

    // Lặp qua tất cả các tên danh sách để lấy flashcards cho mỗi listName
    for (var listNameMap in listNamesMap) {
      String listName = listNameMap['listName'] as String;

      // Lấy tối đa 3 flashcards cho từng listName
      final List<Map<String, dynamic>> flashcardsMap = await db.query(
        'flashcards',
        where: 'listName = ?',
        whereArgs: [listName],
      );

      // Chuyển đổi danh sách bản đồ thành danh sách flashcards
      List<Flashcard> flashcards = List.generate(flashcardsMap.length, (i) {
        return Flashcard.fromMap(flashcardsMap[i]);
      });

      // Thêm vào danh sách kết quả
      allFlashcards.add(flashcards);
    }

    return allFlashcards;
  }
  // Kiểm tra xem listName đã tồn tại hay chưa trong cơ sở dữ liệu
  static Future<bool> checkListNameExists(String listName) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'flashcards',
      where: 'listName = ?',
      whereArgs: [listName],
      limit: 1,
    );
    return result.isNotEmpty;
  }



}
