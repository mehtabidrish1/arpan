import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../database/dataProvider.dart';
import '../../../table_model/notification_model.dart';
import '../../../table_model/tblsurvey_response.dart';
import '../../../utils/download_data.dart';
import '../../../utils/log_files.dart';
import '../../../utils/validate.dart';

class ParticepentDashboardScreen extends StatefulWidget {
  const ParticepentDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ParticepentDashboardScreen> createState() =>
      _ParticepentDashboardScreenState();
}

class _ParticepentDashboardScreenState
    extends State<ParticepentDashboardScreen> {
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  final List<String> images = [
    "assets/trainingIcon.png",
    "assets/indirectData.png",
    "assets/profileIcon.png",
    "assets/certificationIcon.png",
    "assets/syncc.png",
    "helpline"
  ];

  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUploadCount();
  }

  List<NotificationModel> notificationList = [];

  checkUploadCount() async {
    count = 0;
    notificationList = await DataProvider().getNotification();
    var regListAll = await DataProvider().getUploadTrainingRegistration();

    // var details = await DataProvider().getParticipantScanDetailsForUpload();
    var regParticipantList = await DataProvider().uploadParticipantList();
    var regParticipantAttenList =
        await DataProvider().uploadTrainingSessionAttendance();
    var regParticipantAttendanceList = [];
    // var regSessionImageList = await DataProvider().getUploadImageSessionList();
    var handHoldingData = await DataProvider().uploadHandholingRegistration();
    var regParticipantAttendanList =
        await DataProvider().uploadHandHoldAttendance();
    var allIndirectData = await DataProvider().uploadindirctTraingingData();
    var allData = await DataProvider().getParticipantOfflineRecord();
    var mobileNo =
        await customSecureStorage.getSecureValues(key: SecureStorageKeys.phone);
    // int surveyCount = await DataProvider().getSurveyDataOffline(mobileNo);
    List<SurveyResponse> surveyResponses =
        await DataProvider().getSurveyDataOfflineForUpload(mobileNo);
    final seenKeys = <String>{};
    final uniqueList = <SurveyResponse>[];
    for (var item in surveyResponses) {
      final key = '${item.registrationGuid?.toLowerCase()}|${item.surveyId}';
      if (!seenKeys.contains(key)) {
        seenKeys.add(key);
        uniqueList.add(item);
      }
    }
    count = regListAll.length +
        // details.length +
        regParticipantList.length +
        regParticipantAttenList.length +
        regParticipantAttendanceList.length +
        handHoldingData.length +
        regParticipantAttendanList.length +
        allIndirectData.length +
        uniqueList.length;
    // +
    //  allData.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          floatingActionButton: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  content: Text(
                    "Do you want to Logout?",
                    style: Styles.black145,
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CurvedButton(
                            buttonTitle: LabelText.yes,
                            style: Styles.white146,
                            buttonColor: ColorConstants.defaultMaroon,
                            height: 40.h,
                            onPressed: () async {
                              await showCustomDialog(context,
                                  widget: ShowAlertDialogBox(
                                    func: () async {
                                      CustomSecureStorage customSecureStorage =
                                          CustomSecureStorage();
                                      await DataProvider()
                                          .deleteNotification('1');
                                      await customSecureStorage
                                          .deleteAllSecureElements();
                                      //  await DataProvider().deleteAllDatabase();
                                      // ref.refresh(loginStateFutureProvider);
                                      return LabelText.success;
                                    },
                                    secondFunc: () async {
                                      await Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              RouteConstants.loginScreen,
                                              (Route<dynamic> route) => false);
                                    },
                                    title: LabelText.success,
                                  ));
                            },
                          ),
                        ),
                        // SizedBox(
                        //   width: 4.w,
                        // ),
                        Expanded(
                          child: CurvedGreyButton(
                            buttonTitle: LabelText.no,
                            style: Styles.white146,
                            height: 40.h,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            child: Image.asset(
              "assets/logout_icon.png",
              scale: 1.2,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/leftButterflyTheme.png'),
                    fit: BoxFit.fill)),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 20.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CurvedButton(
                              width: MediaQuery.of(context).size.width * 0.4,
                              buttonTitle: 'Home',
                              buttonColor: ColorConstants.defaultMaroon,
                              height: 30.h,
                              style: Styles.white146,
                              onPressed: () {
                                setState(() {});
                              },
                            ),
                            // count > 0
                            //     ? CurvedGreyButton(
                            //         width:
                            //             MediaQuery.of(context).size.width * 0.4,
                            //         buttonTitle: 'Pending($count)',
                            //         style: Styles.white146,
                            //         height: 30.h,
                            //         onPressed: () {
                            //           showCustomDialog(
                            //             context,
                            //             widget: ShowAlertDialogBox(
                            //               func: () async {
                            //                 await UploadAllData().syncAllData();
                            //                 await UploadAllData()
                            //                     .uploadSessionImages();
                            //                 await UploadAllData()
                            //                     .uploadIndirectDataImages();
                            //                 // checkUploadCount();
                            //                 return LabelText.success;
                            //               },
                            //               goOnline: false,
                            //               title: LabelText.pleaseWait,
                            //             ),
                            //           );
                            //         },
                            //       )
                            //     : const SizedBox.shrink(),
                            InkWell(
                              onTap: () async {
                                if (notificationList.isNotEmpty) {
                                  await showNotificationList(context);
                                }
                              },
                              child: SizedBox(
                                height: 50.h,
                                width: 50.w,
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    const Icon(
                                      Icons.notifications_none_sharp,
                                      size: 45,
                                    ),
                                    if (notificationList.isNotEmpty)
                                      Container(
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
                                            notificationList.length.toString(),
                                            style: const TextStyle(
                                              color: Colors
                                                  .white, // Set your badge text color
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 25.h),
                      GridView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        shrinkWrap: true,
                        itemCount: images.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // number of items in each row
                          mainAxisSpacing: 8.h, // spacing between rows
                          crossAxisSpacing: 8.w, // spacing between columns
                        ),
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5.h),
                            child: InkWell(
                              onTap: () async {
                                //await CustomSecureStorage.createDbBackup();
                                if (i == 0) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteConstants.questionListScreen,
                                  );
                                } else if (i == 1) {
                                  var internet = await Validate()
                                      .checkInternetConnectivity();
                                  if (!internet) {
                                    Toast.show('Internet Connection Required',
                                        duration: 3,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.red);
                                  }
                                  await loadData();
                                } else if (i == 2) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteConstants.newReg,
                                  );
                                } else if (i == 3) {
                                  var internet = await Validate()
                                      .checkInternetConnectivity();
                                  if (internet) {
                                    await loadTrainingcertificatelist();
                                  } else {
                                    Toast.show('Internet Connection Required',
                                        duration: 3,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.red);
                                  }
                                } else if (i == 4) {
                                  Navigator.pushReplacementNamed(context,
                                      RouteConstants.syncronizationPage,
                                      arguments: [count]);
                                } else if (i == 5) {
                                  FlutterPhoneDirectCaller.callNumber(
                                      '+9118002672444');
                                }
                              },
                              child: Center(
                                child: images[i].contains('.png')
                                    ? Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.asset(
                                            images[i],
                                          ),
                                          count > 0 && i == 4
                                              ? Container(
                                                  height: 25.h,
                                                  width: 25.w,
                                                  padding:
                                                      const EdgeInsets.all(2),
                                                  decoration:
                                                      const BoxDecoration(
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
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink()
                                        ],
                                      )
                                    : callBox(),
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            ),
          )),
    );
  }

  callBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Card(
        elevation: 4,
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Colors.grey.shade800, width: 1), // Add a black border
          borderRadius:
              BorderRadius.circular(30), // Adjust border radius as needed
        ), // Set the elevation for a shadow effect
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    size: 80.0, // Adjust the size of the phone icon
                    color: Colors
                        .red.shade800, // Adjust the color of the phone icon
                  ),
                ],
              ),
              const Spacer(), // Add some spacing between the icon and text
              Text(
                'Helpline Number',
                style: TextStyle(
                    fontSize: 16.0, // Adjust the font size of the text
                    fontWeight: FontWeight.bold,
                    color: Colors
                        .red.shade800 // Adjust the font weight of the text
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadData() async {
    try {
      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            Navigator.pushReplacementNamed(
              context,
              RouteConstants.indirecttrainninglist,
            );
          },
          func: () async {
            try {
              var mobileNo = await customSecureStorage.getSecureValues(
                  key: SecureStorageKeys.phone);
              // await DataDownload().getMasterData();
              await DataDownload()
                  .getTrainingParticipantList(mobileno: mobileNo);
              await DataDownload()
                  .downloadTblTraningIndirectDataList(mobileNo, '');
              await DataDownload().downloadTblTraningIndirectDataAll(mobileNo);
            } catch (error, stackTrace) {
              logError(error, stackTrace);
              return LabelText.unknownError;
            }

            return LabelText.success;
          },
          goOnline: false,
          title: LabelText.pleaseWait,
        ),
      );
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  loadTrainingcertificatelist() async {
    try {
      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            Navigator.pushReplacementNamed(
              context,
              RouteConstants.trainingcertificatelist,
            );
          },
          func: () async {
            try {
              var mobileNo = await customSecureStorage.getSecureValues(
                  key: SecureStorageKeys.phone);
              await DataDownload()
                  .downloadTblTraningIndirectDataList(mobileNo, 'Certificate');
              await DataDownload().downloadTblTraningIndirectDataAll(mobileNo);
            } catch (error, stackTrace) {
              logError(error, stackTrace);
              return LabelText.unknownError;
            }

            return LabelText.success;
          },
          goOnline: false,
          title: LabelText.pleaseWait,
        ),
      );
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
  }

  OverlayEntry? overlayEntry;
  Future<void> showNotificationList(BuildContext context) async {
    // final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: 60.h,
        right: 0,
        child: Material(
          elevation: 4,
          child: Container(
            width: 200,
            child: Column(
              children: [
                for (int i = 0; i < notificationList.length; i++) ...{
                  InkWell(
                    onTap: () async {
                      await DataProvider().deleteNotification('1');
                      overlayEntry!.remove();
                      notificationList.clear();
                      setState(() {});
                    },
                    child: ListTile(
                        title: Text(notificationList[i].notificationmsg!)),
                  )
                }

                // Add more list items as needed
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);

    try {
      await Future.delayed(const Duration(seconds: 5));
      await DataProvider().deleteNotification('1');
      overlayEntry!.remove();
      notificationList.clear();
      setState(() {});
    } catch (e) {}
  }
}
