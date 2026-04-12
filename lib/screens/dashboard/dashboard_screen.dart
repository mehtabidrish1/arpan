import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/secure_storage_keys.dart';
import '../../database/dataProvider.dart';
import '../../table_model/notification_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/share_file.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<String> images = [
    "assets/trainingIcon.png",
    "assets/handholding.png",
    "assets/syncc.png",
    // "assets/shareapk",
    //  "assets/certification.png",
    //  "assets/achievement.png",
  ];

  int count = 0;
  var today = DateTime.now();
  DateTime? notifiedDate;
  bool showNotification = false;
  List<NotificationModel> notificationList = [];

  @override
  void initState() {
    super.initState();
    checkUploadCount();
    checkHandholdingNotification();
  }

  checkHandholdingNotification() async {
    String? date = await CustomSecureStorage()
        .getSecureValues(key: SecureStorageKeys.notifiedDate);
    if (date != null) {
      notifiedDate = DateTime.parse(date);
      if (notifiedDate != null && today.difference(notifiedDate!).inDays != 0) {
        print(today.difference(notifiedDate!).inDays);
        showNotification = true;
      }
    } else {
      await CustomSecureStorage().writeSecureValue(
          key: SecureStorageKeys.notifiedDate,
          value: DateTime(today.year, today.month, today.day).toString());
    }
    var trainingScheduleList = <TblTrainingSchedule>[];
    var userInfo = await UserInfo().getUserCredentials();
    String userid = userInfo['email'];
    var mainTrainingScheduleList =
        await DataProvider().getTrainingSchedule(userid);

    trainingScheduleList = mainTrainingScheduleList
        .where((schedule) =>
            today.difference(DateTime.parse(schedule.lastDate!)).inDays >= 15 &&
            schedule.trainingType == '1')
        .toList();

    for (var e in trainingScheduleList) {
      var handholdingList =
          await DataProvider().getHandholingRegistration(e.scheduleGuid!);
      if (handholdingList.isEmpty) {
        await DataProvider().insertNotification(NotificationModel(
            notificationtype: '2',
            notificationmsg:
                "Please fill handholding details for ${e.trainingName}"));
      }
    }
    if (date == null || date.isEmpty && notificationList.isNotEmpty) {
      showNotification = true;
    }
    setState(() {});
  }

  checkUploadCount() async {
    count = 0;
    var regListAll = await DataProvider().getUploadTrainingRegistration();

    // var details = await DataProvider().getParticipantScanDetailsForUpload();
    var regParticipantList = await DataProvider().uploadParticipantList();
    var regParticipantAttenList =
        await DataProvider().uploadTrainingSessionAttendance();
    var regParticipantAttendanceList = [];
    //  await DataProvider().uploadTrainingPartialAttendance();
    // var regSessionImageList = await DataProvider().getUploadImageSessionList();
    var handHoldingData = await DataProvider().uploadHandholingRegistration();
    var regParticipantAttendanList =
        await DataProvider().uploadHandHoldAttendance();
    var allIndirectData = await DataProvider().uploadindirctTraingingData();
    // var allData = await DataProvider().getParticipantOfflineRecord();
    count = regListAll.length +

        // details.length +
        regParticipantList.length +
        regParticipantAttenList.length +
        regParticipantAttendanceList.length +
        handHoldingData.length +
        regParticipantAttendanList.length +
        allIndirectData.length; // +
    //  allData.length;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                              buttonColor: ColorConstants.defaultMaroon,
                              buttonTitle: LabelText.yes,
                              style: Styles.white146,
                              height: 40.h,
                              onPressed: () async {
                                await showCustomDialog(context,
                                    widget: ShowAlertDialogBox(
                                      func: () async {
                                        CustomSecureStorage
                                            customSecureStorage =
                                            CustomSecureStorage();
                                        await DataProvider()
                                            .deleteNotification('2');
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
                                                (Route<dynamic> route) =>
                                                    false);
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
                              // width: 134.w,
                              // buttonColor: ColorConstants.buttonColor2,
                              buttonTitle: LabelText.no, style: Styles.white146,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 20.h),
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
                          //         width: MediaQuery.of(context).size.width * 0.4,
                          //         buttonTitle: 'Pending ($count)',
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
                          showNotification
                              ? InkWell(
                                  onTap: () async {
                                    if (notificationList.isNotEmpty) {
                                      showNotificationList(context);
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
                                          color: Colors.black,
                                          size: 45,
                                        ),
                                        if (notificationList.isNotEmpty)
                                          Container(
                                            height: 20.h,
                                            width: 20.h,
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors
                                                  .red, // Set your badge background color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                notificationList.length
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Colors
                                                      .white, // Set your badge text color
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                    SizedBox(height: 25.h),
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
                                //   await CustomSecureStorage.createDbBackup();
                                if (i == 0) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteConstants.trainingListScreen,
                                  );
                                }
                                if (i == 1) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    RouteConstants
                                        .handholdingscheduleListScreen,
                                  );
                                }
                                if (i == 2) {
                                  Navigator.pushReplacementNamed(context,
                                      RouteConstants.syncronizationPage,
                                      arguments: [count]);
                                }
                                if (i == 3) {
                                  FileSharingHelper.shareAssetFile(
                                      'assets/share/Arpan.apk',
                                      message: 'Sharing APK file');
                                  /*  Navigator.pushReplacementNamed(
                                            context,
                                            RouteConstants.shareapk,
                                          );
                                          */
                                }
                              },
                              child: Center(
                                // color: Colors.blue,
                                child: images[i].contains('.png')
                                    ? Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Image.asset(
                                            images[i],
                                          ),
                                          count > 0 && i == 2
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
                                    : shareApk(),
                              )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
      ),
    );
  }

  Future<void> showNotificationList(BuildContext context) async {
    OverlayEntry? overlayEntry;
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
                      await DataProvider().deleteNotification('2');
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

    Overlay.of(context).insert(overlayEntry);
    await Future.delayed(const Duration(
        seconds: 5)); // Adjust delay or use a button to close the list
    await DataProvider().deleteNotification('2');
    overlayEntry.remove();
    notificationList.clear();
    setState(() {});
  }

  shareApk() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                    Icons.share,
                    size: 80.0, // Adjust the size of the phone icon
                    color: Colors
                        .red.shade800, // Adjust the color of the phone icon
                  ),
                ],
              ),
              const Spacer(), // Add some spacing between the icon and text
              Text(
                'Share Apk',
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
}
