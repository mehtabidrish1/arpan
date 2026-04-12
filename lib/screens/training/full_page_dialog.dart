import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:toast/toast.dart';

import '../../utils/log_files.dart';

class FullPageQrCode extends StatefulWidget {
  final String? jsonString;
  final String? guid;

  const FullPageQrCode({Key? key, this.jsonString, this.guid})
      : super(key: key);

  @override
  State<FullPageQrCode> createState() => _FullPageQrCodeState();
}

class _FullPageQrCodeState extends State<FullPageQrCode> {
  final GlobalKey _key = GlobalKey();
  final _controller = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: AlertDialog(
          title: Text(''),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Screenshot(
              key: _key,
              controller: _controller,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.white,
                child: QrImageView(
                  data: widget.jsonString!,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
            TextButton(
              // onPressed: _takeScreenshot,
              onPressed: () {
                try {
                  _controller
                      .capture(delay: Duration(milliseconds: 10))
                      .then((value) async {
                    await ImageGallerySaverPlus.saveImage(
                        value!.buffer.asUint8List(),
                        name: DateTime.now().toString() + '.png');

                    Toast.show('Image saved to gallery',
                        duration: 3,
                        gravity: Toast.bottom,
                        backgroundColor: Colors.green);
                    Navigator.of(context).pop();
                  });
                } catch (e) {
                  Toast.show('Error - ${e.toString()}',
                      duration: 3,
                      gravity: Toast.bottom,
                      backgroundColor: Colors.redAccent);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Download as Image'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takeScreenshot() async {
    try {
      // Define the file name and path
      // final directory = await getExternalStorageDirectory();
      // final String fileName = DateTime.now().toString();
      // final String filePath = '${directory!.path}/$fileName';

      // Take the screenshot
      final imageBytes = await _captureScreenshot();
      if (imageBytes != null) {
        final result = await ImageGallerySaverPlus.saveImage(
            imageBytes.buffer.asUint8List());

        Toast.show('Image saved to gallery',
            duration: 3, gravity: Toast.bottom, backgroundColor: Colors.green);
        Navigator.of(context).pop();
      }
      // Save the screenshot to the device
      // final file = File(filePath);
      //await file.writeAsBytes(imageBytes);

      // Show a message to the user
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  Future<Uint8List> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary =
          _key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (error, stackTrace) {
      logError(error, stackTrace);

      rethrow;
    }
  }
}
