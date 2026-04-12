import 'package:arpan/database/dataProvider.dart';
import 'package:flutter/foundation.dart';

import '../models/tbl_error_logs.dart';

Future<void> logError(dynamic error, StackTrace stackTrace) async {
  // Log or report the error and stackTrace here
  if (kDebugMode) {
    print('Error Arpan: $error');
    print(' Arpan Stack Trace: $stackTrace');
  }
  var errorlog = ErrorLog(
      timestamp: DateTime.now().toString(),
      errorMessage: error.toString(),
      stackTrace: stackTrace.toString(),
      isUpload: 0);

  await DataProvider().insertErrorLog(errorlog);
}
