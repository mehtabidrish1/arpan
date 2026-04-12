import 'dart:io';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/utils/DownloadData.dart';
import 'package:arpan/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../table_model/tblTraningIndirectData_list.dart';
import '../../../table_model/training_indirect_data_model.dart';
import '../../../utils/common.dart';
import '../../../utils/download_data.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import '../../../widgets/custom_curvedTextfield.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../training/trainingList.dart';

class TrainingCertificateList extends StatefulWidget {
  const TrainingCertificateList({Key? key}) : super(key: key);

  @override
  State<TrainingCertificateList> createState() =>
      _TrainingCertificateListState();
}

class _TrainingCertificateListState extends State<TrainingCertificateList> {
  var isDisposed = false;
  List<TblTraningIndirectDataList> indirectList = [];
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final ScrollController scrcontroller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize the board with the initial cards
  }

  loadData() async {
    var mobileNo =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.phone);
    indirectList =
        await DataProvider().getTblTraningIndirectDataList(mobileNo!);
    return indirectList;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                Text("Certification Details",
                    style: Styles.red164
                        .copyWith(color: ColorConstants.defaultMaroon))
              ],
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/rightButterflyTheme.png'),
                    fit: BoxFit.fill)),
            child: FutureBuilder(
              future: loadData(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: Text('Loading...'));
                  default:
                    if (snapshot.hasError) {
                      return const SizedBox(
                        height: 10,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            CurvedTextField(
                              height: 38.h,
                              onChanged: (e) {},
                              preffixIcon: const Icon(
                                Icons.search,
                                size: 28,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.cancel_outlined)),
                              hintText: 'Search',
                              hintStyle: Styles.grey164,
                            ),
                            SizedBox(height: 10.h),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                controller: scrcontroller,
                                physics: const ClampingScrollPhysics(),
                                itemCount: indirectList.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final indirectListDetail =
                                      indirectList[index];

                                  if (indirectListDetail == null) return null;

                                  return GestureDetector(
                                    onTap: () async {
                                      // isDisposed = true;
                                      var isParticipantCert =
                                          await showDialog<bool>(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(actions: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  CustomButton(
                                                    buttonTitle: LabelText
                                                        .participationCertificate,
                                                    onPressed: () {
                                                      return Navigator.pop(
                                                          context, true);
                                                    },
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                  ),
                                                  CustomButton(
                                                    buttonTitle: LabelText
                                                        .appreciationCertificate,
                                                    onPressed: () {
                                                      return Navigator.pop(
                                                          context, false);
                                                    },
                                                  )
                                                ]);
                                              });
                                      if (isParticipantCert != null) {
                                        if (isParticipantCert) {
                                          await loadCertificate(
                                              indirectListDetail.scheduleGuid ??
                                                  '',
                                              indirectListDetail,
                                              true);
                                        } else {
                                          // List<TrainingIndirectData>
                                          //     indirectDataList =
                                          //     await DataProvider()
                                          //         .getindirctTraingingAllData(
                                          //             indirectListDetail);
                                          // if (indirectDataList.isNotEmpty) {
                                          await loadCertificate(
                                              indirectListDetail.scheduleGuid ??
                                                  '',
                                              indirectListDetail,
                                              false);
                                          // } else {
                                          //   if (mounted) {
                                          //     Toast.show(
                                          //         'Appreciation Certificate is not available.',
                                          //         duration: Toast.lengthLong,
                                          //         gravity: Toast.bottom,
                                          //         backgroundColor: Colors.red);
                                          //   }
                                          // }
                                        }
                                      }
                                    },
                                    child: listIndirectCard(
                                        indirectListDetail, index),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ));
  }

  Widget listIndirectCard(TblTraningIndirectDataList trainingBatch, int index) {
    return Card(
        // color: (index + 1) % 2 == 1 ? Colors.white : Color(0xffFFF7F7),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color(0xff707070),
              width: 1), // set the border color and width
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrainingTitle(
                title: LabelText.traingName,
                text: trainingBatch.trainingName ?? '',
                icon: "assets/trainingName.png",
              ),
              /* Divider(),
              TrainingTitle(
                title: 'Topic',
                text: trainingBatch.topicsCoveredName ?? '',
                icon: "assets/theme.png",
              ),*/
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: LabelText.trainerName,
                text: trainingBatch.trainerName,
                icon: "assets/trainerName.png",
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: LabelText.dateBetween,
                text:
                    '${trainingBatch.firstDate ?? ''} - ${trainingBatch.lastDate ?? ''}',
                icon: "assets/dateBetween.png",
              ),
            ],
          ),
        ));
  }

  loadCertificate(
      String schedGuid,
      TblTraningIndirectDataList indirectListDetail,
      bool isParticipantCert) async {
    String certificatePath = '';

    if (schedGuid == null || schedGuid.isEmpty) {
      return;
    }
    try {
      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            if (certificatePath.isNotEmpty) {
              Navigator.pushReplacementNamed(
                context,
                RouteConstants.particepentCertificate,
                arguments: [certificatePath, indirectListDetail],
              );
            } else {
              if (mounted) {
                Toast.show('Certificate is not available.',
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                    backgroundColor: Colors.red);
              }
            }
          },
          func: () async {
            try {
              var mobileNo = await customSecureStorage.getSecureValues(
                  key: SecureStorageKeys.phone);
              if (isParticipantCert) {
                certificatePath = await DataDownload()
                    .downloadCertificate(mobileNo!, schedGuid, true);
              } else {
                certificatePath = await DataDownload()
                    .downloadCertificate(mobileNo!, schedGuid, false);
              }

              // final file = File(certificatePath);
              return LabelText.success;
            } catch (error, stackTrace) {
              logError(error, stackTrace);
              return LabelText.unknownError;
            }
          },
          goOnline: false,
          title: LabelText.pleaseWait,
        ),
      );
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }
}
