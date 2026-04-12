import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/screens/dashboard/attendances/attendanceList.dart';
import 'package:arpan/screens/dashboard/attendances/attendanceScreen.dart';
import 'package:arpan/screens/dashboard/survey/questionList.dart';
import 'package:arpan/screens/dashboard/sync/syncronization.dart';
import 'package:arpan/screens/login/loginScreen.dart';
import 'package:arpan/screens/training/trainingList.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/viewmodels/login_state_view_model.dart';
import 'package:arpan/widgets/custom_button.dart';
import 'package:arpan/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/download_data.dart';
import '../../../utils/upload_data.dart';

class ParticepentSyncronizationPage extends StatefulWidget {
  const ParticepentSyncronizationPage({Key? key});

  @override
  State<ParticepentSyncronizationPage> createState() =>
      _ParticepentSyncronizationPageState();
}

class _ParticepentSyncronizationPageState
    extends State<ParticepentSyncronizationPage> {
  List<String> image = [
    "assets/master.png",
    "assets/download_data.png",
    "assets/upload_data.png",
  ];
  List<String> text = [
    LabelText.masterData,
    LabelText.download,
    LabelText.upload
  ];
  // List<String> text2 = ['Questionnaire', 'Attendance'];
  final DataDownload dataDownload = DataDownload();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.grey.shade300,
        centerTitle: true,
        title: Text(LabelText.sync, style: Styles.black145),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () async {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
            /*  await Navigator.popAndPushNamed(
                context,
                RouteConstants.dashboardScreen,
              );
              */
          },
        ),
      ),
      body: SizedBox(
        child: Column(
          children: [
            GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                shrinkWrap: true,
                itemCount: 3,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 17),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        if (index == 0) {
                          showCustomDialog(
                            context,
                            widget: ShowAlertDialogBox(
                              func: () async {
                                await dataDownload.getMasterData();
                                await dataDownload.downloadStateData();
                                await dataDownload.getDistrictData();
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
                                await UploadAllData().uploadIndirectDataImages();

                                return LabelText.success;
                              },
                              goOnline: false,
                              title: LabelText.pleaseWait,
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: index == 0
                              ? Color(0xffF2F5FF)
                              : Color(0xffFFEFEF),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              offset: Offset(0.0, 0.5),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: 100,
                                  height: 100,
                                  child: Image.asset(image[index])),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                text[index],
                                style: Styles.defaultFont,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ));
                }),
          ],
        ),
      ),
    );
  }
}
