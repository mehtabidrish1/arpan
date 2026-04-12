import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/style/style1.dart';
import '../../../table_model/tblTraningIndirectData_list.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import 'package:path/path.dart';

class ParticepentCertificate extends StatefulWidget {
  const ParticepentCertificate({Key? key}) : super(key: key);

  @override
  State<ParticepentCertificate> createState() => _ParticepentCertificateState();
}

class _ParticepentCertificateState extends State<ParticepentCertificate> {
  String docPath = '';
  late TblTraningIndirectDataList indirectListDetail;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    setState(() {});
  }

  Future<void> downloadPdf() async {
    try {
      final sourceFile = File(docPath);

      final params = SaveFileDialogParams(
        sourceFilePath: sourceFile.path,
        fileName: "Certificate_${DateTime.now().millisecondsSinceEpoch}.pdf",
      );

      final filePath = await FlutterFileDialog.saveFile(params: params);

      if (filePath != null) {
        Toast.show(
          "File saved successfully",
          duration: 3,
          gravity: Toast.bottom,
        );
      }
    } catch (e) {
      Toast.show(
        e.toString(),
        duration: 3,
        gravity: Toast.bottom,
      );
    }
  }

  // downloadPdf() async {
  //   try {
  //     var status = await Permission.storage.status;
  //     final deviceInfo = await DeviceInfoPlugin().androidInfo;
  //     if (Platform.isAndroid) {
  //       if (deviceInfo.version.sdkInt > 32) {
  //         status = await Permission.photos.request();
  //       } else {
  //         status = await Permission.storage.request();
  //       }
  //     }

  //     if (!status.isGranted) {
  //       // If not we will ask for permission first
  //       await Permission.storage.request();
  //     }
  //     Directory? _directory = Directory("");
  //     if (Platform.isAndroid) {
  //       // Redirects it to download folder in android
  //       //_directory = Directory('/storage/emulated/0/arpanCertificate');
  //       // _directory = await DownloadsPathProvider.downloadsDirectory;
  //       if (!await _directory!.exists())
  //         _directory = await getExternalStorageDirectory();
  //     } else {
  //       _directory = await getApplicationDocumentsDirectory();
  //     }

  //     final newpath = _directory!.path;
  //     print("Saved Path: $newpath");
  //     await Directory(newpath).create(recursive: true);
  //     var databasePath = docPath;
  //     var data = File(databasePath!);

  //     var currentDateTime =
  //         DateTime.now().toString().replaceAll(' ', '_').replaceAll(':', '_');
  //     var filename = 'Certificate$currentDateTime';

  //     final filePath = join(newpath, filename + '.pdf');

  //     final file = await data.copy(filePath);
  //     Toast.show(file.path,
  //         duration: 5, gravity: Toast.bottom, backgroundColor: Colors.green);
  //   } catch (error, stackTrace) {
  //     logError(error, stackTrace);
  //     Toast.show(error.toString(),
  //         duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      docPath = data[0];
      indirectListDetail = data[1];
    }
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: false,
              leadingWidth: 300.w,
              leading: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();

                      await Navigator.popAndPushNamed(
                        context,
                        RouteConstants.participentdashboardScreen,
                      );
                    },
                  ),
                  Text(LabelText.certifecate,
                      style: Styles.red164
                          .copyWith(color: ColorConstants.defaultMaroon))
                ],
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    await downloadPdf();
                  },
                  child: const Icon(
                    Icons.download,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                )
              ]),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/rightButterflyTheme.png'),
                    fit: BoxFit.fill)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: docPath.isNotEmpty
                  ? PDFView(
                      filePath: docPath,
                      autoSpacing: true,
                      enableSwipe: true,
                      pageSnap: true,
                      swipeHorizontal: true,
                      nightMode: false,
                      onError: (e) {
                        print(e);
                      },
                      onRender: (_pages) {
                        setState(() {
                          //  _totalPages = _pages;
                          //  pdfReady = true;
                        });
                      },
                      onViewCreated: (PDFViewController vc) {
                        setState(() {
                          // _pdfViewController = vc;
                        });
                      },
                      onPageChanged: (int? page, int? total) {
                        setState(() {
                          //  _currentPage = page;
                        });
                      },
                      onPageError: (page, e) {},
                    )
                  : const SizedBox(height: 10, width: 10),
            ),
          ),
        ));
  }
}
