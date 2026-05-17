import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:g/data/datasources/db/database_helper.dart';
import 'package:g/data/models/movie_table.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late String databasePath;

  setUpAll(() async {
    final databasesDirectory = await getDatabasesPath();
    databasePath = '$databasesDirectory${Platform.pathSeparator}movie_app.db';
    await deleteDatabase(databasePath);
  });

  tearDownAll(() async {
    await deleteDatabase(databasePath);
  });

  test(
    'should create, upgrade, insert, query, and remove watchlist data',
    () async {
      final oldDatabase = await openDatabase(
        databasePath,
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
          CREATE TABLE watchlist (
            id INTEGER,
            title TEXT,
            overview TEXT,
            posterPath TEXT,
            PRIMARY KEY (id)
          );
        ''');
        },
      );

      await oldDatabase.insert('watchlist', const {
        'id': 1,
        'title': 'Old title',
        'overview': 'Old overview',
        'posterPath': '/old-poster.jpg',
      });
      await oldDatabase.close();

      final helper = DatabaseHelper();

      final database = await helper.database;
      expect(database, isNotNull);

      final upgradedRow = await helper.getWatchlistById(
        1,
        MovieTable.movieMediaType,
      );
      expect(upgradedRow, isNotNull);
      expect(upgradedRow?['mediaType'], MovieTable.movieMediaType);

      final insertedRows = await helper.insertWatchlist(const {
        'id': 2,
        'title': 'New title',
        'overview': 'New overview',
        'posterPath': '/new-poster.jpg',
        'mediaType': MovieTable.movieMediaType,
      });
      expect(insertedRows, 2);

      final rowsByMediaType = await helper.getWatchlistByMediaType(
        MovieTable.movieMediaType,
      );
      expect(rowsByMediaType, isNotEmpty);

      final removedRows = await helper.removeWatchlist(
        1,
        MovieTable.movieMediaType,
      );
      expect(removedRows, 1);

      final missingRow = await helper.getWatchlistById(
        1,
        MovieTable.movieMediaType,
      );
      expect(missingRow, isNull);
    },
  );
}
