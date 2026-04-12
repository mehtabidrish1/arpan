import 'dart:convert';
import 'dart:io';

import 'package:arpan/table_model/tbl_session_attendance.dart';
import 'package:arpan/utils/download_data.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/custom_curvedTextfield.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loca;

import '../../../api/dynamic_response/dynamic_responses.dart';
import '../../../api/training_participant_attendance_api.dart';
import '../../../api/upload_image_api.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/image_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/style/style1.dart';
import '../../../database/dataProvider.dart';
import '../../../models/tbl_partial_attendance_data.dart';
import '../../../models/training_participant_attendance_request_body.dart';
import '../../../models/training_registration_session.dart';
import '../../../models/training_schedule_participant_model.dart';
import '../../../models/uploadImageModel.dart';
import '../../../table_model/tbl_training_registration_model.dart';
import '../../../table_model/tbl_training_schedule_model.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import '../../../utils/upload_data.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_check_box.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../../widgets/registration_text_field.dart';
import '../participant_registration/new_participent_reg_module.dart';
// import '../participant_registration/participant_registration.dart';
import 'custom_camera.dart';

class MarkAttendanceModule extends StatefulWidget {
  const MarkAttendanceModule({Key? key}) : super(key: key);

  @override
  State<MarkAttendanceModule> createState() => _MarkAttendanceModuleState();
}

class _MarkAttendanceModuleState extends State<MarkAttendanceModule> {
  final ScrollController scrcontroller = ScrollController();

  bool docUpload = false;
  List<File> fileList = [];
  DataProvider dbProvider = DataProvider();
  var traingingScheduleParticipantList = <TrainingScheduleParticipantModel>[];
  var maintraingingScheduleParticipantList =
      <TrainingScheduleParticipantModel>[];

  final ScrollController controller = ScrollController();
  TextEditingController imgController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String mobileNumber = '';
  var mainTrainingSchedule = TblTrainingSchedule();
  var trainingRegistration = TblTrainingRegistration();
  var userInfo;
  var attendance = {};
  List<TblBatchPartialAttendanceData> partialAttendanceList = [];

  var ptattendance = {};

  var isDisposed = false;
  var notesdata = '';
  loca.Location location = loca.Location();

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

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data[0];
        trainingRegistration = data[1];
        // trainingBatchsession = data[2];
        docUpload = data[2];
      }
      userInfo = await UserInfo().getUserCredentials();

      maintraingingScheduleParticipantList =
          await dbProvider.getTrainingParticipant(
              scheduledGuid: mainTrainingSchedule.scheduleGuid);
      traingingScheduleParticipantList = maintraingingScheduleParticipantList;
      List<TblSessionAttendance> attenData = await dbProvider
          .getTrainingSessionAttendance(trainingRegistration.registrationGuid!);
      partialAttendanceList = await DataProvider()
          .getBatchPartialAttendanceList(
              trainingRegistration.registrationGuid!);
      for (var element in partialAttendanceList) {
        ptattendance[element.MobileNo] = true;
      }
      for (var element in attenData) {
        attendance[element.phoneNo] = true;
      }

      if (docUpload) {
        fileList.clear();
        await dbProvider.getImageList().then((value) {
          value = value
              .where((element) =>
                  element.registrationGuid ==
                  trainingRegistration!.registrationGuid)
              .toList();
          for (var element in value) {
            var file = File(element.image!);
            fileList.add(file);
          }
        });

        noteController.text = trainingRegistration.notes!;
      }
      setState(() {});
    }
  }

  Future<XFile> pickImageFromCamera() async {
    XFile? imageFile;
    try {
      imageFile = await Navigator.push<XFile?>(
        context,
        MaterialPageRoute(
          builder: (context) => CustomCamera(),
        ),
      );
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    return imageFile!;
  }

  @override
  Widget build(BuildContext context) {
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
                  isDisposed = true;
                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.trainingBatchSessionList,
                    arguments: [mainTrainingSchedule, trainingRegistration],
                  );
                },
              ),
              Text(LabelText.markAttendance,
                  style: Styles.red164.copyWith(
                    color: ColorConstants.defaultMaroon,
                  ))
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (docUpload) ...[
                    SizedBox(height: 10.h),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            try {
                              // var image = await pickImageFromCamera();
                              var image = await showDialog<XFile>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: Text(
                                    "Pick Image",
                                    textAlign: TextAlign.center,
                                    style: Styles.black145,
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            child: Container(
                                              height: 40.h,
                                              child: Center(
                                                  child: Text(
                                                'Gallery',
                                                style: Styles.white146,
                                              )),
                                              decoration: BoxDecoration(
                                                  color: ColorConstants
                                                      .defaultMaroon,
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  40),
                                                          topLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  5),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  5))),
                                            ),
                                            onTap: () async {
                                              final pickedFile =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              // File file;
                                              if (pickedFile != null) {
                                                // var file = File(pickedFile.path);
                                                Navigator.pop(
                                                    context, pickedFile);
                                              } else {
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            child: InkWell(
                                          child: Container(
                                            height: 40.h,
                                            child: Center(
                                                child: Text(
                                              'Camera',
                                              style: Styles.white146,
                                            )),
                                            decoration: BoxDecoration(
                                                color: ColorConstants
                                                    .greyButtonColor,
                                                borderRadius: const BorderRadius
                                                    .only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(40),
                                                    bottomRight:
                                                        Radius.circular(5))),
                                          ),
                                          onTap: () async {
                                            /*  final pickedFile1 =
                                                  await ImagePicker().pickImage(
                                                      source:
                                                          ImageSource.camera);*/
                                            final pickedFile =
                                                await pickImageFromCamera();
                                            if (pickedFile != null) {
                                              // var file = File(pickedFile.path);
                                              Navigator.pop(
                                                  context, pickedFile);
                                            } else {
                                              Navigator.pop(context);
                                            }
                                          },
                                        )),
                                      ],
                                    ),
                                  ],
                                ),
                              );

                              if (image != null) {
                                var abc = File(image.path);
                                var data = UploadImageModel(
                                    image.path,
                                    trainingRegistration?.registrationGuid,
                                    '0');
                                await dbProvider.insertImage(data);
                                // await
                                fileList.add(abc);
                              }
                              setState(() {});
                            } catch (error, stackTrace) {
                              logError(error, stackTrace);
                            }
                          },
                          child: Container(
                            color: ColorConstants.defaultRedColor,
                            width: 50.w,
                            height: 42.h,
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              color: ColorConstants.defaultWhiteColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: 280.w,
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: fileList.length,
                            itemBuilder: ((context, index) {
                              return SizedBox(
                                  width: 100.w,
                                  height: 100.h,
                                  child: Image.file(fileList[index]));
                            }),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 3),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 8.h),
                    RegistrationTextField(
                        textEditingController: noteController,
                        maxlength: 500,
                        onChanged: (val) {
                          if (val != null && val.isNotEmpty) {}
                          notesdata = val;
                          setState(() {});
                        },
                        title: 'Notes'),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CurvedButton(
                            style: Styles.white146,
                            buttonTitle: LabelText.submit,
                            buttonColor: ColorConstants.defaultMaroon,
                            height: 40.h,
                            onPressed: () async {
                              // if (image == null) {
                              //   invalid = true;
                              //   setState(() {});
                              // } else {
                              var isSaved = await showCustomDialog(
                                context,
                                widget: ShowAlertDialogBox(
                                  func: () async {
                                    var isUpload = await UploadImageAPI()
                                        .postImagesToserver(
                                            imageFiles: fileList,
                                            registrationGuid:
                                                trainingRegistration
                                                    .registrationGuid);
                                    if (isUpload) {
                                      await DataProvider()
                                          .updateFlagOfUploadImage(
                                              trainingRegistration
                                                  .registrationGuid!);
                                    }

                                    trainingRegistration.notes = notesdata;
                                    trainingRegistration.isEdited = 1;
                                    trainingRegistration.updatedOn =
                                        DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now());
                                    trainingRegistration.updatedBy =
                                        userInfo['email'].toString();
                                    await DataProvider().insertTrainingBatch(
                                        trainingRegistration);
                                    UploadAllData().uploadBatch();

                                    return '';
                                  },
                                  goOnline: false,
                                  title: LabelText.pleaseWait,
                                ),
                              );

                              await Navigator.popAndPushNamed(
                                context,
                                RouteConstants.trainingBatchSessionList,
                                arguments: [
                                  mainTrainingSchedule,
                                  trainingRegistration
                                ],
                              );
                            },
                          ),
                        ),
                        // SizedBox(
                        //   width: 4.w,
                        // ),
                        Expanded(
                          child: CurvedGreyButton(
                            style: Styles.white146,
                            buttonTitle: LabelText.cancel,
                            height: 40.h,
                            onPressed: () async {
                              isDisposed = true;
                              await Navigator.popAndPushNamed(
                                context,
                                RouteConstants.trainingBatchSessionList,
                                arguments: [
                                  mainTrainingSchedule,
                                  trainingRegistration
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    CurvedTextField(
                      textInputType: TextInputType.phone,
                      hintText: LabelText.searchMobileno,
                      onChanged: (value) {
                        mobileNumber = value;
                        var length = value.length;
                        if (mobileNumber.isNotEmpty &&
                            traingingScheduleParticipantList.isNotEmpty) {
                          traingingScheduleParticipantList =
                              maintraingingScheduleParticipantList
                                  .where((element) =>
                                      element.phoneNo?.substring(0, length) ==
                                      mobileNumber)
                                  .toList();
                        } else {
                          traingingScheduleParticipantList =
                              maintraingingScheduleParticipantList;
                        }

                        setState(() {});
                      },
                      title: '',
                      height: 48.h,
                      preffixIcon: SizedBox(
                        width: 18.w,
                        height: 18.h,
                        child: Center(
                          child: Image.asset(
                            ImageConstants.searchIcon,
                            width: 18.w,
                            height: 18.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 17.h,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: ColorConstants.defaultTextfieldColor),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 18),
                              child: Row(
                                children: [
                                  Text(
                                    LabelText.participantName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xffD71A21)),
                                  ),
                                  SizedBox(
                                    width: 65.w,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 26.w,
                                  left: 18.w,
                                  top: 12.h,
                                  bottom: 12.h),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: AutoSizeText(
                                      'Name',
                                      maxLines: 10,
                                      style: GoogleFonts.poppins(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color.fromARGB(
                                              255, 17, 7, 7)),
                                    ),
                                  ),
                                  const Spacer(),
                                  RichText(
                                      text: TextSpan(
                                    text: 'Att',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 17, 7, 7)),
                                  )),
                                  const Spacer(),
                                  RichText(
                                      text: TextSpan(
                                    text: 'Pt Att',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromARGB(
                                            255, 17, 7, 7)),
                                  )),
                                ],
                              ),
                            ),
                            ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    traingingScheduleParticipantList.length ??
                                        0,
                                itemBuilder: (BuildContext context, int index) {
                                  return listparticipent(
                                      traingingScheduleParticipantList[index]);
                                })
                          ],
                        )),
                    SizedBox(
                      height: 25.h,
                    ),
                    CustomButton(
                      textColor: ColorConstants.whiteColorText,
                      buttonTitle: LabelText.submit,
                      buttonColor: Colors.green,
                      height: 43.h,
                      onPressed: () async {
                        await showCustomDialog(
                          context,
                          widget: ShowAlertDialogBox(
                            func: () async {
                              if (attendance.isNotEmpty ||
                                  ptattendance.isNotEmpty) {
                                List<TrainingParticipantAttendanceRequestBody>
                                    postBody = [];
                                List<ParticipantAttendance> attMobile = [];
                                attendance.forEach((key, value) {
                                  attMobile.add(ParticipantAttendance(
                                      mobileNo: key,
                                      longitude: long,
                                      latitude: lat));
                                });
                                List<PartialAttendance> pt_attMobile = [];
                                ptattendance.forEach((key, value) {
                                  pt_attMobile.add(PartialAttendance(
                                    mobileNo: key,
                                  ));
                                  attMobile.add(ParticipantAttendance(
                                      mobileNo: key,
                                      longitude: long,
                                      latitude: lat));
                                });
                                postBody.add(
                                    TrainingParticipantAttendanceRequestBody(
                                        participantAttendance: attMobile,
                                        partialAttendance: pt_attMobile,
                                        sessionGuid: trainingRegistration
                                            .registrationGuid,
                                        scheduleGuid:
                                            trainingRegistration.scheduleGuid,
                                        registrationGuid: trainingRegistration
                                            .registrationGuid,
                                        createdBy: userInfo['email']));
                                String jsonBatch = jsonEncode(postBody);
                                ResponseModel responseModel =
                                    await TrainingParticipantAttendanceAPI()
                                        .postTrainingParticipantAttendance(
                                            postBody: jsonDecode(jsonBatch));

                                await insetAttendance(responseModel);
                                await DataDownload().getAttendanceCount(
                                    trainingRegistration.registrationGuid!,
                                    mainTrainingSchedule.preSurveyId!,
                                    mainTrainingSchedule.postSurveyId!,
                                    mainTrainingSchedule.feedbackSurveyId!);
                                isDisposed = true;
                                await Navigator.popAndPushNamed(
                                  context,
                                  RouteConstants.trainingBatchSessionList,
                                  arguments: [
                                    mainTrainingSchedule,
                                    trainingRegistration
                                  ],
                                );
                                if (responseModel.code == 200) {
                                  return LabelText.success;
                                } else {
                                  return LabelText.uploadFailed;
                                }
                                //  return responseModel;
                              } else {
                                return LabelText.attendenceSheetEmptyMessage;
                              }
                            },
                            goOnline: false,
                            title: LabelText.pleaseWait,
                          ),
                        );

                        // docUpload = true;
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: CurvedButton(
                            buttonTitle: LabelText.addParticipant,
                            style: Styles.white146,
                            buttonColor: ColorConstants.defaultMaroon,
                            height: 35.h,
                            onPressed: () async {
                              final response = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AddParticipantModule(
                                            trainingSchedule:
                                                mainTrainingSchedule,
                                            trainingRegistration:
                                                trainingRegistration,
                                            particepentDetail: null,
                                          )));
                              if (response != null) {
                                //  if (!attendance.containsKey(response.phoneNo)) {
                                maintraingingScheduleParticipantList
                                    .add(response);
                                //attendance[response.phoneNo] = true;
                                //  }
                                attendance[response.phoneNo] = true;
                                setState(() {});
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
                            height: 35.h,
                            onPressed: () async {
                              isDisposed = true;
                              await Navigator.popAndPushNamed(
                                context,
                                RouteConstants.trainingBatchSessionList,
                                arguments: [
                                  mainTrainingSchedule,
                                  trainingRegistration
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ]
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Future<void> insetAttendance(ResponseModel successCode) async {
    await dbProvider.deleteTrainingSessionAttendance(
        trainingRegistration.registrationGuid!);
    attendance.forEach((key, value) async {
      var sessionAtten = TblSessionAttendance();

      sessionAtten.ScheduleGuid = trainingRegistration.scheduleGuid;
      sessionAtten.RegistrationGuid = trainingRegistration.registrationGuid;
      sessionAtten.latitude = lat;
      sessionAtten.longitude = long;
      sessionAtten.phoneNo = key;
      if (successCode.isSuccess) {
        sessionAtten.IsEdited = 0;
      } else {
        sessionAtten.IsEdited = 1;
      }

      await dbProvider.insertTrainingSessionAttendance(sessionAtten);
    });

    if (ptattendance.isNotEmpty) {
      List<TblBatchPartialAttendanceData> dataList = [];
      ptattendance.forEach((key, value) {
        var data = TblBatchPartialAttendanceData();
        data.ScheduleGuid = mainTrainingSchedule.scheduleGuid!;
        data.RegistrationGuid = trainingRegistration.registrationGuid;
        data.MobileNo = key;
        data.CreatedBy = userInfo['email'].toString();
        data.CreatedOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
        data.SyncDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        if (successCode.isSuccess) {
          data.IsEdited = 0;
        } else {
          data.IsEdited = 1;
        }
        data.IsEdited = 1;
        dataList.add(data);
      });

      if (dataList.isNotEmpty) {
        await DataProvider().insertPartial_Attendance(
            dataList, trainingRegistration.registrationGuid);
      }
    }
  }

  Widget listparticipent(TrainingScheduleParticipantModel particepent) {
    if (attendance.containsKey(particepent.phoneNo) &&
        ptattendance.containsKey(particepent.phoneNo)) {
      attendance.remove(particepent.phoneNo);
    }
    final ValueNotifier<bool> buttonClickedTimes =
        ValueNotifier(attendance.containsKey(particepent.phoneNo));
    final ValueNotifier<bool> ptbuttonClickedTimes =
        ValueNotifier(ptattendance.containsKey(particepent.phoneNo));
    return Padding(
      padding:
          EdgeInsets.only(right: 26.w, left: 18.w, top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final response = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AddParticipantModule(
                                trainingSchedule: mainTrainingSchedule,
                                trainingRegistration: trainingRegistration,
                                particepentDetail: particepent,
                              )));
                  if (response != null) {
                    if (!attendance.containsKey(response.phoneNo)) {
                      // maintraingingScheduleParticipantList.add(response);
                      //attendance[response.phoneNo] = true;
                    }
                    int index = maintraingingScheduleParticipantList
                        .indexOf(particepent);
                    if (index < 0) {
                      index = 0;
                    }
                    maintraingingScheduleParticipantList.removeAt(index);
                    // maintraingingScheduleParticipantList.remove(particepent);
                    maintraingingScheduleParticipantList.insert(
                        index, response);

                    attendance[response.phoneNo] = true;

                    setState(() {});
                  }
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/edit.png',
                      width: 35,
                      height: 35,
                    ),
                  ],
                ),
              ),
              RichText(
                  text: TextSpan(
                text: particepent.phoneNo ?? '',
                style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 17, 7, 7)),
              )),
            ],
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            flex: 1,
            child: AutoSizeText(
              particepent.fullName ?? '',
              maxLines: 10,
              style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 17, 7, 7)),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (buttonClickedTimes.value) {
                // It's already selected → Deselect it
                buttonClickedTimes.value = false;
                attendance.remove(particepent.phoneNo);
              } else {
                // Select this, unselect the other
                buttonClickedTimes.value = true;
                ptbuttonClickedTimes.value = false;
                attendance[particepent.phoneNo] = true;
                ptattendance.remove(particepent.phoneNo);
              }
              // buttonClickedTimes.value = !buttonClickedTimes.value;
              // if (buttonClickedTimes.value) {
              //   attendance[particepent.phoneNo] = true;
              //   ptbuttonClickedTimes.value = false;
              //   if (ptattendance.containsKey(particepent.phoneNo)) {
              //     ptattendance.remove(particepent.phoneNo);
              //   }
              // } else {
              //   if (attendance.containsKey(particepent.phoneNo)) {
              //     attendance.remove(particepent.phoneNo);
              //   }
              // }
            },
            child: ValueListenableBuilder(
                valueListenable: buttonClickedTimes,
                builder: ((context, value, child) => IndividualCheckBox(
                      checkedStatus: buttonClickedTimes.value,
                      title: '',
                      color: buttonClickedTimes.value
                          ? ColorConstants.defaultGreenColor
                          : ColorConstants.defaultGreyColor,
                    ))),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (ptbuttonClickedTimes.value) {
                // Already selected → Deselect it
                ptbuttonClickedTimes.value = false;
                ptattendance.remove(particepent.phoneNo);
              } else {
                // Select this, unselect the other
                ptbuttonClickedTimes.value = true;
                buttonClickedTimes.value = false;
                ptattendance[particepent.phoneNo] = true;
                attendance.remove(particepent.phoneNo);
              }
              // ptbuttonClickedTimes.value = !ptbuttonClickedTimes.value;
              // if (ptbuttonClickedTimes.value) {
              //   ptattendance[particepent.phoneNo] = true;
              //   buttonClickedTimes.value = false;
              //   if (attendance.containsKey(particepent.phoneNo)) {
              //     attendance.remove(particepent.phoneNo);
              //   }
              // } else {
              //   if (ptattendance.containsKey(particepent.phoneNo)) {
              //     ptattendance.remove(particepent.phoneNo);
              //   }
              // }
            },
            child: ValueListenableBuilder(
                valueListenable: ptbuttonClickedTimes,
                builder: ((context, value, child) => IndividualCheckBox(
                      checkedStatus: ptbuttonClickedTimes.value,
                      title: '',
                      color: ptbuttonClickedTimes.value
                          ? ColorConstants.defaultGreenColor
                          : ColorConstants.defaultGreyColor,
                    ))),
          )
        ],
      ),
    );
  }
}
