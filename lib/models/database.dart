import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const DB_VERSION = 1;
const DB_NAME = "noName.sqlite.db";

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);

    return await openDatabase(path, version: DB_VERSION, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // await db.execute(CH.createTable);
    });
  }
}
