import 'dart:async';

import 'package:core/domain/entities/filter_type.dart';
import 'package:watch_list/data/models/filter_type_key.dart';
import 'package:sqflite/sqflite.dart';
import 'package:watch_list/data/models/movie_table.dart';
import 'package:watch_list/data/models/tv_series_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        type TEXT,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlist({
    MovieTable? movie,
    TvSeriesTable? tvSeries,
  }) async {
    final db = await database;
    if (movie != null || tvSeries != null) {
      final dataToSave = movie != null ? movie.toJson() : tvSeries!.toJson();
      return await db!.insert(
        _tblWatchlist,
        dataToSave,
      );
    }
    return -1;
  }

  Future<int> removeWatchlist({
    MovieTable? movie,
    TvSeriesTable? tvSeries,
  }) async {
    final db = await database;
    if (movie != null || tvSeries != null) {
      return await db!.delete(
        _tblWatchlist,
        where: 'id = ?',
        whereArgs: [movie?.id ?? tvSeries?.id],
      );
    }
    return -1;
  }

  Future<Map<String, dynamic>?> getWatchItemById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getWatchlist(FilterType type) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db!.query(
      _tblWatchlist,
      where: 'type = ?',
      whereArgs: [
        type.dbKey,
      ],
    );

    return results;
  }
}
