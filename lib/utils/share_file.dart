import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'log_files.dart';

class FileSharingHelper {
  static Future<void> shareAssetFile(String assetPath,
      {String message = ''}) async {
    try {
      ByteData byteData = await rootBundle.load('assets/share/Arpan.apk');
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/Arpan.apk';

      final buffer = byteData.buffer;
      final file = await File(filePath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      await SharePlus.instance.share(ShareParams(text: message,files: [XFile(file.path)]));
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      throw Exception('Failed to share asset file');
    }
  }

  static String _getFileNameFromPath(String path) {
    return path.split('/').last;
  }
}
