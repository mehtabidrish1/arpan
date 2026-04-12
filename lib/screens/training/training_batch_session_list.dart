// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/models/TrainerEstablishmentList_model.dart';
import 'package:arpan/models/training_registration_attendance_data.dart';
import 'package:arpan/models/training_schedule_participant_model.dart';
import 'package:arpan/screens/training/trainingList.dart';
import 'package:arpan/screens/training/training_batch_creation.dart';
import 'package:arpan/screens/training/training_survey_poll_responsePage.dart';
import 'package:arpan/screens/training/trainingdetailScreen.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/download_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toast/toast.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../models/question_model.dart';
import '../../table_model/qr_code_model.dart';
import '../../table_model/tblAttendance_count.dart';
import '../../table_model/tbl_block_model.dart';
import '../../table_model/tbl_training_registration_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/lableText.dart';
import '../../utils/log_files.dart';
import '../../utils/upload_data.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../dashboard/attendances/attendanceDetail.dart';
import 'full_page_dialog.dart';

class TrainingBatchSessionListPage extends StatefulWidget {
  const TrainingBatchSessionListPage({Key? key}) : super(key: key);

  @override
  State<TrainingBatchSessionListPage> createState() =>
      _TrainingBatchSessionListPageState();
}

class _TrainingBatchSessionListPageState
    extends State<TrainingBatchSessionListPage> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var trainingRegistrationdetail = TblTrainingRegistration();
  var trainingRegCount = <TblAttendanceCount>[];
  int preCount = 0, postCount = 0, feedback = 0, totalatten = 0;
  bool isDisposed = false;
  bool isAuthorized = false;

  String? blockName = "";
  final ScrollController scrcontroller = ScrollController();
  List<TrainingScheduleParticipantModel> trainingScheculdeList = [];
  List<TrainingRegistrationAttendanceDataModel> trainingattendance = [];

  Future<void> setCountValue() async {
    trainingScheculdeList = await DataProvider().getTrainingParticipant(
        scheduledGuid: mainTrainingSchedule.scheduleGuid);
  }

  @override
  void initState() {
    super.initState();
  }

  checkAuthorization() async {
    try {
      String trainers = trainingRegistrationdetail.trainer!;
      var userInfo = await UserInfo().getUserCredentials();
      String userid = userInfo['email'];
      var trainnerList = trainers.split(',');
      if (trainnerList.contains(userid.toUpperCase())) {
        isAuthorized = true;
      } else {
        isAuthorized = false;
      }
    } catch (e) {}
  }

  getRefreshFromApi() async {
    var checkInternet = await CustomSecureStorage().checkInternetConnectivity();
    if (!checkInternet) {
      Toast.show("No internet",
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return;
    }
    setState(() {});

    /*await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
        func: () async {
          try {
            await UploadAllData().syncAllData();
            // await UploadAllData().uploadBatchSession();
             await refreshCount(refresh:true);
           /* await DataDownload().getAttendanceCount(
                trainingRegistrationdetail.registrationGuid!,
                mainTrainingSchedule.preSurveyId!,
                mainTrainingSchedule.postSurveyId!,
                mainTrainingSchedule.feedbackSurveyId!);
                 await refreshCount(refresh:true);*/
          } catch (error, stackTrace) {
            logError(error, stackTrace);
          }

          return LabelText.success;
        },
        goOnline: false,
        title: LabelText.pleaseWait,
      ),
    );
    */
  }

  refreshCount({bool? refresh}) async {
    trainingRegCount = await DataProvider().getTrainingBatchCount(
        trainingRegistrationdetail.registrationGuid!.trim());
    // var trainingRegSessionListAll = await DataProvider()
    //     .getTrainingBatchSession(trainingRegistrationdetail.registrationGuid!);

    try {
      try {
        if (trainingRegCount != null && trainingRegCount.isNotEmpty) {
          preCount = trainingRegCount
              .where((element) =>
                  element.Type!.toLowerCase() ==
                  'PreSurveyAttendance'.toLowerCase())
              .first
              .TotalAttendanec!;
        }
      } catch (e) {}

      try {
        if (trainingRegCount != null && trainingRegCount.isNotEmpty) {
          postCount = trainingRegCount
              .where((element) =>
                  element.Type!.toLowerCase() ==
                  'PostSurveyAttendance'.toLowerCase())
              .first
              .TotalAttendanec!;
        }
      } catch (e) {}

      try {
        if (trainingRegCount != null && trainingRegCount.isNotEmpty) {
          feedback = trainingRegCount
              .where((element) =>
                  element.Type!.toLowerCase() ==
                  'FeedBackAttendance'.toLowerCase())
              .first
              .TotalAttendanec!;
        }
      } catch (e) {}
      try {
        if (trainingRegCount != null && trainingRegCount.isNotEmpty) {
          totalatten = trainingRegCount
              .where((element) =>
                  element.Type!.toLowerCase() ==
                  'TraningAttendance'.toLowerCase())
              .first
              .TotalAttendanec!;
        }
      } catch (e) {}
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    if (refresh!) {
      setState(() {});
    }
  }

  Future<String> fetchData() async {
    // Simulate fetching data from an API or database
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      mainTrainingSchedule = data[0];
      trainingRegistrationdetail = data[1];
    }
    checkAuthorization();

    try {
      List<BlockDatum> blocks = await DataProvider().getAllBlock();
      blockName = blocks
          .where((element) =>
              element.id.toString() == trainingRegistrationdetail.Block)
          .first
          .blockName;
    } catch (e) {}

    await UploadAllData().syncAllData();
    await DataDownload().getTrainingParticipantList(
        trainingScheduleGuid: trainingRegistrationdetail.scheduleGuid!);
    await DataDownload().downloadAttendceDetailList(
        regGuid: trainingRegistrationdetail.registrationGuid!);
    await DataDownload().getPartialAttendancesDetailList(
        regGuid: trainingRegistrationdetail.registrationGuid!);

    await DataDownload().getAttendanceCount(
        trainingRegistrationdetail.registrationGuid!,
        mainTrainingSchedule.preSurveyId!,
        mainTrainingSchedule.postSurveyId!,
        mainTrainingSchedule.feedbackSurveyId!);
    await refreshCount(refresh: false);
    return '';
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 300.w,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      // Navigator.pop(context);
                      isDisposed = true;
                      await Navigator.popAndPushNamed(
                          context, RouteConstants.trainingBatchList,
                          arguments: mainTrainingSchedule);
                    },
                  ),
                  Text(
                    LabelText.batchSession,
                    style: Styles.red164
                        .copyWith(color: ColorConstants.defaultMaroon),
                  )
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: ColorConstants.defaultMaroon,
                  ),
                  onPressed: () async {
                    await getRefreshFromApi();
                    // Do something when the refresh icon is pressed
                  },
                ),
              ]),
          /*  floatingActionButton: Container(
            width: 50,
            height: 50,
            child: FloatingActionButton(
              onPressed: () async {
                isDisposed = true;
                await Navigator.popAndPushNamed(
                  context,
                  RouteConstants.trainingBatchSessionCreation,
                  arguments: [
                    mainTrainingSchedule,
                    trainingRegistrationdetail,
                    null
                  ],
                );
              },
              backgroundColor: Color(0xffF97378),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.defaultRedColor),
                child: Icon(
                  Icons.add,
                  size: 30,
                ),
              ),
              
            )),*/
          body: Center(
            child: FutureBuilder<String>(
              // Future to be resolved
              future: fetchData(),
              // Builder function with the snapshot
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Press button to start.');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/rightButterflyTheme.png'),
                              fit: BoxFit.fill)),
                      child: SafeArea(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Card(
                                      color: Color(0xffFFF7F7),
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Color(0xff707070),
                                            width:
                                                1), // set the border color and width
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              createRowWidget(
                                                  LabelText.year,
                                                  mainTrainingSchedule.year ??
                                                      '',
                                                  "assets/dateBetween.png"),
                                              const Divider(
                                                  color: Color(0xff707070)),
                                              createRowWidget(
                                                  LabelText.trainingName,
                                                  mainTrainingSchedule
                                                          .trainingName ??
                                                      '',
                                                  "assets/trainingName.png"),
                                              const Divider(
                                                  color: Color(0xff707070)),
                                              createRowWidget(
                                                  LabelText.tog,
                                                  mainTrainingSchedule
                                                          .typeOfGroup ??
                                                      '',
                                                  "assets/trainerName.png"),
                                              if (trainingRegistrationdetail
                                                      .isEdited ==
                                                  0) ...[
                                                const Divider(
                                                    color: Color(0xff707070)),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: createRowWidget(
                                                          LabelText
                                                              .trainingCode,
                                                          trainingRegistrationdetail
                                                                  .trainingCode ??
                                                              '',
                                                          "assets/topicCovered.png"),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          Clipboard.setData(
                                                              ClipboardData(
                                                                  text: trainingRegistrationdetail
                                                                      .trainingCode??''));
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  'Copied to clipboard!'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ),
                                                          );
                                                        },
                                                        icon: Icon(
                                                            Icons.content_copy))
                                                  ],
                                                ),
                                              ]
                                            ]),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Visibility(
                                      visible: false,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Visibility(
                                            visible: true,
                                            child: Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              AttendanceDetail(
                                                                title: LabelText
                                                                    .totalRegistered,
                                                                trainingRegistration:
                                                                    trainingRegistrationdetail,
                                                              )));
                                                },
                                                child: Card(
                                                  child: AttendanceDetailInfo(
                                                    image: Image.asset(
                                                      "assets/markedattendance.png",
                                                      scale: 2,
                                                    ),
                                                    title: LabelText
                                                        .totalRegistered,
                                                    value: 0,
                                                    color: ColorConstants
                                                        .greyColor1,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            AttendanceDetail(
                                                              title: LabelText
                                                                  .attendanceMarked,
                                                              trainingRegistration:
                                                                  trainingRegistrationdetail,
                                                            )));
                                              },
                                              child: Card(
                                                child: AttendanceDetailInfo(
                                                  image: Image.asset(
                                                    "assets/markedattendance.png",
                                                    scale: 2,
                                                  ),
                                                  title: LabelText
                                                      .attendanceMarked,
                                                  color: ColorConstants
                                                      .attendancemarkedcard,
                                                  value: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              downloadPollSurveyData(
                                                  trainingRegistrationdetail
                                                      .registrationGuid,
                                                  mainTrainingSchedule
                                                      .preSurveyId);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xffBABABA),
                                                    width:
                                                        1), // set the border color and width
                                                borderRadius: BorderRadius.circular(
                                                    8), // set the border radius of the card
                                              ),
                                              child: AttendanceDetailInfo(
                                                image: Image.asset(
                                                  "assets/pre_survey_icon.png",
                                                  scale: 2,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                title:
                                                    LabelText.preSessionsFields,
                                                value: preCount,
                                                color: ColorConstants
                                                    .defaultWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              downloadPollSurveyData(
                                                  trainingRegistrationdetail
                                                      .registrationGuid,
                                                  mainTrainingSchedule
                                                      .postSurveyId);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xffBABABA),
                                                    width:
                                                        1), // set the border color and width
                                                borderRadius: BorderRadius.circular(
                                                    8), // set the border radius of the card
                                              ),
                                              child: AttendanceDetailInfo(
                                                image: Image.asset(
                                                  "assets/post_survey_icon.png",
                                                  scale: 2,
                                                  height: 15,
                                                  width: 15,
                                                ),
                                                title: LabelText
                                                    .postSessionsFields,
                                                color: ColorConstants
                                                    .defaultWhiteColor,
                                                value: postCount,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: GestureDetector(
                                            onTap: () {
                                              //    downloadPollSurveyData(trainingRegistrationdetail.registrationGuid,mainTrainingSchedule.feedbackSurveyId);
                                            },
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color(0xffBABABA),
                                                    width:
                                                        1), // set the border color and width
                                                borderRadius: BorderRadius.circular(
                                                    8), // set the border radius of the card
                                              ),
                                              child: AttendanceDetailInfo(
                                                image: Image.asset(
                                                  "assets/feedback_survey_icon.png",
                                                  height: 15,
                                                  width: 15,
                                                  scale: 2,
                                                ),
                                                title: LabelText.feedback,
                                                value: feedback,
                                                color: ColorConstants
                                                    .defaultWhiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    listBatchSessionCard(
                                        trainingRegistrationdetail)
                                  ])))),
                    );
                }
              },
            ),
          )),
    );
  }

  Widget listBatchSessionCard(TblTrainingRegistration trainingRegistration) {
    // String trainingSessionDate = '';
    // if (trainingRegistration.!.isNotEmpty) {
    //   DateTime inputDate = DateFormat("yyyy-MM-dd")
    //       .parse(trainingBatchsession.trainingSessionDate!);
    //   trainingSessionDate = DateFormat("dd/MM/yyyy").format(inputDate);
    // }
    return Card(
        // color: (index + 1) % 2 == 1 ? Color(0xffFFF7F7) : Color(0xffFFE5E6),
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color(0xff707070),
              width: 1), // set the border color and width
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: 'Block',
                text: blockName,
                icon: "assets/theme.png",
              ),
            ),
            const Divider(color: Color(0xff707070)),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: LabelText.attendanceMarked,
                text: totalatten.toString(),
                icon: "assets/topicCovered.png",
              ),
            ),
            const Divider(color: Color(0xff707070)),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: 'Trainer Name',
                text: trainingRegistration.trainerName,
                icon: "assets/trainerName.png",
              ),
            ),
            !isAuthorized
                ? SizedBox(
                    height: 5.h,
                  )
                : Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Color(0xffFFE5E6),
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffFFE5E6),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              isDisposed = true;
                              await Navigator.popAndPushNamed(
                                context,
                                RouteConstants.markAttendanceScreen,
                                arguments: [
                                  mainTrainingSchedule,
                                  trainingRegistrationdetail,
                                  // trainingBatchsession,
                                  false
                                ],
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/batch.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  LabelText.attendence,
                                  style: Styles.black840,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              await showQrCode(trainingRegistrationdetail);
                            },
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/new_qr.png',
                                  width: 25,
                                  height: 25,
                                ),
                                Text(
                                  LabelText.qrcode,
                                  style: Styles.black840,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              isDisposed = true;
                              await Navigator.popAndPushNamed(
                                context,
                                RouteConstants.markAttendanceScreen,
                                arguments: [
                                  mainTrainingSchedule,
                                  trainingRegistrationdetail,
                                  // trainingBatchsession,
                                  true
                                ],
                              );
                            },
                            child: Column(
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.red,
                                ),
                                /*  Image.asset(
                'assets/other_new.png',
                width: 25,
                height: 25,
              ),*/

                                Text(
                                  LabelText.captureImage,
                                  style: Styles.black840,
                                ),
                              ],
                            ),
                          ),
                          // InkWell(
                          //   onTap: () async {
                          //     isDisposed = true;
                          //     await Navigator.popAndPushNamed(
                          //       context,
                          //       RouteConstants.trainingBatchSessionCreation,
                          //       arguments: [
                          //         mainTrainingSchedule,
                          //         trainingRegistrationdetail,
                          //         // trainingBatchsession
                          //       ],
                          //     );
                          //   },
                          //   child: Column(
                          //     children: [
                          //       Image.asset(
                          //         'assets/edit.png',
                          //         width: 25,
                          //         height: 25,
                          //       ),
                          //       Text(
                          //         LabelText.edit,
                          //         style: Styles.black840,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
          ],
        ));
  }

  Future<void> showQrCode(TblTrainingRegistration trainingRegistration) async {
    List<IndividualPartnerList> individualPartnerList = [];

    var establishmentTypeList =
        trainingRegistration.participantEstablishment!.split(',');
    for (var e in establishmentTypeList) {
      var tempsList = await DataProvider().getIndividualPartnerList();
      print(tempsList.first.individualPartnerCode);
      tempsList = tempsList
          .where((element) => element.individualPartnerCode == e)
          .toList();
      if (tempsList.isNotEmpty) {
        individualPartnerList.add(IndividualPartnerList(
            blockId: tempsList.first.block.toString(),
            districtId: tempsList.first.district.toString(),
            individualPartnerCode: tempsList.first.individualPartnerCode,
            partnerName: tempsList.first.partnerName,
            pincode: tempsList.first.pin.toString(),
            stateId: tempsList.first.state.toString()));
      } else {
        var tempList = await DataProvider().getTrainerEstablishmentList();
        tempList = tempList
            .where((element) => element.establishmentCode == e)
            .toList();
        // if (tempList.isNotEmpty) {
        //   trainerEstablishmentList.add(TrainerEstablishmentDatum(
        //       block: tempList.first.block,
        //       state: tempList.first.state,
        //       pincode: tempList.first.pincode,
        //       district: tempList.first.district,
        //       establishmentCode: tempList.first.establishmentCode,
        //       name: tempList.first.name));
        // }
      }
    }

    var qrCode = QrCodeModel();
    qrCode.scheduleGuid = trainingRegistration.scheduleGuid;
    qrCode.registrationGuid = trainingRegistration.registrationGuid;
    qrCode.surveyId =
        '${mainTrainingSchedule.preSurveyId},${mainTrainingSchedule.postSurveyId},${mainTrainingSchedule.feedbackSurveyId}';
    qrCode.trainerName = trainingRegistration.trainerName;
    qrCode.firstDate =
        '${mainTrainingSchedule.firstDate}|${mainTrainingSchedule.StartTime}';
    qrCode.lastDate =
        '${mainTrainingSchedule.lastDate}|${mainTrainingSchedule.EndTime}';
    qrCode.topicsCoveredName = trainingRegistration.topicsCoveredName;
    qrCode.trainingName = mainTrainingSchedule.trainingName;
    qrCode.blockName = blockName;
    qrCode.typeOfGroup = mainTrainingSchedule.typeOfGroup;
    qrCode.stateId = mainTrainingSchedule.participantStateId;
    qrCode.districtId = mainTrainingSchedule.participantDistrictId;
    qrCode.blockId = mainTrainingSchedule.participantBlockId;
    qrCode.ministryId = mainTrainingSchedule.ministryId;
    // qrCode.establishmentLists = trainerEstablishmentList;
    qrCode.individualPartnerLists = individualPartnerList;

    final jsonString = json.encode(qrCode.toJson());
    var encodedString = base64.encode(utf8
        .encode(jsonString)); //utf8.decode(base64.decode(encoded)); to decode
    int aa = jsonString.length;
    int aa1 = encodedString.length;
    return showDialog<void>(
      context: context,
      // dialog is not dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return FullPageQrCode(
            jsonString: encodedString,
            guid: trainingRegistration.registrationGuid);
      },
    );
  }

  loadBatchAttendanceData(TblTrainingSchedule mainTrainingSchedule,
      TblTrainingRegistration trainingBatch) async {
    try {
      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            Navigator.pushReplacementNamed(
                context, RouteConstants.trainingbatchAttendance,
                arguments: [mainTrainingSchedule, trainingBatch]);
          },
          func: () async {
            await DataDownload()
                .downloadBatchAttendance(trainingBatch.registrationGuid!);

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

  downloadPollSurveyData(String? regUid, String? surveyId) async {
    try {
      List<QuestionData>? questionData = [];

      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          secondFunc: () async {
            if (questionData != null && questionData!.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingSurveyPollResponse(
                    questions: questionData,
                  ),
                ),
              );
            }
          },
          func: () async {
            questionData =
                await DataDownload().getSurevyPollResponse(regUid, surveyId);
            //questionData=   await DataDownload().getSurevyPollResponse(regUid='11D16E95-8150-4A62-B8E9-E61F43C9119C',surveyId='4');

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
}
