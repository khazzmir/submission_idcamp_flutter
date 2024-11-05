import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'drink_tracker.db');

    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE drink_data (
            id INTEGER PRIMARY KEY,
            currentDrink INTEGER,
            targetDrink INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertInitialData() async {
    final db = await database;
    await db.insert(
      'drink_data',
      {'currentDrink': 0, 'targetDrink': 2000},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>> getDrinkData() async {
    final db = await database;
    final data = await db.query('drink_data', limit: 1);
    return data.isNotEmpty ? data.first : {'currentDrink': 0, 'targetDrink': 2000};
  }

  Future<void> updateDrink(int drinkAmount) async {
    final db = await database;
    await db.update('drink_data', {'currentDrink': drinkAmount}, where: 'id = ?', whereArgs: [1]);
  }

  Future<void> updateTarget(int newTarget) async {
    final db = await database;
    await db.update('drink_data', {'targetDrink': newTarget}, where: 'id = ?', whereArgs: [1]);
  }
}
