import 'dart:developer';

import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef BarCodeCallback = void Function(Barcode val);

class CustomQRCodeScanner extends StatefulWidget {
  final BarCodeCallback callback;
  const CustomQRCodeScanner({Key? key, required this.callback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomQRCodeScannerState();
}

class _CustomQRCodeScannerState extends State<CustomQRCodeScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(
              height: 4.5.h,
            ),
            Row(
              children: [
                Spacer(),
                Text('Scan QR Code'),
                Spacer(),
                InkWell(
                  child: Icon(Icons.close),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Development of a Training & Advocacy Management Information System (MIS) for Arpan',
              style: Styles.defaultFont,
            ),
            SizedBox(
              height: 37.h,
            ),
            Container(
              decoration: BoxDecoration(
                  color: ColorConstants.defaultWhiteColor,
                  borderRadius: BorderRadius.circular(12.r)),
              height: 429.h,
              child: Center(
                child: SizedBox(
                  child: _buildQrView(context),
                  width: 220.w,
                  height: 220.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 220.0.w
        : 220.0.w;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: ColorConstants.defaultGreenColor,
          // borderRadius: 10,
          borderLength: 20.w,
          borderWidth: 10.w,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    bool isQrFound = false;
    setState(() {
      this.controller = controller;
    });
    // await this.controller!.pauseCamera();
    await Future.delayed(const Duration(milliseconds: 500));
    await this.controller!.resumeCamera();

    controller.scannedDataStream.listen((scanData) async {
      isQrFound = true;
      await controller.pauseCamera();
      if (isQrFound) {
        setState(() {
          isQrFound = false;
        });
        result = scanData;
        widget.callback(result!);
        Navigator.pop(context, result!.code.toString());
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
