import 'dart:async';

import 'package:movie_app/data/models/movie_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/movie_app.db';

    var db = await openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        mediaType TEXT,
        PRIMARY KEY (id, mediaType)
      );
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        'ALTER TABLE $_tblWatchlist RENAME TO ${_tblWatchlist}_old',
      );
      await _onCreate(db, newVersion);
      await db.execute('''
        INSERT INTO $_tblWatchlist (id, title, overview, posterPath, mediaType)
        SELECT id, title, overview, posterPath, '${MovieTable.movieMediaType}'
        FROM ${_tblWatchlist}_old
      ''');
      await db.execute('DROP TABLE ${_tblWatchlist}_old');
    }
  }

  Future<int> insertWatchlist(Map<String, dynamic> data) async {
    final db = await database;
    return await db!.insert(
      _tblWatchlist,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> removeWatchlist(int id, String mediaType) async {
    final db = await database;
    return await db!.delete(
      _tblWatchlist,
      where: 'id = ? AND mediaType = ?',
      whereArgs: [id, mediaType],
    );
  }

  Future<Map<String, dynamic>?> getWatchlistById(
    int id,
    String mediaType,
  ) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ? AND mediaType = ?',
      whereArgs: [id, mediaType],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistByMediaType(
    String mediaType,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'mediaType = ?',
      whereArgs: [mediaType],
    );

    return results;
  }
}
