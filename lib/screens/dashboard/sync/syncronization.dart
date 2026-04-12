import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../utils/common.dart';
import '../../../utils/download_data.dart';
import '../../../utils/upload_data.dart';
import '../dashboard_screen.dart';

class SyncronizationPage extends StatefulWidget {
  const SyncronizationPage({Key? key});

  @override
  State<SyncronizationPage> createState() => _SyncronizationPageState();
}

class _SyncronizationPageState extends State<SyncronizationPage> {
  List<String> image = [
    "assets/masterData.png",
    "assets/downloadData.png",
    "assets/uploadData.png",
  ];
  final DataDownload dataDownload = DataDownload();
  int count = 0;
  String role = '';

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await CustomSecureStorage()
        .getSecureValues(key: SecureStorageKeys.role)
        .then((value) {
      role = value ?? '';
    });
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      count = data[0] as int;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (role == 'participant') {
                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.participentdashboardScreen,
                    );
                  } else {
                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.dashboardScreen,
                    );
                  }
                },
              ),
              Text(LabelText.sync,
                  style: Styles.red164
                      .copyWith(color: ColorConstants.defaultMaroon))
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/leftButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: ListView.builder(
              shrinkWrap: true,
              itemExtent: MediaQuery.of(context).size.height * 0.19,
              itemCount: image.length,
              itemBuilder: (context, index) {
                if (role == 'participant' && index == 1) {
                  return const SizedBox.shrink();
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: InkWell(
                        onTap: () {
                          if (index == 0) {
                            showCustomDialog(
                              context,
                              widget: ShowAlertDialogBox(
                                func: () async {
                                  await dataDownload.getMasterData();
                                  await dataDownload.downloadStateData();
                                  await dataDownload.getDistrictData();
                                  await dataDownload.getBlockData();
                                  await dataDownload.getIndividualPartnerData();
                                  await dataDownload.downloadTeacherGradeList();
                                  await dataDownload
                                      .downloadTrainerEstablishmentList();
                                  await dataDownload.downloadTrainerList();
                                  await dataDownload.getDesignationData();
                                  await dataDownload
                                      .getTrainingHandHoldingModuleList();

                                  //await dataDownload.getTrainingParticipantList();
                                  return LabelText.success;
                                },
                                goOnline: false,
                                title: LabelText.pleaseWait,
                              ),
                            );
                          }
                          if (index == 1) {
                            showCustomDialog(
                              context,
                              widget: ShowAlertDialogBox(
                                func: () async {
                                  await dataDownload
                                      .getTrainingRegistrationList();
                                  await dataDownload
                                      .getTrainingHandHoldingList();
                                  await dataDownload
                                      .downloadAttendceDetailList();
                                  //await dataDownload.getTrainingParticipantList();
                                  return LabelText.success;
                                },
                                goOnline: false,
                                title: LabelText.pleaseWait,
                              ),
                            );
                          }
                          if (index == 2) {
                            showCustomDialog(
                              context,
                              widget: ShowAlertDialogBox(
                                func: () async {
                                  await UploadAllData().syncAllData();
                                  await UploadAllData().uploadSessionImages();
                                  await UploadAllData()
                                      .uploadIndirectDataImages();
                                  count = 0;
                                  setState(() {});

                                  return LabelText.success;
                                },
                                goOnline: false,
                                title: LabelText.pleaseWait,
                              ),
                            );
                          }
                        },
                        child: Center(
                            child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Image.asset(
                              image[index],
                            ),
                            count > 0 && index == 2
                                ? Container(
                                    height: 25.h,
                                    width: 25.w,
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .red, // Set your badge background color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        count.toString(),
                                        style: const TextStyle(
                                          color: Colors
                                              .white, // Set your badge text color
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ))),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
