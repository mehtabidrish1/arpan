import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/api_constants.dart';

class DatabaseHelper {
  static Database? database;
  static String? dbPath;

  Future init() async {
    var databasePath = await getDatabasesPath();
    var path = join(databasePath, 'arpanDb.db');
    dbPath = path;
    var exists = await databaseExists(path);
    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "arpanDb.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    database = await openDatabase(
      path,
      version: 5,
      onUpgrade: (db, oldVersion, newVersion) =>
          onUpgrade(db, oldVersion, newVersion),
    );

    return database;
  }

  FutureOr<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await addColumnIfNotExists(
          db, Constants.Survey_Response, "IsEdited", "INTEGER");
      await addColumnIfNotExists(db, Constants.Training_HandHolding,
          "AttendingPSEArpanTraining", "TEXT");
      await addColumnIfNotExists(
          db, Constants.Training_HandHolding, "ModeOfGroupMeeting", "TEXT");
      await addColumnIfNotExists(db, Constants.Training_HandHolding,
          "AttendanceParticipantMobileNo", "TEXT");
      await addColumnIfNotExists(
          db, Constants.Training_HandHolding, "StateId", "TEXT");
      await addColumnIfNotExists(
          db, Constants.Training_HandHolding, "DistrictId", "TEXT");
      await addColumnIfNotExists(
          db, Constants.Training_HandHolding, "BlockId", "TEXT");
      await addColumnIfNotExists(db, Constants.Training_HandHolding_Particepent,
          "OtherDesignation", "TEXT");
      await addColumnIfNotExists(
          db, Constants.Survey_Response, "IsEdited", "INTEGER");
      await addColumnIfNotExists(db, Constants.TblTraningIndirectDataList,
          "MscertEnabledFlag", "TEXT");
    }
  }

  static Future<void> addColumnIfNotExists(Database db, String tableName,
      String columnName, String columnType) async {
    final result = await db.rawQuery("PRAGMA table_info($tableName);");
    bool columnExists = result.any((column) => column['name'] == columnName);

    if (!columnExists) {
      await db.execute(
          "ALTER TABLE $tableName ADD COLUMN $columnName $columnType;");
    }
  }
}
