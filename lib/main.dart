import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/utils/arpan_notification.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/update_service.dart';
import 'package:path/path.dart';
import 'package:arpan/utils/download_data.dart';
import 'package:arpan/utils/upload_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:workmanager/workmanager.dart';

import 'database/databaseHelper.dart';
import 'utils/log_files.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await ArpanNotification().initNotification();

  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      // statusBarBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  if (!kIsWeb) {
    await deleteOldDB();
    await DatabaseHelper().init();
    await UploadAllData().syncAllData();
    await AppUpdateService.checkForImmediateUpdate();

    //  await CustomSecureStorage.createDbBackup();
  }
  readFileFromAssets();

  // Workmanager().initialize(
  //     callbackDispatcher, // The top level function, aka callbackDispatcher
  //     isInDebugMode:
  //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  //     );
  // Workmanager().registerPeriodicTask("task-identifier", "simpleTask",
  //     frequency: Duration(hours: 3),
  //     constraints: Constraints(
  //         networkType: NetworkType.connected,
  //         requiresBatteryNotLow: false,
  //         requiresCharging: false,
  //         requiresDeviceIdle: false,
  //         requiresStorageNotLow: false));
  // runZonedGuarded(() {
  runApp(const ProviderScope(child: MyApp()));
  // }, (error, stackTrace) {
  //   logError(error, stackTrace);
  // });
}

String jsonStringEn = '';
String jsonStringhi = '';
String jsonStringMha = '';
Map<String, String> enMap = {};
Map<String, String> hiMap = {};
Map<String, String> mHaMap = {};
Future<void> readFileFromAssets() async {
  jsonStringEn = await rootBundle.loadString('assets/languages/en.json');
  jsonStringhi = await rootBundle.loadString('assets/languages/hi.json');
  jsonStringMha = await rootBundle.loadString('assets/languages/ma.json');
  enMap = convertMapToString(jsonStringEn);
  hiMap = convertMapToString(jsonStringhi);
  mHaMap = convertMapToString(jsonStringMha);
}

Future<void> deleteOldDB() async {
  var databasePath = await getDatabasesPath();
  var path = join(databasePath, 'arpan.db');
  var exists = await databaseExists(path);
  if (exists) {
    await deleteDatabase(path);
  }
}

Map<String, String> convertMapToString(String json) {
  Map<String, dynamic> jsonMap = jsonDecode(json);
  Map<String, String> convertedMap = {};
  jsonMap.forEach((key, value) {
    convertedMap[key] = value.toString();
  });
  return convertedMap;
}

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     try {
//       await DatabaseHelper().init();
//       await UploadAllData().syncAllData();
//       await DataDownload().getMasterData();
//     } catch (error, stackTrace) {
//       logError(error, stackTrace);
//     } //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Arpan',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.blue,
            checkboxTheme: const CheckboxThemeData(
              // Adjust the size here
              materialTapTargetSize: MaterialTapTargetSize.padded,
            ),
          ),
          initialRoute: RouteConstants.splashScreen,
          routes: RouteConstants.routes,
        );
      },
    );
  }
}
