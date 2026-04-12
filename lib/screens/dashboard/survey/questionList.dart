import 'dart:convert';
import 'dart:io';

import 'package:arpan/api/getQrcode_api.dart';
import 'package:arpan/api/participant_trainingRegistrationApi.dart';
import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/constants/secure_storage_keys.dart';
import 'package:arpan/constants/style/style1.dart';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/models/participant_trainingRegistrationModel.dart';
import 'package:arpan/screens/dashboard/survey/postsurveyscorepage.dart';
import 'package:arpan/screens/dashboard/survey/survey_questions.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/custom_loading_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loca;
import 'package:qr_code_tools/qr_code_tools.dart';
import 'package:toast/toast.dart';
import '../../../api/dynamic_response/dynamic_responses.dart';
import '../../../models/qrcode_masterModel.dart';
import '../../../models/training_schedule_participant_model.dart';
import '../../../models/training_surveyQuestionModel.dart';
import '../../../models/training_surveyQuestionOptionsModel.dart';
import '../../../table_model/notification_model.dart';
import '../../../table_model/qr_code_model.dart';
import '../../../table_model/tbl_block_model.dart';
import '../../../table_model/tbl_particepent_training_details.dart';
import '../../../table_model/tbl_participant_scan_details.dart';
import '../../../table_model/tbl_session_attendance.dart';
import '../../../table_model/tblsurvey_response.dart';
import '../../../utils/DownloadData.dart';
import '../../../utils/common.dart';
import '../../../utils/download_data.dart';
import '../../../utils/log_files.dart';
import '../../../utils/upload_data.dart';
import '../../../utils/validate.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_qr_code_scanner.dart';
import '../../../widgets/registration_text_field.dart';
import '../../training/hand_holding_schedule_list_page.dart';

class QuestionListScreen extends StatefulWidget {
  const QuestionListScreen({Key? key}) : super(key: key);

  @override
  State<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends State<QuestionListScreen> {
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  List<ParticipantTrainingRegistrationDatum>
      participantTrainingRegistrationList = [];
  String? scheduleGuid;
  // String? sessionGuid;
  String? mobileNo;
  String qrValue = '';
  String? preSurveyId, postSurveyId, feedbackSurveyId, registrationGuidval;
  bool loading = false;
  String? firstDate;
  String? lastDate;
  String? startTime;
  String? endTime;
  QrCodeModel? qrCodeData;
  ParticipantScanDetails _userdetails = ParticipantScanDetails();
  ParticipantTrainingDetails trainingdetails = ParticipantTrainingDetails();
  TrainingScheduleParticipantModel? trainingParticipantDatum;
  List<TrainingScheduleParticipantModel> currentTrainingParticipant = [];
  List<SurveyResponse> preSurveyData = [];
  List<SurveyResponse> postSurveyData = [];
  List<SurveyResponse> feedbackSurveyData = [];
  loca.Location location = new loca.Location();

  bool _serviceEnabled = false;
  late loca.PermissionStatus _permissionGranted;
  late loca.LocationData _locationData;
  String long = "", lat = "";

  @override
  void initState() {
    // TODO: implement initState
    checkGps();
    super.initState();
  }

  checkGps() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loca.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loca.PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    location.onLocationChanged.listen((loca.LocationData currentLocation) {
      lat = currentLocation.latitude.toString();
      long = currentLocation.longitude.toString();
      // Use current location
    });
  }

  surveyData() async {
    await DataDownload().getDesignationData();
    if (preSurveyId != null) {
      await DownloadData().downloadTrainingSurveyQuestions(preSurveyId!);
      await DownloadData().downloadTrainingSurveyQuestionsOpt(preSurveyId!);
    }

    if (postSurveyId != null) {
      await DownloadData().downloadTrainingSurveyQuestions(postSurveyId!);
      await DownloadData().downloadTrainingSurveyQuestionsOpt(postSurveyId!);
    }

    if (feedbackSurveyId != null) {
      await DownloadData().downloadTrainingSurveyQuestions(feedbackSurveyId!);
      await DownloadData()
          .downloadTrainingSurveyQuestionsOpt(feedbackSurveyId!);
    }
    ParticipantTrainingRegistrationModel participantTrainingRegistrationModel;

    var sessionAtten = TblSessionAttendance();
    // sessionAtten.RegistrationSessionGuid = sessionGuid;
    sessionAtten.ScheduleGuid = scheduleGuid;
    sessionAtten.RegistrationGuid = registrationGuidval;
    sessionAtten.latitude = lat;
    sessionAtten.longitude = long;
    sessionAtten.phoneNo = mobileNo;

    sessionAtten.IsEdited = 1;

    // await DataProvider().insertTrainingSessionAttendance(sessionAtten);

    // ResponseModel responseAttendance = await ParticepentMarkAttendanceAPI()
    //     .postMarkAttendance(
    //         sessionGuid: registrationGuidval,
    //         mobileNo: mobileNo,
    //         scheduleGuid: scheduleGuid,
    //         registrationGuid: registrationGuidval,
    //         lat: lat,
    //         long: long);
    // if (responseAttendance.isSuccess) {
    sessionAtten.IsEdited = 0;
    // Toast.show("Attendance marked",
    //     duration: 3,
    //     gravity: Toast.bottom,
    //     backgroundColor: Colors.lightGreen);
    await DataProvider().insertTrainingSessionAttendance(sessionAtten);
    // }

    var responseModel = await ParticipantTrainingRegistrationApi()
        .getParticipantTrainingRegistration(
            registrationGuid: registrationGuidval,
            scheduleGuid: scheduleGuid,
            mobileNo: mobileNo);
    if (responseModel.isSuccess) {
      participantTrainingRegistrationModel =
          responseModel.response as ParticipantTrainingRegistrationModel;
      if (participantTrainingRegistrationModel.errors == null) {
        participantTrainingRegistrationList = [
          ...participantTrainingRegistrationList,
          ...participantTrainingRegistrationModel.data!
        ];
        ParticipantTrainingDetails details = ParticipantTrainingDetails();
        details.mobileNo = mobileNo;
        details.trainingDetail =
            json.encode(participantTrainingRegistrationList);
        details.RegistrationGuid = registrationGuidval;
        await DataProvider().insertParticepentTrainingDetails(details);
      }
    }
    loading = false;
    setState(() {});
  }

  // particepentUpload() async {
  //   TrainingScheduleParticipantModel regData =
  //       TrainingScheduleParticipantModel();
  //   var regParticipantList = await DataProvider()
  //       .getTrainingParticipantWithMobile(mobileNo: mobileNo);
  //   if (regParticipantList != null && regParticipantList.isNotEmpty) {
  //     regData = regParticipantList.last;
  //     regData.scheduleGuid = scheduleGuid;
  //     //  regData.scheduleGuid = registrationGuidval;
  //     regData.isEdited = 1;
  //     await DataProvider().insertParticipent(regData);
  //     await UploadAllData().uploadParticepent(mobileno: mobileNo);
  //   }
  // }

  String postenabletext = '';
  String preenabletext = '';

  bool initialized = false;
  String topicsCoveredName = '';
  String trainingName = '';
  String trainerName = '';

  String blockName = '';
  String trainingDate = '';
  String blockValue = '';

  int? isPrefield = 0;
  int? isPostfield = 0;
  int? isFeedbackfield = 0;
  List<BlockDatum> blocks = [];
  List<NotificationModel> notificationList = [];

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // TODO: implement didChangeDependencies
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      qrCodeData = data;
    }
    if (!initialized) {
      initialized = true;
      blocks = await DataProvider().getAllBlock();
      mobileNo = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.phone);
      var trainingListData = await DataProvider()
          .getTrainingParticipantWithMobile(mobileNo: mobileNo);
      if (trainingListData.isNotEmpty) {
        trainingParticipantDatum = trainingListData[0];
      }
      notificationList = await DataProvider().getNotification();

      _userdetails = await DataProvider().getParticipantScanDetails(mobileNo!);
      registrationGuidval = _userdetails.registrationGuid ?? '0';
      var firstDateTime = _userdetails.firstDate?.split("|");
      var lastDateTime = _userdetails.lastDate?.split("|");
      if (Validate.checkIsTrainingStart(
          firstDateTime?[0] ?? '', firstDateTime?[1] ?? '')) {
        loading = false;
        return;
      } else if (Validate.checkIsTrainingClosed(
          lastDateTime?[0] ?? '', lastDateTime?[1] ?? '')) {
        loading = false;
        return;
      }

      try {
        var surveyidList = _userdetails.surveyId?.split(",");
        registrationGuidval = _userdetails.registrationGuid ?? '0';
        scheduleGuid = _userdetails.scheduleGuid ?? '0';
        // sessionGuid = _userdetails.registrationSessionGuid ?? '0';
        preSurveyId = surveyidList != null ? surveyidList[0] : '0';
        postSurveyId = surveyidList != null ? surveyidList[1] : '0';
        feedbackSurveyId = surveyidList != null ? surveyidList[2] : '0';
        firstDate = firstDateTime?[0];
        lastDate = lastDateTime?[0];
        startTime = firstDateTime?[1];
        endTime = lastDateTime?[1];
        topicsCoveredName = _userdetails.topicsCoveredName ?? '';
        trainingName = _userdetails.trainingName ?? '';
        trainerName = _userdetails.trainerName ?? '';
        blockName = _userdetails.blockName ?? '';
        try {
          DateTime inputDate1 = DateFormat("yyyy-MM-dd").parse(firstDate!);
          DateTime inputDate2 = DateFormat("yyyy-MM-dd").parse(firstDate!);
          String startDate = DateFormat("dd/MM/yyyy").format(inputDate1);
          String endDate = DateFormat("dd/MM/yyyy").format(inputDate2);
          trainingDate = '$startDate to $endDate';
        } catch (e) {}

        isPrefield = await DataProvider()
            .getSurveyData(preSurveyId, mobileNo, registrationGuidval);
        isPostfield = await DataProvider()
            .getSurveyData(postSurveyId, mobileNo, registrationGuidval);
        isFeedbackfield = await DataProvider()
            .getSurveyData(feedbackSurveyId, mobileNo, registrationGuidval);
        // await enablePostAndFeedback();
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }

      trainingdetails = await DataProvider()
          .getParticipantTraingDeatils(mobileNo!, registrationGuidval!);
      if (trainingdetails != null &&
          trainingdetails.trainingDetail != null &&
          trainingdetails.trainingDetail!.isNotEmpty) {
        participantTrainingRegistrationList =
            ParticipantTrainingRegistrationDatum.listFromJson(
                    json.decode(trainingdetails.trainingDetail!))
                .toList();
        loading = false;
      }
      try {
        blockValue = blocks
            .where((element) => element.id.toString() == blockName)
            .first
            .blockName!;
      } catch (e) {}

      currentTrainingParticipant = await DataProvider()
          .getParticipantcurentTraining(scheduleGuid, mobileNo!);
      if (scheduleGuid != null &&
          scheduleGuid != '0' &&
          (currentTrainingParticipant.isEmpty)) {
        var tempQrcode = QrCodeModel();
        tempQrcode.individualPartnerLists =
            _userdetails.individualPartnerLists == null
                ? []
                : List<IndividualPartnerList>.from(json
                    .decode(_userdetails.individualPartnerLists!)!
                    .map((x) => IndividualPartnerList.fromJson(x)));

        tempQrcode.typeOfGroup = _userdetails.typeOfGroup;
        tempQrcode.scheduleGuid = _userdetails.scheduleGuid;
        tempQrcode.registrationGuid = _userdetails.registrationGuid;
        tempQrcode.surveyId = _userdetails.surveyId;
        tempQrcode.trainerName = _userdetails.trainerName;
        tempQrcode.firstDate = _userdetails.firstDate;
        tempQrcode.lastDate = _userdetails.lastDate;
        tempQrcode.topicsCoveredName = _userdetails.topicsCoveredName;
        tempQrcode.trainingName = _userdetails.trainingName;
        tempQrcode.blockName = _userdetails.blockName;
        tempQrcode.stateId = _userdetails.stateId;
        tempQrcode.districtId = _userdetails.districtId;
        tempQrcode.blockId = _userdetails.blockId;
        tempQrcode.ministryId = _userdetails.ministryId;
        Navigator.pushReplacementNamed(context, RouteConstants.newReg,
            arguments: tempQrcode);
      } else {
        if (mounted) {
          String pre = await ScoreCalulation(preSurveyId!, false);
          String post = await ScoreCalulation(postSurveyId!, true);
          preScoreTextval = "Pre Score is $pre %";
          postScoreTextval = "Post Score is $post %";
        }
      }
      try {
        //synced status check
        if (preSurveyId != null ||
            postSurveyId != null ||
            feedbackSurveyId != null) {
          preSurveyData = await DataProvider()
              .getSurveyAllData(preSurveyId, mobileNo, registrationGuidval);
          postSurveyData = await DataProvider()
              .getSurveyAllData(postSurveyId, mobileNo, registrationGuidval);
          feedbackSurveyData = await DataProvider().getSurveyAllData(
              feedbackSurveyId, mobileNo, registrationGuidval);
        }
      } catch (e) {
        // logError(e, stackTrace);
      }
      if (firstDate != null) {
        preenabletext = Validate()
            .checkDatetimeDifferenceForPreText(firstDate!, startTime!);
      }
      if (lastDate != null) {
        postenabletext =
            Validate().checkDatetimeDifferenceForPostText(lastDate!, endTime!);
      }
      /* postEnable = true;
      feedbackEnable = true;
      isDisposed = true;*/
    }
    setState(() {});
  }

  String postScoreTextval = '';
  String preScoreTextval = '';

  /* var preSurveyQuestion;
  enablePostAndFeedback() async {
    preSurveyQuestion =
        await DataProvider().getTrainingSurveyQuestions(preSurveyId!);

    // int preRecordCount = await DataProvider().getSurveyData(preSurveyId, mobileNo, registrationGuidval);
    // int postRecordCount = await DataProvider() .getSurveyData(postSurveyId, mobileNo, registrationGuidval);
    if (Validate.checkDatetimeDifferenceForPost(lastDate!, endTime!)) {
      postEnable = true;
      feedbackEnable = true;
    } else {}
  }*/
  Future<QrCodeModel?> dialog() async {
    TextEditingController trainingCodeController = TextEditingController();
    var abc = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(left: 19.w, right: 19.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0.r))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 310.w,
                  ),
                  Text(
                    "Enter Training Code",
                    style: Styles.black145,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                            color: ColorConstants.textFieldTitleColor)),
                    child: RegistrationTextField(
                      title: '',
                      subTitle: 'Training Code',
                      textInputType: TextInputType.text,
                      textEditingController: trainingCodeController,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CurvedButton(
                          style: Styles.white146,
                          buttonTitle: LabelText.submit,
                          onPressed: () async {
                            if (await Validate().checkInternetConnectivity()) {
                              if (trainingCodeController.text.isNotEmpty) {
                                QRcodeMasterModel allMasterData;
                                ResponseModel responseModel = await QRcodeApi()
                                    .getQRcodeData(trainingCodeController.text);
                                if (responseModel.isSuccess) {
                                  allMasterData = responseModel.response
                                      as QRcodeMasterModel;

                                  if (allMasterData.errors == null) {
                                    QrCodeModel dataAll =
                                        allMasterData.data.first;
                                    Navigator.pop(context, dataAll);
                                  }
                                } else {
                                  Toast.show("Invalid Training Code",
                                      duration: 3,
                                      gravity: Toast.bottom,
                                      backgroundColor: Colors.red);
                                }
                              } else {
                                Toast.show("Please enter training code",
                                    duration: 3,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              }
                            } else {
                              Toast.show("Check internet connection",
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: CurvedGreyButton(
                          style: Styles.white146,
                          buttonTitle: LabelText.cancel,
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
          });
        });
    return abc;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        // leadingWidth: 200.w,
        leading: trainingParticipantDatum != null &&
                trainingParticipantDatum!.fullName != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.participentdashboardScreen,
                  );
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.home_outlined,
                  color: Colors.black,
                  size: 45,
                ),
                onPressed: () async {
                  var indirectList = await DataProvider()
                      .getTblTraningIndirectDataList(mobileNo!);
                  ParticipantScanDetails scanDetails =
                      await DataProvider().getParticipantScanDetails(mobileNo!);
                  if (indirectList.isNotEmpty ||
                      scanDetails.registrationGuid != null) {
                    FocusScope.of(context).unfocus();
                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.participentdashboardScreen,
                    );
                  } else {
                    var internet = await Validate().checkInternetConnectivity();
                    if (internet) {
                      await DataDownload()
                          .downloadTblTraningIndirectDataList(mobileNo, '');
                      await DataDownload()
                          .getTrainingParticipantList(mobileno: mobileNo);
                      var indirect = await DataProvider()
                          .getTblTraningIndirectDataList(mobileNo!);
                      if (indirect.isNotEmpty) {
                        FocusScope.of(context).unfocus();
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.participentdashboardScreen,
                        );
                      } else {
                        if (mounted) {
                          Toast.show('No older record found.',
                              duration: 3,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }
                      }
                    } else {
                      if (mounted) {
                        Toast.show('No older record found.',
                            duration: 3,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);
                      }
                    }
                  }
                },
              ),
        title: Text(
          "Training",
          style: Styles.red164,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
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
                    if (notificationList.length > 0)
                      Container(
                        height: 20.h,
                        width: 20.h,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red, // Set your badge background color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            notificationList.length.toString(),
                            style: TextStyle(
                              color: Colors.white, // Set your badge text color
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.h,
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () async {
                    // openForScan();
                  },
                  child: Image.asset(
                    "assets/qrCode.png",
                    filterQuality: FilterQuality.high, width: 50.w,
                    // width: 20.8.w,
                    // color: ColorConstants.whiteColorText,
                  ),
                ),
                SizedBox(height: 15.h),
                Text(
                  "Choose option for scanning\nthe image",
                  textAlign: TextAlign.center,
                  style: Styles.black145,
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: CurvedButton(
                          buttonColor: ColorConstants.defaultMaroon,
                          buttonTitle: 'Gallery',
                          style: Styles.white146,
                          height: 35.h,
                          onPressed: () async {
                            // Navigator.pop(context);
                            var result = await _pickImage(ImageSource.gallery);
                            if (result != null && mounted) {
                              try {
                                String decoded =
                                    utf8.decode(base64.decode(result));
                                var qrcodeData =
                                    QrCodeModel.fromJson(jsonDecode(decoded));
                                if (qrcodeData.surveyId != null) {
                                  await showprogress(qrcodeData);
                                } else {
                                  Toast.show("Invalid QrCode",
                                      duration: 3,
                                      gravity: Toast.bottom,
                                      backgroundColor: Colors.red);
                                }
                              } catch (e) {
                                Toast.show("Invalid QrCode",
                                    duration: 3,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              }
                            }
                          },
                        ),
                      ),
                      Expanded(
                          child: CurvedGreyButton(
                        buttonTitle: 'Camera',
                        style: Styles.white146,
                        height: 35.h,
                        onPressed: () async {
                          // Navigator.pop(context);
                          var data = await showDialog(
                              context: context,
                              builder: ((context) =>
                                  CustomQRCodeScanner(callback: (value) async {
                                    if (value.format.name == 'qrcode') {
                                      qrValue = value.code ?? '';
                                      // await readScannedValue(qrValue);
                                    }
                                    //return qrValue!;
                                  })));
                          try {
                            String decoded = utf8.decode(base64.decode(data));
                            var qrcodeData =
                                QrCodeModel.fromJson(jsonDecode(decoded));
                            if (qrcodeData.surveyId != null) {
                              await showprogress(qrcodeData);
                            } else {
                              Toast.show("Invalid QrCode",
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          } catch (e) {
                            Toast.show("Invalid QrCode",
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                          }
                        },
                      )),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                RichText(
                  text: TextSpan(
                    text: 'Can\'t scan QR code? ',
                    style: Styles.black145,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Click here.',
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            try {
                              var qrcodeData = await dialog();
                              if (qrcodeData != null &&
                                  qrcodeData.surveyId != null) {
                                await showprogress(qrcodeData);
                              }
                            } catch (e) {
                              Toast.show("Invalid Code/Error Occured",
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                if (!(preSurveyId == null || preSurveyId == '0')) ...{
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Text("$preenabletext"),
                  ),
                },
                if (!(postSurveyId == null || postSurveyId == '0')) ...{
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    child: Text("$postenabletext"),
                  )
                },
                // (loading == false &&
                //         participantTrainingRegistrationList.isNotEmpty)
                (loading == false && _userdetails.trainingName != null)
                    ? Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.defaultWhiteColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 5.h),
                        child: Card(
                          elevation: 2,
                          color: ColorConstants.presessioncard,
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
                                  // Text(postenabletext),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  TrainingTitle(
                                    title: LabelText.trainingName,
                                    text: trainingName,
                                    icon: "assets/trainingName.png",
                                  ),
                                  const Divider(color: Color(0xff707070)),
                                  TrainingTitle(
                                    title: LabelText.trainer,
                                    text: trainerName,
                                    icon: "assets/trainerName.png",
                                  ),
                                  const Divider(color: Color(0xff707070)),
                                  TrainingTitle(
                                    title: LabelText.intervention,
                                    text: participantTrainingRegistrationList
                                            .isNotEmpty
                                        ? participantTrainingRegistrationList
                                            .first.trainingType
                                        : '',
                                    icon: "assets/theme.png",
                                  ),
                                  const Divider(color: Color(0xff707070)),
                                  /* TrainingTitle(
                                    title: LabelText.topicCovered,
                                    text: topicsCoveredName,
                                    icon: "assets/topicCovered.png",
                                  ),
                                  const Divider(color: Color(0xff707070)),*/
                                  TrainingTitle(
                                    title: LabelText.block,
                                    text: blockName,
                                    icon: "assets/theme.png",
                                  ),
                                  const Divider(color: Color(0xff707070)),
                                  TrainingTitle(
                                    title: LabelText.date,
                                    text: trainingDate,
                                    icon: "assets/dateBetween.png",
                                  ),
                                ]),
                          ),
                        ),
                      )
                    : (loading == true)
                        ? const SizedBox(
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : SizedBox(),
                if (isPreScoreVisible) ...{
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: CustomButton(
                        buttonColor: Colors.green,
                        // buttonColor: ColorConstants.defaultRedColor,
                        textColor: ColorConstants.whiteColorText,
                        buttonTitle: preScoreTextval,
                        height: 49.h,
                        onPressed: () async {
                          if (isPostScoreVisible) {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PostSurveyScorePage(
                                        preSurveyId,
                                        LabelText.presurvey,
                                        registrationGuidval,
                                        scheduleGuid,
                                        _userdetails)));
                          } else {
                            Toast.show(
                                'Pre survey answer open after completion of post survey',
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                          }
                        }),
                  ),
                },
                const SizedBox(
                  height: 5,
                ),
                if (isPostScoreVisible) ...{
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: CustomButton(
                          buttonColor: Colors.green,
                          // buttonColor: ColorConstants.defaultRedColor,
                          textColor: ColorConstants.whiteColorText,
                          buttonTitle: postScoreTextval,
                          height: 49.h,
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => PostSurveyScorePage(
                                        postSurveyId,
                                        LabelText.postsurvey,
                                        registrationGuidval,
                                        scheduleGuid,
                                        _userdetails)));
                          })),
                },
                SizedBox(
                  height: 30.h,
                ),
                currentTrainingParticipant.isNotEmpty
                    ? Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${LabelText.attendanceSynced}: ', // "Attendance Synced"
                              style: Styles.defaultFont
                                  .copyWith(color: Colors.black),
                            ),
                            currentTrainingParticipant.first.isEdited == 1
                                ? TextSpan(
                                    text: 'No ❌',
                                    style: Styles.defaultFont.copyWith(
                                        color: ColorConstants.defaultRedColor),
                                  )
                                : TextSpan(
                                    text: 'Yes ✅',
                                    style: Styles.defaultFont.copyWith(
                                        color:
                                            ColorConstants.defaultGreenColor),
                                  ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: !(preSurveyId == null || preSurveyId == '0'),
                      child: InkWell(
                        onTap: () async {
                          if (preSurveyId == null || preSurveyId == '0') {
                            Toast.show("Not able to open",
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                            return;
                          } else {
                            // List<TrainingSurveyQuestionDatum> preSurveyQuestion =
                            //   await DataProvider()
                            //       .getTrainingSurveyQuestions(preSurveyId!);
                            if (Validate.checkDatetimeDifferenceForPre(
                                firstDate!, startTime!)) {
                              if (isPrefield == 0) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SurveyQuestionsScreen(
                                            preSurveyId,
                                            LabelText.presurvey,
                                            registrationGuidval,
                                            scheduleGuid,
                                            _userdetails)));
                              } else {
                                Toast.show(LabelText.alreadySubmited,
                                    duration: 3,
                                    gravity: Toast.bottom,
                                    backgroundColor: Colors.red);
                              }
                            } else {
                              Toast.show(LabelText.notabletoopen,
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          }

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const PreSurveyScreen()));
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Image.asset(
                                ImageConstants.preSurveyIcon,
                                height: 25.h,
                              )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                LabelText.presurvey,
                                style: Styles.defaultFont.copyWith(
                                    color: ColorConstants.defaultBlueColor),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              isPrefield != 0
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${LabelText.synced} ',
                                            style: Styles.defaultFont
                                                .copyWith(color: Colors.black),
                                          ),
                                          preSurveyData.isNotEmpty &&
                                                  preSurveyData
                                                          .first.isEdited ==
                                                      1
                                              ? TextSpan(
                                                  text: 'No ❌',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultRedColor),
                                                )
                                              : TextSpan(
                                                  text: 'Yes ✅',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultGreenColor),
                                                ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 16.h,
                    // ),
                    Visibility(
                      visible: !(postSurveyId == null || postSurveyId == '0'),
                      child: InkWell(
                        onTap: () async {
                          if (postSurveyId == null || postSurveyId == '0') {
                            Toast.show("Not able to open",
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                            return;
                          }
                          // List<TrainingSurveyQuestionDatum> preSurveyQuestion =
                          //     await DataProvider()
                          //         .getTrainingSurveyQuestions(postSurveyId!);
                          if (Validate.checkDatetimeDifferenceForPost(
                              lastDate!, endTime!)) {
                            if (isPostfield == 0) {
                              await Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SurveyQuestionsScreen(
                                          postSurveyId,
                                          LabelText.postsurvey,
                                          registrationGuidval,
                                          scheduleGuid,
                                          _userdetails)));
                            } else {
                              Toast.show(LabelText.alreadySubmited,
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          } else {
                            Toast.show(LabelText.notabletoopen,
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                          }
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Image.asset(
                                ImageConstants.postSurveyIcon,
                                height: 25.h,
                              )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                LabelText.postsurvey,
                                style: Styles.defaultFont.copyWith(
                                    color: ColorConstants.defaultRedColor),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              isPostfield != 0
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${LabelText.synced} ',
                                            style: Styles.defaultFont
                                                .copyWith(color: Colors.black),
                                          ),
                                          postSurveyData.isNotEmpty &&
                                                  postSurveyData
                                                          .first.isEdited ==
                                                      1
                                              ? TextSpan(
                                                  text: 'No ❌',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultRedColor),
                                                )
                                              : TextSpan(
                                                  text: 'Yes ✅',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultGreenColor),
                                                ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 16.h,
                    // ),
                    Visibility(
                      visible: !(feedbackSurveyId == null ||
                          feedbackSurveyId == '0'),
                      child: InkWell(
                        onTap: () async {
                          if (feedbackSurveyId == null ||
                              feedbackSurveyId == '0') {
                            Toast.show("Not able to open",
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                            return;
                          }
                          // List<TrainingSurveyQuestionDatum> preSurveyQuestion =
                          //     await DataProvider()
                          //         .getTrainingSurveyQuestions(postSurveyId!);
                          if (Validate.checkDatetimeDifferenceForPost(
                              lastDate!, endTime!)) {
                            if (isFeedbackfield == 0) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SurveyQuestionsScreen(
                                          feedbackSurveyId,
                                          LabelText.feedback,
                                          registrationGuidval,
                                          scheduleGuid,
                                          _userdetails)));
                            } else {
                              Toast.show(LabelText.alreadySubmited,
                                  duration: 3,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          } else {
                            Toast.show(LabelText.notabletoopen,
                                duration: 3,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.red);
                          }
                          // List<TrainingSurveyQuestionDatum> preSurveyQuestion =
                          //     await DataProvider()
                          //         .getTrainingSurveyQuestions(feedbackSurveyId!);
                        },
                        child: Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Image.asset(
                                ImageConstants.surveyIcon,
                                height: 25.h,
                              )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                LabelText.feedback,
                                style: Styles.defaultFont.copyWith(
                                    color: ColorConstants.defaultYellowColor),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              isFeedbackfield != 0
                                  ? Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${LabelText.synced} ',
                                            style: Styles.defaultFont
                                                .copyWith(color: Colors.black),
                                          ),
                                          feedbackSurveyData.isNotEmpty &&
                                                  feedbackSurveyData
                                                          .first.isEdited ==
                                                      1
                                              ? TextSpan(
                                                  text: 'No ❌',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultRedColor),
                                                )
                                              : TextSpan(
                                                  text: 'Yes ✅',
                                                  style: Styles.defaultFont
                                                      .copyWith(
                                                          color: ColorConstants
                                                              .defaultGreenColor),
                                                ),
                                        ],
                                      ),
                                    )
                                  : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 60.h)
              ],
            ),
          )),
        ),
      ),
    );
  }

  File? _image;

  Future<String?> _pickImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;
    String? result = await QrCodeToolsPlugin.decodeFrom(pickedFile.path);
    print(result);

    return result;
    // if (mounted) {
    //   await showprogress(result);
    // }
  }

  showprogress(QrCodeModel qrCodeData) async {
    await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
        secondFunc: () async {
          FocusScope.of(context).unfocus();
          // isDisposed = true;
          if (Validate.checkIsTrainingStart(firstDate!, startTime!)) {
            return 'Training is not started';
          } else if (Validate.checkIsTrainingClosed(lastDate!, endTime!)) {
            return 'Training is closed';
          }

          // QrCodeModel qrCodeData;
          // qrCodeData = QrCodeModel.fromJson(jsonDecode(result));
          Navigator.pushReplacementNamed(context, RouteConstants.newReg,
              arguments: qrCodeData);
        },
        func: () async {
          if (qrCodeData.surveyId == null || qrCodeData.surveyId!.isEmpty) {
            Toast.show("Invalid QrCode",
                duration: 3,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
            return "";
          } else {
            // qrCodeData = QrCodeModel.fromJson(jsonDecode(result));
            await readScannedValue(qrCodeData);

            if (Validate.checkIsTrainingStart(firstDate!, startTime!)) {
              return 'Training is not started';
            } else if (Validate.checkIsTrainingClosed(lastDate!, endTime!)) {
              return 'Training is closed';
            } else {
              return '';
            }

            // return "";
          }
          // QrCodeModel qrCodeData = QrCodeModel.fromJson(jsonDecode(qrValue));
          // return "";
        },
        goOnline: false,
        title: LabelText.pleaseWait,
      ),
    );
  }

  readScannedValue(QrCodeModel qrValue) async {
    // QrCodeModel qrCodeData;

    // if (qrValue == null || qrValue.isEmpty) {
    //   return;
    // }
    if (true) {
      loading = true;
      try {
        List<String> firstDateTime = [];
        List<String> lastDateTime = [];
        firstDateTime = qrValue.firstDate!.split("|");
        lastDateTime = qrValue.lastDate!.split("|");
        var surveyIdList = qrValue.surveyId!.split(",");
        scheduleGuid = qrValue.scheduleGuid;
        registrationGuidval = qrValue.registrationGuid;
        preSurveyId = surveyIdList[0];
        postSurveyId = surveyIdList[1];
        feedbackSurveyId = surveyIdList[2];
        firstDate = firstDateTime[0];
        lastDate = lastDateTime[0];
        startTime = firstDateTime[1];
        endTime = lastDateTime[1];
        //topicsCoveredName = qrValue.topicsCoveredName!;
        trainingName = qrValue.trainingName!;
        trainerName = qrValue.trainerName ?? '';
        blockName = qrValue.blockName!;
        try {
          if (Validate.checkIsTrainingStart(firstDate!, startTime!)) {
            loading = false;
            preSurveyId = '0';
            postSurveyId = '0';
            feedbackSurveyId = '0';
            return 'Training is not started';
          } else if (Validate.checkIsTrainingClosed(lastDate!, endTime!)) {
            preSurveyId = '0';
            postSurveyId = '0';
            feedbackSurveyId = '0';
            loading = false;

            return 'Training is closed';
          }

          DateTime inputDate1 =
              DateFormat("yyyy-MM-dd").parse(firstDateTime[0]);
          DateTime inputDate2 = DateFormat("yyyy-MM-dd").parse(lastDateTime[0]);
          String startDate = DateFormat("dd/MM/yyyy").format(inputDate1);
          String endDate = DateFormat("dd/MM/yyyy").format(inputDate2);
          trainingDate = '$startDate to $endDate';
          preenabletext = Validate()
              .checkDatetimeDifferenceForPreText(firstDate!, startTime!);
          postenabletext = Validate()
              .checkDatetimeDifferenceForPostText(lastDate!, endTime!);
        } catch (e) {}
      } catch (e) {
        loading = false;
        return;
      }
      // qrValue = value.code ?? '';
      if (registrationGuidval == null || registrationGuidval!.isEmpty) {
        loading = false;
        return;
      }
      try {
        blockValue = blockName;
      } catch (e) {
        // blockValue=blockName;
      }
      ParticipantScanDetails details = ParticipantScanDetails();
      details.mobileNo = mobileNo;
      details.scheduleGuid = qrValue.scheduleGuid;
      details.registrationGuid = qrValue.registrationGuid;
      details.surveyId = qrValue.surveyId;
      details.topicsCoveredName = qrValue.topicsCoveredName;
      details.trainingName = qrValue.trainingName;
      details.blockName = qrValue.blockName;
      // details.establishmentLists = jsonEncode(qrValue.establishmentLists!);
      details.individualPartnerLists =
          jsonEncode(qrValue.individualPartnerLists!);
      //  qrValue.individualPartnerLists.toString();
      details.firstDate = qrValue.firstDate;
      details.lastDate = qrValue.lastDate;
      details.trainerName = qrValue.trainerName;
      details.typeOfGroup = qrValue.typeOfGroup;
      details.stateId = qrValue.stateId;
      details.districtId = qrValue.districtId;
      details.blockId = qrValue.blockId;
      details.ministryId = qrValue.ministryId;
      details.isEdited = 1;

      await DataProvider().insertOrUpdateParticepent(details);
      //  await particepentUpload();
      await surveyData();

      // await enablePostAndFeedback();
      //  await ArpanNotification()          .displayNotification('Arpan', 'Please fill pre survey questions');
      await DataProvider().deleteNotification('1');
      await DataProvider().insertNotification(NotificationModel(
          notificationtype: '1',
          notificationmsg: 'Please fill pre survey questions'));
      notificationList = await DataProvider().getNotification();

      setState(() {});
    }
  }

  bool isPostScoreVisible = false;
  bool isPreScoreVisible = false;

  Future<String> ScoreCalulation(String surveyId, bool isPost) async {
    String scoreText = '';
    try {
      List<TrainingSurveyQuestionDatum> postSurveyQuestion =
          await DataProvider().getTrainingSurveyQuestions(surveyId ?? '0');
      List<TrainingSurveyQuestionOptionsDatum> preSurveyQuestionOpt =
          await DataProvider()
              .getTrainingSurveyQuestionOptions(surveyId ?? '0');
      List<SurveyResponse> postSureveyData = await DataProvider()
          .getSurveyAllData(surveyId, mobileNo, registrationGuidval);
      int postScore = 0;
      if (postSureveyData != null && postSureveyData.isNotEmpty) {
        if (isPost) {
          isPostScoreVisible = true;
        } else {
          isPreScoreVisible = true;
        }

        for (var element1 in postSureveyData) {
          List<TrainingSurveyQuestionOptionsDatum> preSurveyQuestionOpt1 =
              preSurveyQuestionOpt
                  .where((element) =>
                      element.questionId == element1.questionId &&
                      element.questionOptionId.toString() == element1.response)
                  .toList();
          if (preSurveyQuestionOpt1 != null &&
              preSurveyQuestionOpt1.isNotEmpty) {
            postScore = postScore + preSurveyQuestionOpt1[0].point!;
          }
        }
        int total = postSurveyQuestion.length;
        var percent = ((postScore / total) * 100).toStringAsFixed(2);
        scoreText = "$percent ";
      }
    } catch (e) {
      print(e.toString());
    }
    return scoreText;
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
                      overlayEntry!.remove();
                      //  await DataProvider().deleteNotification('1');
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

    Overlay.of(context)?.insert(overlayEntry!);

    // Adjust delay or use a button to close the list
    try {
      await Future.delayed(Duration(seconds: 5));
      overlayEntry!.remove();
    } catch (e) {}
  }
}
