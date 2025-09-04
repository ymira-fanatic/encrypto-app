import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBService {
  DBService._privateConstructor();
  static final DBService instance = DBService._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "crypto.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plaintext TEXT,
        ciphertext TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<void> insertData({
    required String plaintext,
    required String ciphertext,
  }) async {
    Database db = await instance.database;
    await db.insert(
      "records",
      {
        "plaintext": plaintext,
        "ciphertext": ciphertext,
        "timestamp": DateTime.now().toIso8601String(),
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    Database db = await instance.database;
    return await db.query(
      "records",
      orderBy: "id DESC",
    );
  }
}
