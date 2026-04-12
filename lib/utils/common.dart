import 'dart:io';

import 'package:arpan/constants/secure_storage_keys.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/enum_constants.dart';
import '../database/databaseHelper.dart';
import 'package:path/path.dart';

import 'log_files.dart';

class CustomSecureStorage {
  final storage = const FlutterSecureStorage();
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  static createDbBackup() async {
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        // If not we will ask for permission first
        await Permission.storage.request();
      }
      Directory _directory = Directory("");
      if (Platform.isAndroid) {
        // Redirects it to download folder in android
        _directory = Directory('/storage/emulated/0/arpanDB');
      } else {
        _directory = await getApplicationDocumentsDirectory();
      }

      final newpath = _directory.path;
      print("Saved Path: $newpath");
      await Directory(newpath).create(recursive: true);
      var databasePath = DatabaseHelper.dbPath;
      var data = File(databasePath!);

      var currentDateTime =
          DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '_');
      var filename = 'db$currentDateTime';

      final filePath = join(newpath, filename + '.db');
      final file = await data.copy(filePath);

// Access the files
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  deleteAllSecureElements() async {
    try {
      await storage.deleteAll();
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      rethrow;
    }
  }

  deleteSecureKeyValues({required String key}) async {
    try {
      await storage.delete(key: key);
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      rethrow;
    }
  }

  Future<String?> getSecureValues({required String key}) async {
    try {
      String? value = await storage.read(key: key);
      return value;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      rethrow;
    }
  }

  writeSecureValue({required String key, required String value}) async {
    try {
      await storage.write(key: key, value: value);
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      rethrow;
    }
  }
}

class UserInfo {
  String? email;
  String? password;
  String? role;

  UserInfo({this.email, this.password, this.role});
  @override
  String toString() {
    return 'UserInfo[email=$email,password=$password,role=$role]';
  }

  Future<Map<String, dynamic>> getUserCredentials() async {
    Map<String, dynamic> userMap = {};
    CustomSecureStorage customSecureStorage = CustomSecureStorage();
    var tempEmail = await customSecureStorage.getSecureValues(
        key: SecureStorageKeys.userId);

    userMap['email'] = tempEmail;

    var tempPassword = await customSecureStorage.getSecureValues(
        key: SecureStorageKeys.password);

    userMap['password'] = tempPassword;

    var tempRole =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.role);

    userMap['role'] = tempRole;
    userMap['phone'] =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.phone);
    ;

    return userMap;
  }
}

DateTime? dateTimeCustomParser({
  required String date,
  required String customFormat,
  required trainingTheme,
  required trainingThemeName,
  required updatedBy,
  DateTime? updatedOn,
}) {
  // var initialData = DateFormat('d MMM yyyy h:mm a').parse(date);
  // var formatedDate = DateFormat('yyyy-MM-dd hh:mm:ss').format(initialData);
  var defaultFormat = 'yyyy-MM-ddTHH:MM:SS';
  DateTime initialData;
  try {
    initialData = DateFormat(customFormat).parse(date);
    return initialData;
  } catch (error, stackTrace) {
    logError(error, stackTrace);
    try {
      initialData = DateFormat(defaultFormat).parse(date);
      return initialData;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  return null;
}

extension StringExtension on String {
  String capitalize() {
    try {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      return this;
    }
  }

  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this.isNotEmpty
      ? this.split(" ").map((str) => str.capitalize()).join(" ")
      : '';

  bool get containsUppercase => contains(RegExp(r'[A-Z]{2,}'));
}

String? getDefaultFormatDate({DateTime? dateTime}) {
  if (dateTime == null) {
    return null;
  }
  try {
    // DateFormat df = DateFormat('MM-dd-yyyy');
    DateFormat df = DateFormat('dd-MM-yyyy');

    return df.format(dateTime);
  } catch (error, stackTrace) {
    logError(error, stackTrace);
    return null;
  }
}
