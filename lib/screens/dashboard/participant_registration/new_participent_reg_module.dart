// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:arpan/table_model/tbl_block_model.dart';
import 'package:arpan/table_model/tbl_designation_model.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart' as loca;
import 'package:toast/toast.dart';
import '../../../api/training_participant_registration_api.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../database/dataProvider.dart';
import '../../../models/TrainerEstablishmentList_model.dart';
import '../../../models/training_schedule_participant_model.dart';
import '../../../table_model/tbl_district_model.dart';
import '../../../table_model/tbl_master_model.dart';
import '../../../table_model/tbl_state_model.dart';
import '../../../table_model/tbl_teacher_grade_model.dart';
import '../../../table_model/tbl_training_registration_model.dart';
import '../../../table_model/tbl_training_schedule_model.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import '../../../utils/validate.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../../widgets/registration_drop_down.dart';
import '../../../widgets/registration_text_field.dart';
import '../../training/training_batch_session_creation.dart';
// import 'package:location/location.dart ' as loca;

class AddParticipantModule extends StatefulWidget {
  final TblTrainingRegistration? trainingRegistration;
  final TrainingScheduleParticipantModel? particepentDetail;
  final TblTrainingSchedule? trainingSchedule;

  const AddParticipantModule(
      {Key? key,
      this.trainingSchedule,
      this.trainingRegistration,
      this.particepentDetail})
      : super(key: key);

  @override
  State<AddParticipantModule> createState() => _AddParticipantModuleState();
}

class _AddParticipantModuleState extends State<AddParticipantModule> {
  CustomSecureStorage customSecureStorage = CustomSecureStorage();

  DataProvider dbhelper = DataProvider();
  TrainingScheduleParticipantModel trainingDatum =
      TrainingScheduleParticipantModel();
  List<TrainingScheduleParticipantModel> trainingList = [];

  TextEditingController doaController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController approvedStatusController = TextEditingController();
  TextEditingController cityStatusController = TextEditingController();

  TextEditingController zipPostalPinCodeController = TextEditingController();

  // TextEditingController organizationNameController = TextEditingController();

  TextEditingController participantProfileController = TextEditingController();
  TextEditingController attendedBeforeController = TextEditingController();
  TextEditingController monthAndYearController = TextEditingController();
  TextEditingController tehsilNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController otherStateController = TextEditingController();
  TextEditingController otherDistrictController = TextEditingController();
  TextEditingController otherBlockController = TextEditingController();
  TextEditingController udiseCodeController = TextEditingController();
  TextEditingController otherParticipantProfileController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? dob;
  bool hasAttendedBefore = false;
  var userInfo;
  List<TblMasterModel> genderModelList = [];
  List<TblDesignationModel> designationModelList = [];
  List<String> genderlList = [];
  List<String> designationList = [];
  List<String> teacherGrades = [];
  List<String> teacherDesignationList = [];
  List<int> targetMinistryIds = [];
  Map<String, bool> gradeSelection = {};
  bool apiData = false;
  List<String> attendanceBeforeList = [];
  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];
  int languageId = 1;

  bool isBackPressed = false;
  int genderindex = 0;
  int designationindex = 0;
  int ngoindex = 0;
  int attendanceBeforeindex = 0;
  String? selectedMinistryId;
  String stateVal = '';
  String distictValue = '';
  TextEditingController establishmentController = TextEditingController();
  List<TrainerEstablishmentDatum> trainerEstablishmentall = [];
  // List<String> EstablishmentlList = [];

  List<TblStateModel> states = [];
  List<TblDistrictModel> districts = [];
  List<BlockDatum> blockList = [];
  List<TblTeacherGradeModel> teacherGradeList = [];
  String blockValue = '';
  loca.Location location = loca.Location();

  bool _serviceEnabled = false;
  late loca.PermissionStatus _permissionGranted;
  // late loca.LocationData _locationData;
  String long = "", lat = "";
  @override
  void initState() {
    checkGps();
    super.initState();
    LabelText.getLang(languageId);
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
    // _locationData = await location.getLocation();
    location.onLocationChanged.listen((loca.LocationData currentLocation) {
      lat = currentLocation.latitude.toString();
      long = currentLocation.longitude.toString();
      // Use current location
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isBackPressed) {
      userInfo = await UserInfo().getUserCredentials();
      var langID = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.langId);
      if (langID != null) {
        languageId = int.parse(langID);
        LabelText.getLang(languageId);
        selectedLanguagevalue = languages[languageId - 1];
      }
      await setAllListData();
      if (widget.particepentDetail != null) {
        trainingDatum = widget.particepentDetail!;

        setAllData();
      }
    }
    setState(() {});
    isBackPressed = true;
  }

  setAllListData() async {
    var tempStates = await DataProvider().getAllState();
    var tempDistricts = await DataProvider().getAllDistrict();
    var tempBlockList = await DataProvider().getAllBlock();
    teacherGradeList = await DataProvider().getTeacherGradeList();
    var trainingParticipantDistrictId =
        widget.trainingSchedule!.participantDistrictId ?? '';
    var trainingParticipantStateId =
        widget.trainingSchedule!.participantStateId ?? '';
    var trainingParticipantBlockId =
        widget.trainingSchedule!.participantBlockId ?? '';
    if (trainingParticipantBlockId.isNotEmpty) {
      List<int> targetBlockId = trainingParticipantBlockId
          .split(',')
          .map((id) => int.tryParse(id) ?? -1)
          .where((id) => id != -1)
          .toList();

      blockList = tempBlockList.where((block) {
        return (targetBlockId.contains(block.id));
      }).toList();
    } else {
      blockList = tempBlockList;
    }
    if (trainingParticipantStateId.isNotEmpty) {
      List<int> targetStateId = trainingParticipantStateId
          .split(',')
          .map((id) => int.tryParse(id) ?? -1)
          .where((id) => id != -1)
          .toList();

      states = tempStates.where((state) {
        return (targetStateId.contains(state.stateId));
      }).toList();
    } else {
      states = tempStates;
    }
    if (trainingParticipantDistrictId.isNotEmpty) {
      List<int> targetDistrictIds = trainingParticipantDistrictId
          .split(',')
          .map((id) => int.tryParse(id) ?? -1)
          .where((id) => id != -1)
          .toList();

      districts = tempDistricts.where((district) {
        return (targetDistrictIds.contains(district.districtId));
      }).toList();
    } else {
      districts = tempDistricts;
    }
    states.add(
        TblStateModel(stateId: 9999999, stateName: LabelText.getText('Other')));
    districts.add(TblDistrictModel(
        stateId: 9999999,
        districtId: 9999999,
        districtName: LabelText.getText('Other')));
    blockList.add(BlockDatum(
        stateId: 9999999,
        districtId: '9999999',
        id: 9999999,
        blockName: LabelText.getText('Other')));

    designationModelList.clear();
    var tempDesignationModelList = await DataProvider().getAllDesignation();
    var trainingParticipantMinistryId =
        widget.trainingSchedule!.ministryId ?? '';
    if (trainingParticipantMinistryId.isNotEmpty) {
      targetMinistryIds = trainingParticipantMinistryId
          .split(',')
          .map((id) => int.tryParse(id) ?? -1)
          .where((id) => id != -1)
          .toList();

      designationModelList = tempDesignationModelList.where((designation) {
        return (targetMinistryIds
            .contains(int.tryParse(designation.ministryId!)));
      }).toList();
    } else {
      designationModelList = tempDesignationModelList;
    }
    designationModelList.add(TblDesignationModel(
        id: 9999999,
        englishDesignation: LabelText.getText('Other'),
        hindiDesignation: LabelText.getText('Other'),
        marathiDesignation: LabelText.getText('Other')));

    genderModelList.clear();
    designationList.clear();
    designationList.add(LabelText.getText('selectDesignation'));
    if (teacherGradeList.isNotEmpty) {
      teacherGrades = teacherGradeList.map((e) => e.teacherGrade).toList();
    }
    for (var grade in teacherGrades) {
      gradeSelection[grade] = false;
    }
    teacherGrades.add('OK');

    if (languages.indexOf(selectedLanguagevalue) == 1) {
      genderModelList = await DataProvider().getMastrerListData('GenderHindi');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.hindiDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.hindiDesignation!);
      }
    } else if (languages.indexOf(selectedLanguagevalue) == 2) {
      genderModelList =
          await DataProvider().getMastrerListData('GenderMarathi');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.marathiDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.marathiDesignation!);
      }
    } else {
      genderModelList =
          await DataProvider().getMastrerListData('GenderEnglish');
      try {
        for (var element in designationModelList) {
          if (element.englishDesignation!.toLowerCase().contains('teacher')) {
            teacherDesignationList.add(element.englishDesignation!);
          }
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      for (var e in designationModelList) {
        designationList.add(e.englishDesignation!);
      }
    }
    genderlList.clear();
    genderlList.add(LabelText.getText('pleaseSelect'));
    for (var element in genderModelList) {
      genderlList.add(element.text);
    }
    //

    attendanceBeforeList.clear();
    attendanceBeforeList = [
      // 'Please Select', 'Yes', 'No'
      LabelText.getText('pleaseSelect'),
      LabelText.getText('yes'),
      LabelText.getText('no')
    ];
    // participantProfileController = TextEditingController();

    // var tempIndividualPartnerList =
    //     await DataProvider().getIndividualPartnerList();
    // var tempEstablishmentList =
    //     await DataProvider().getTrainerEstablishmentList();
    // var estcode =
    //     widget.trainingRegistration!.participantEstablishment!.split(',');
    // for (var temp in estcode) {
    //   var tmpE = tempEstablishmentList
    //       .where((element) => element.establishmentCode == temp)
    //       .toList();
    //   if (tmpE.isNotEmpty) {
    //     trainerEstablishmentall.add(tmpE.first);
    //   }

    //   var tmpI = tempIndividualPartnerList
    //       .where((element) => element.individualPartnerCode == temp)
    //       .toList();
    //   if (tmpI.isNotEmpty) {
    //     trainerEstablishmentall.add(TrainerEstablishmentDatum(
    //         establishmentCode: tmpI.first.individualPartnerCode,
    //         name: '${tmpI.first.partnerName}(Individual Partner)',
    //         ministryId: int.tryParse(tmpI.first.ministry!),
    //         state: tmpI.first.state,
    //         district: tmpI.first.district.toString(),
    //         block: tmpI.first.block.toString(),
    //         pincode: tmpI.first.pin));
    //   }
    // }

    // EstablishmentlList.clear();
    // EstablishmentlList.add(LabelText.getText('pleaseSelect'));
    // for (var element in trainerEstablishmentall) {
    //   EstablishmentlList.add(element.name!);
    // }
    // if (widget.trainingSchedule!.typeOfGroup! != 'Single Group') {
    //   EstablishmentlList.add('Other');
    // } else {
    //   if (trainerEstablishmentall.isNotEmpty) {
    //     establishmentController.text = trainerEstablishmentall[0].name!;
    //     stateVal = trainerEstablishmentall[0].state.toString();
    //     distictValue = trainerEstablishmentall[0].district.toString();
    //     blockValue = trainerEstablishmentall[0].block.toString();
    //     zipPostalPinCodeController.text =
    //         trainerEstablishmentall[0].pincode.toString();
    //   }
    // }

    participantProfileController.text = designationList[designationindex];
    genderController.text = genderlList[genderindex];
    attendedBeforeController.text = attendanceBeforeList[attendanceBeforeindex];
    apiData = true;
    setState(() {});
  }

  setAllData() {
    firstNameController.text = trainingDatum.fullName ?? '';
    tehsilNameController.text = trainingDatum.districtId ?? '';
    emailController.text = trainingDatum.email ?? '';
    mobileController.text = trainingDatum.phoneNo ?? '';
    cityStatusController.text = trainingDatum.stateId ?? '';
    zipPostalPinCodeController.text = trainingDatum.pinCode ?? '';
    udiseCodeController.text = trainingDatum.udiseCode ?? '';
    otherParticipantProfileController.text =
        trainingDatum.otherDesignation ?? '';
    establishmentController.text = trainingDatum.organisationName ?? '';
    otherStateController.text = trainingDatum.otherState ?? '';
    otherDistrictController.text = trainingDatum.otherDistrict ?? '';
    otherBlockController.text = trainingDatum.otherBlock ?? '';

    String dobdate = trainingDatum.dob ?? '';
    String outputDateString1 = '';
    try {
      stateVal = trainingDatum.stateId ?? '';
      distictValue = trainingDatum.districtId ?? '';
      blockValue = trainingDatum.blockId ?? '';
    } catch (e) {
      stateVal = '';
    }
    if (trainingDatum.teacherGrade != null &&
        trainingDatum.teacherGrade!.isNotEmpty) {
      List<String> gradeIdList = trainingDatum.teacherGrade!.split(',');
      try {
        for (var e in gradeIdList) {
          var grade = teacherGradeList
              .firstWhere((element) => element.id == int.tryParse(e));
          gradeSelection[grade.teacherGrade] = true;
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    if (dobdate.isNotEmpty) {
      DateTime inputDate = DateFormat("yyyy-MM-dd").parse(dobdate);
      outputDateString1 = DateFormat("dd/MM/yyyy").format(inputDate);
    }
    dobController.text = outputDateString1;

    String outputDateString = 'N/a';
    if (trainingDatum.monthYearAttendSession != null &&
        trainingDatum.monthYearAttendSession!.isNotEmpty &&
        trainingDatum.monthYearAttendSession != 'N/a') {
      DateTime inputDate =
          DateFormat("yyyy-MM-dd").parse(trainingDatum.monthYearAttendSession!);
      outputDateString = DateFormat("dd/MM/yyyy").format(inputDate);
    }
    monthAndYearController.text = outputDateString;
    try {
      genderController.text = genderModelList
          .where((element) => element.value == trainingDatum.gender)
          .first
          .text;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    try {
      selectedMinistryId = designationModelList
          .where(
              (element) => element.id.toString() == trainingDatum.designation)
          .first
          .ministryId!;
      if (languages.indexOf(selectedLanguagevalue) == 1) {
        participantProfileController.text = designationModelList
            .where(
                (element) => element.id.toString() == trainingDatum.designation)
            .first
            .hindiDesignation!;
      } else if (languages.indexOf(selectedLanguagevalue) == 2) {
        participantProfileController.text = designationModelList
            .where(
                (element) => element.id.toString() == trainingDatum.designation)
            .first
            .marathiDesignation!;
      } else {
        participantProfileController.text = designationModelList
            .where(
                (element) => element.id.toString() == trainingDatum.designation)
            .first
            .englishDesignation!;
      }
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }

    stateVal = trainingDatum.stateId ?? '';
    distictValue = trainingDatum.districtId ?? '';
    blockValue = trainingDatum.blockId ?? '';
    if (stateVal == '0') {
      stateVal = '';
      distictValue = '';
    }
    attendedBeforeController.text =
        trainingDatum.attendedArpanSessionChildSexualAbuse ?? '';

    if (attendedBeforeController.text == 'Yes') {
      hasAttendedBefore = true;
      // attendedBeforeController.text = LabelText.getText('yes');
      // monthAndYearController.text = '';
      // setState(() {});
    } else {
      hasAttendedBefore = false;
      //setState(() {});
      monthAndYearController.text = 'N/a';
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: ColorConstants.defaultBackgroundColor,
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
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  isBackPressed = true;
                  Navigator.pop(context, null);
                },
              ),
              Text(LabelText.registration,
                  style: Styles.red164.copyWith(
                    color: ColorConstants.defaultMaroon,
                  ))
            ],
          ),
          actions: [
            Center(
              child: Text(
                selectedLanguagevalue,
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.language,
                color: Colors.green,
              ),
              offset: const Offset(0, 60),
              onSelected: (selectedLanguage) async {
                selectedLanguagevalue = selectedLanguage;
                languageId = languages.indexOf(selectedLanguagevalue) + 1;
                await customSecureStorage.writeSecureValue(
                    key: SecureStorageKeys.langId,
                    value: (languages.indexOf(selectedLanguagevalue) + 1)
                        .toString());
                LabelText.getLang(languages.indexOf(selectedLanguagevalue) + 1);
                await setAllListData();
                setState(() {});
              },
              itemBuilder: (BuildContext context) {
                return languages.map((String language) {
                  return PopupMenuItem<String>(
                    value: language,
                    child: Text(language.trim()),
                  );
                }).toList();
              },
            ),
            const SizedBox(
              width: 10,
            )
          ]),
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: Center(
            child: !apiData
                ? const CircularProgressIndicator()
                : SizedBox(
                    height: 640.h,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            RegistrationTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z0-9@.,()_' ]"))
                              ],
                              subTitle: 'Email Address',
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return LabelText.getText('emailempty');
                                // }

                                // if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                                //   return LabelText.getText('emailvalid');
                                // }

                                return null;
                              },
                              textEditingController: emailController,
                              title: LabelText.getText('emailText'),
                              textInputType: TextInputType.emailAddress,
                              onChanged: (value) {
                                if (kDebugMode) {
                                  print(value);
                                }
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            RegistrationTextField(
                              subTitle: 'Full Name',
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LabelText.getText('fullNameEmpty');
                                  // } else if (!RegExp(r'[a-z ,.-]+$')
                                  //     .hasMatch(value!)) {
                                  //   return 'Invalid Name';
                                }
                                return null;
                              },
                              textEditingController: firstNameController,
                              title: LabelText.getText('firstname'),
                              onChanged: (value) {
                                if (kDebugMode) {
                                  print(value);
                                }
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            if (genderlList.isNotEmpty) ...[
                              RegistrationDropDown(
                                subTitle: 'Gender',
                                validator: (value) {
                                  var validate =
                                      Validate().validateGender(value);
                                  return validate;
                                },
                                initialValue: LabelText.getText('pleaseSelect'),
                                items: genderlList,
                                textEditingController: genderController,
                                title: LabelText.getText('gender'),
                                onChanged: (value) {
                                  if (value == null) {
                                    genderindex = 0;
                                  } else {
                                    genderindex = int.parse(value);
                                  }
                                  try {
                                    if (genderModelList.isNotEmpty &&
                                        value !=
                                            LabelText.getText('pleaseSelect')) {
                                      // genderController.text = value.toString();
                                      setState(() {});
                                    }
                                  } catch (error, stackTrace) {
                                    logError(error, stackTrace);
                                  }
                                },
                              ),
                            ],

                            SizedBox(
                              height: 12.h,
                            ),
                            AutoSizeText(
                              LabelText.getText('dob'),
                              wrapWords: false,
                              style: Styles.black124,
                              maxLines: 10,
                            ),
                            TextField(
                              // key: Key(LabelText.monthAndYearAttending),
                              focusNode: AlwaysDisabledFocusNode(),
                              controller: dobController,
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                dobController.text =
                                    await _selectdobDate(context);
                                //update(1);
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff707070)),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff707070)),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                suffixIcon: Icon(
                                  Icons.calendar_month,
                                  color: ColorConstants.defaultRedColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            AbsorbPointer(
                              absorbing: false,
                              child: RegistrationTextField(
                                subTitle: LabelText.getText('mobileNo'),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                validator: (value) {
                                  var validate =
                                      Validate().validateMobileNumber(value!);
                                  return validate;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'(^[0-9]{1,10})')),
                                ],
                                textEditingController: mobileController,
                                title: LabelText.getText('mobileNo'),
                                textInputType: TextInputType.number,
                                onChanged: (value) {
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            if (designationList.isNotEmpty) ...[
                              RegistrationDropDown(
                                subTitle:
                                    LabelText.getText('participantProfile'),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value ==
                                          LabelText.getText(
                                              'selectDesignation')) {
                                    return LabelText.getText(
                                        'designationempty');
                                  }
                                  return null;
                                },
                                initialValue:
                                    LabelText.getText('selectDesignation'),
                                items: designationList,
                                textEditingController:
                                    participantProfileController,
                                title: LabelText.getText('participantProfile'),
                                onChanged: (value) {
                                  try {
                                    if (value != null &&
                                        value !=
                                            LabelText.getText(
                                                'selectDesignation')) {
                                      // designationindex = int.parse(value) - 1;
                                      // designationindex = id + 1;

                                      if (languages
                                              .indexOf(selectedLanguagevalue) ==
                                          1) {
                                        selectedMinistryId =
                                            designationModelList
                                                .firstWhere((element) =>
                                                    element.hindiDesignation ==
                                                    participantProfileController
                                                        .text)
                                                .ministryId!;
                                      } else if (languages
                                              .indexOf(selectedLanguagevalue) ==
                                          2) {
                                        selectedMinistryId =
                                            designationModelList
                                                .firstWhere((element) =>
                                                    element
                                                        .marathiDesignation ==
                                                    participantProfileController
                                                        .text)
                                                .ministryId!;
                                      } else {
                                        selectedMinistryId =
                                            designationModelList
                                                .firstWhere((element) =>
                                                    element
                                                        .englishDesignation ==
                                                    participantProfileController
                                                        .text)
                                                .ministryId!;
                                      }
                                      setState(() {});
                                      // designationindex = designationModelList
                                      //         .firstWhere((element) =>
                                      //             element.englishDesignation ==
                                      //             value)
                                      //         .id ??
                                      //     0;
                                    }
                                  } catch (error, stackTrace) {
                                    logError(error, stackTrace);
                                  }
                                },
                              ),
                              if (participantProfileController.text ==
                                  LabelText.getText('Other')) ...[
                                const SizedBox(height: 12),
                                RegistrationTextField(
                                  subTitle: LabelText.getText(
                                      'otherParticipantProfile'),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LabelText.getText(
                                          'designationempty');
                                    }
                                    return null;
                                  },
                                  textEditingController:
                                      otherParticipantProfileController,
                                  title: LabelText.getText(
                                      'otherParticipantProfile'),
                                  onChanged: (value) {
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                  },
                                ),
                              ],
                              if (teacherGrades.isNotEmpty &&
                                  teacherDesignationList.contains(
                                      participantProfileController.text)) ...[
                                SizedBox(
                                  height: 12.h,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 2.h),
                                  // color: Colors.red,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xff707070),
                                        width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4d000000),
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 3.0,
                                      ),
                                    ], //border of dropdown button
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DropdownButton<String>(
                                        isExpanded: true,
                                        underline: Container(),
                                        hint: Text(
                                            LabelText.getText('selectGrade')),
                                        items:
                                            teacherGrades.map((String grade) {
                                          return DropdownMenuItem<String>(
                                            alignment: Alignment.topRight,
                                            value: grade,
                                            onTap: () => setState(() {}),
                                            child: grade == 'OK'
                                                ? InkWell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(grade,
                                                          style: Styles.black164
                                                              .copyWith(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .blue)),
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    },
                                                  )
                                                : StatefulBuilder(
                                                    builder: (BuildContext
                                                            context,
                                                        StateSetter setState) {
                                                      return CheckboxListTile(
                                                        title: Text(grade),
                                                        value: gradeSelection[
                                                            grade],
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            gradeSelection[
                                                                    grade] =
                                                                value ?? false;
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                          );
                                        }).toList(),
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),
                                      if (gradeSelection
                                          .containsValue(true)) ...[
                                        Wrap(
                                          spacing: 6.0,
                                          runSpacing: 6.0,
                                          children: gradeSelection.entries
                                              .where((entry) => entry.value)
                                              .map((entry) => Chip(
                                                    label: Text(entry.key),
                                                    onDeleted: () {
                                                      setState(() {
                                                        gradeSelection[
                                                            entry.key] = false;
                                                      });
                                                    },
                                                  ))
                                              .toList(),
                                        ),
                                      ]
                                    ],
                                  ),
                                )
                              ],
                              if (targetMinistryIds.contains(14) ||
                                  selectedMinistryId == '14') ...[
                                const SizedBox(height: 12),
                                RegistrationTextField(
                                  subTitle:
                                      LabelText.getText('schoolUDISEcode'),
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return LabelText.getText('pleaseenter');
                                    }
                                    return null;
                                  },
                                  textEditingController: udiseCodeController,
                                  title: LabelText.getText('schoolUDISEcode'),
                                  onChanged: (value) {
                                    if (kDebugMode) {
                                      print(value);
                                    }
                                  },
                                ),
                              ],
                            ],
                            SizedBox(
                              height: 12.h,
                            ),
                            RegistrationTextField(
                              subTitle: LabelText.getText('nameOfOrganization'),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LabelText.getText(
                                      'nameOfOrganizationempty');
                                  // } else if (!RegExp(r'[a-z ,.-]+$')
                                  //     .hasMatch(value!)) {
                                  //   return 'Invalid Name';
                                }
                                return null;
                              },
                              textEditingController: establishmentController,
                              title: LabelText.getText('nameOfOrganization'),
                              onChanged: (value) {
                                // print(value);
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            AutoSizeText(
                              LabelText.getText('state'),
                              wrapWords: false,
                              style: Styles.grey12500,
                              maxLines: 10,
                            ),
                            if (states.isNotEmpty) ...[
                              Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xff707070), width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4d000000),
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 3.0,
                                    ),
                                  ], //border of dropdown button
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,

                                      isExpanded: true,
                                      key: const Key(
                                        'state',
                                      ),
                                      hint: Text(
                                        LabelText.getText('selectHere'),
                                        style: Styles.grey12500,
                                      ),
                                      value: stateVal.isNotEmpty
                                          ? _returnState()
                                          : null,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: Styles.grey12500,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      // ignore: prefer_null_aware_operators
                                      items: states
                                          .map((e) => DropdownMenuItem(
                                              value: e.stateName,
                                              child: Text(
                                                e.stateName!,
                                                style: Styles.grey12500,
                                              )))
                                          .toList(),
                                      onChanged: (val) async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        var idval = val!;
                                        stateVal = states
                                            .where((element) =>
                                                element.stateName! == idval)
                                            .first
                                            .stateId!
                                            .toString();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (stateVal == '9999999') ...[
                              const SizedBox(height: 12),
                              RegistrationTextField(
                                subTitle: LabelText.getText('stateOther'),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LabelText.getText('pleaseenter');
                                  }
                                  return null;
                                },
                                textEditingController: otherStateController,
                                title: LabelText.getText('stateOther'),
                                onChanged: (value) {
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                },
                              ),
                            ],
                            const SizedBox(height: 12),
                            AutoSizeText(
                              LabelText.getText('district'),
                              wrapWords: false,
                              style: Styles.grey12500,
                              maxLines: 10,
                            ),
                            if (districts.isNotEmpty) ...[
                              Container(
                                height: 45.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xff707070), width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4d000000),
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 3.0,
                                    ),
                                  ], //border of dropdown button
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      key: const Key(
                                        'district',
                                      ),
                                      hint: Text(
                                        LabelText.getText('selectHere'),
                                        style: Styles.grey12500,
                                      ),
                                      value: distictValue.isNotEmpty
                                          ? districts
                                              .firstWhere(
                                                (element) =>
                                                    (element.stateId
                                                                .toString() ==
                                                            stateVal ||
                                                        element.stateId ==
                                                            9999999) &&
                                                    element.districtId
                                                            .toString() ==
                                                        distictValue,
                                                orElse: () =>
                                                    TblDistrictModel(), // Return null if no element matches the condition.
                                              )
                                              .districtName
                                          : null,
                                      icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: Styles.grey12500,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      // ignore: prefer_null_aware_operators
                                      items: districts
                                          .where((element) =>
                                              element.stateId.toString() ==
                                                  stateVal ||
                                              element.stateId == 9999999)
                                          .toList()
                                          .map((e) => DropdownMenuItem(
                                              value: e.districtName,
                                              child: Text(
                                                e.districtName!,
                                                style: Styles.grey12500,
                                              )))
                                          .toList(),
                                      onChanged: (val) async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        var idval = val!;
                                        distictValue = districts
                                            .where((element) =>
                                                element.districtName! ==
                                                    idval &&
                                                (element.stateId.toString() ==
                                                        stateVal ||
                                                    element.stateId == 9999999))
                                            .first
                                            .districtId!
                                            .toString();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            // SizedBox(
                            //   height: 5.h,
                            // ),
                            if (distictValue == '9999999') ...[
                              const SizedBox(height: 12),
                              RegistrationTextField(
                                subTitle: LabelText.getText('districtOther'),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LabelText.getText('pleaseenter');
                                  }
                                  return null;
                                },
                                textEditingController: otherDistrictController,
                                title: LabelText.getText('districtOther'),
                                onChanged: (value) {
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                },
                              ),
                            ],
                            SizedBox(
                              height: 12.h,
                            ),
                            if (blockList.isNotEmpty) ...[
                              AutoSizeText(
                                LabelText.getText('block'),
                                wrapWords: false,
                                style: Styles.grey12500,
                                maxLines: 10,
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xff707070), width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4d000000),
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 3.0,
                                    ),
                                  ], //border of dropdown button
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: IgnorePointer(
                                    ignoring: false,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusColor: Colors.transparent,
                                        isExpanded: true,
                                        key: const Key(
                                          'block',
                                        ),
                                        hint: Text(
                                          LabelText.getText('selectHere'),
                                          style: Styles.grey12500,
                                        ),
                                        value: blockList.isNotEmpty
                                            ? blockList
                                                .firstWhere(
                                                  (element) =>
                                                      (element.stateId
                                                                  .toString() ==
                                                              stateVal ||
                                                          element.stateId ==
                                                              9999999) &&
                                                      (element.districtId
                                                                  .toString() ==
                                                              distictValue ||
                                                          element.districtId ==
                                                              '9999999') &&
                                                      element.id.toString() ==
                                                          blockValue,
                                                  orElse: () =>
                                                      BlockDatum(), // Return null if no element matches the condition.
                                                )
                                                .blockName
                                            : null,
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: Styles.grey12500,
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        // ignore: prefer_null_aware_operators
                                        items: blockList.isNotEmpty
                                            ? blockList
                                                .where((element) =>
                                                    (element.stateId
                                                                .toString() ==
                                                            stateVal ||
                                                        element.stateId ==
                                                            9999999) &&
                                                    (element.districtId
                                                                .toString() ==
                                                            distictValue ||
                                                        element.districtId ==
                                                            '9999999'))
                                                .toList()
                                                .map((e) => DropdownMenuItem(
                                                    value: e.blockName,
                                                    child: Text(
                                                      e.blockName!,
                                                      style: Styles.grey12500,
                                                    )))
                                                .toList()
                                            : null,
                                        onChanged: (val) async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          // var idval = val;
                                          blockValue = blockList
                                              .where((element) =>
                                                  element.blockName! == val &&
                                                  (element.stateId.toString() ==
                                                          stateVal ||
                                                      element.stateId ==
                                                          9999999) &&
                                                  (element.districtId
                                                              .toString() ==
                                                          distictValue ||
                                                      element.districtId ==
                                                          '9999999'))
                                              .first
                                              .id!
                                              .toString();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            // SizedBox(
                            //   height: 5.h,
                            // ),
                            if (blockValue == '9999999') ...[
                              const SizedBox(height: 12),
                              RegistrationTextField(
                                subTitle: LabelText.getText('blockOther'),
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return LabelText.getText('pleaseenter');
                                  }
                                  return null;
                                },
                                textEditingController: otherBlockController,
                                title: LabelText.getText('blockOther'),
                                onChanged: (value) {
                                  if (kDebugMode) {
                                    print(value);
                                  }
                                },
                              ),
                            ],
                            SizedBox(
                              height: 12.h,
                            ),
                            RegistrationTextField(
                              subTitle: LabelText.getText('zipPostalPinCode'),
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LabelText.getText(
                                      'zipPostalPinCodeempty');
                                } else if (value.length > 6 ||
                                    value.length < 6) {
                                  return 'Invalid Pincode';
                                }
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'(^[0-9]{1,6})')),
                              ],
                              textEditingController: zipPostalPinCodeController,
                              title: LabelText.getText('zipPostalPinCode'),
                              textInputType: TextInputType.number,
                              onChanged: (value) {
                                if (kDebugMode) {
                                  print(value);
                                }
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            if (attendanceBeforeList.isNotEmpty) ...[
                              RegistrationDropDown(
                                subTitle: LabelText.getText('attendedBefore'),
                                validator: (value) {
                                  var validate =
                                      Validate().validateAttendedBedore(value);
                                  return validate;
                                },
                                initialValue: LabelText.getText('pleaseSelect'),
                                textEditingController: attendedBeforeController,
                                items: attendanceBeforeList,
                                title: LabelText.getText('attendedBefore'),
                                onChanged: (value) {
                                  if (value == null) {
                                    attendanceBeforeindex = 0;
                                  } else {
                                    attendanceBeforeindex = int.parse(value);
                                  }
                                  if (value.toString() == '1') {
                                    hasAttendedBefore = true;
                                    // attendedBeforeController.text = LabelText.getText('yes');
                                    monthAndYearController.text = '';
                                    setState(() {});
                                  } else if (value.toString() == '2') {
                                    hasAttendedBefore = false;
                                    // attendedBeforeController.text =    LabelText.getText('no');
                                    monthAndYearController.text = 'N/a';
                                    setState(() {});
                                  } else {
                                    hasAttendedBefore = false;
                                    setState(() {});
                                    monthAndYearController.text = 'N/a';
                                  }
                                },
                              ),
                            ],

                            if (hasAttendedBefore) ...[
                              SizedBox(
                                height: 12.h,
                              ),
                              AutoSizeText(
                                LabelText.getText('monthAndYearAttending'),
                                wrapWords: false,
                                style: Styles.black124,
                                maxLines: 10,
                              ),
                              TextField(
                                key: Key(LabelText.monthAndYearAttending),
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: monthAndYearController,
                                onTap: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  _selectDate(context);
                                  //update(1);
                                },
                                decoration: InputDecoration(
                                  hintText: 'Date Attended',
                                  hintStyle: Styles.grey164,
                                  fillColor: Colors.white,
                                  filled: true,
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xff707070)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xff707070)),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: ColorConstants.defaultRedColor,
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 20.h,
                            ),
                            CurvedButton(
                                buttonTitle: 'Submit',
                                style: Styles.white146,
                                buttonColor: ColorConstants.defaultMaroon,
                                height: 40.h,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (stateVal.isEmpty || stateVal == '') {
                                      Toast.show("Please select State",
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                      return false;
                                    }
                                    if (distictValue == '' ||
                                        distictValue.isEmpty) {
                                      Toast.show("Please select District",
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                      return false;
                                    }
                                    if (blockValue == '' ||
                                        blockValue.isEmpty) {
                                      Toast.show("Please select Block",
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                      return false;
                                    }
                                    if (dobController.text.isEmpty) {
                                      Toast.show("Please select Date of birth",
                                          duration: 3,
                                          gravity: Toast.bottom,
                                          backgroundColor: Colors.red);
                                      return false;
                                    }
                                    if (teacherDesignationList.isNotEmpty &&
                                        teacherDesignationList.contains(
                                            participantProfileController
                                                .text)) {
                                      if (!gradeSelection.containsValue(true)) {
                                        Toast.show("Please select Grade",
                                            duration: 3,
                                            gravity: Toast.bottom,
                                            backgroundColor: Colors.red);
                                        return false;
                                      }
                                    }
                                    if (attendedBeforeController.text.isEmpty) {
                                      monthAndYearController.text = 'N/a';
                                    }
                                    if (monthAndYearController.text.isEmpty) {
                                      monthAndYearController.text = 'N/a';
                                    }
                                    try {
                                      // var orgName =
                                      //     establishmentController.text;

                                      showCustomDialog(
                                        context,
                                        widget: ShowAlertDialogBox(
                                            secondFunc: () async {
                                              FocusScope.of(context).unfocus();
                                              isBackPressed = true;
                                              Navigator.pop(
                                                  context, trainingDatum);
                                            },
                                            func: () async {
                                              String gendervalue =
                                                  genderModelList
                                                      .where((element) =>
                                                          element.text ==
                                                          genderController.text)
                                                      .first
                                                      .value;
                                              String designationvalue = "";

                                              if (languages.indexOf(
                                                      selectedLanguagevalue) ==
                                                  1) {
                                                designationvalue = designationModelList
                                                    .where((element) =>
                                                        element
                                                            .hindiDesignation ==
                                                        participantProfileController
                                                            .text)
                                                    .first
                                                    .id
                                                    .toString();
                                              } else if (languages.indexOf(
                                                      selectedLanguagevalue) ==
                                                  2) {
                                                designationvalue = designationModelList
                                                    .where((element) =>
                                                        element
                                                            .marathiDesignation ==
                                                        participantProfileController
                                                            .text)
                                                    .first
                                                    .id
                                                    .toString();
                                              } else {
                                                designationvalue = designationModelList
                                                    .where((element) =>
                                                        element
                                                            .englishDesignation ==
                                                        participantProfileController
                                                            .text)
                                                    .first
                                                    .id
                                                    .toString();
                                              }

                                              String attendedBeforevalue = '';

                                              if (attendedBeforeController
                                                      .text ==
                                                  LabelText.getText('yes')) {
                                                attendedBeforevalue = 'Yes';
                                              } else if (attendedBeforeController
                                                      .text ==
                                                  LabelText.getText('no')) {
                                                attendedBeforevalue = 'No';
                                              }

                                              //  var participantGuid = widget.particepentDetail==null? Uuid().v1():widget.particepentDetail!.particitantGuid!;
                                              var orgName =
                                                  establishmentController.text;
                                              String outputDateString =
                                                  monthAndYearController.text;
                                              if (monthAndYearController
                                                      .text.isNotEmpty &&
                                                  monthAndYearController.text !=
                                                      'N/a') {
                                                DateTime inputDate = DateFormat(
                                                        "dd/MM/yyyy")
                                                    .parse(
                                                        monthAndYearController
                                                            .text);
                                                outputDateString =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(inputDate);
                                              }
                                              String dobdateString = '';
                                              if (dobController
                                                  .text.isNotEmpty) {
                                                DateTime inputDate = DateFormat(
                                                        "dd/MM/yyyy")
                                                    .parse(dobController.text);
                                                dobdateString =
                                                    DateFormat("yyyy-MM-dd")
                                                        .format(inputDate);
                                              }

                                              trainingDatum =
                                                  TrainingScheduleParticipantModel(
                                                      stateId: stateVal,
                                                      districtId: distictValue,
                                                      fullName: firstNameController
                                                          .text,
                                                      blockId: blockValue,
                                                      email: emailController
                                                          .text,
                                                      phoneNo: mobileController
                                                          .text,
                                                      attendedArpanSessionChildSexualAbuse:
                                                          attendedBeforevalue,
                                                      dob: dobdateString,
                                                      scheduleGuid: widget
                                                          .trainingRegistration!
                                                          .scheduleGuid!,
                                                      gender: gendervalue,
                                                      udiseCode:
                                                          udiseCodeController
                                                              .text,
                                                      pinCode:
                                                          zipPostalPinCodeController
                                                              .text,
                                                      organisationName: orgName,
                                                      // organisationCode: orgCode,
                                                      designation:
                                                          designationvalue,
                                                      monthYearAttendSession:
                                                          outputDateString,
                                                      createdOn: DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(
                                                              DateTime.now()),
                                                      createdBy:
                                                          userInfo['email']
                                                              .toString(),
                                                      isEdited: 1,
                                                      registrationGuid: widget
                                                          .trainingRegistration!
                                                          .registrationGuid,
                                                      latitude: lat,
                                                      longitude: long);
                                              if (stateVal == '9999999') {
                                                trainingDatum.otherState =
                                                    otherStateController.text;
                                              }
                                              if (distictValue == '9999999') {
                                                trainingDatum.otherDistrict =
                                                    otherDistrictController
                                                        .text;
                                              }
                                              if (blockValue == '9999999') {
                                                trainingDatum.otherBlock =
                                                    otherBlockController.text;
                                              }
                                              if (designationvalue ==
                                                  '9999999') {
                                                trainingDatum.otherDesignation =
                                                    otherParticipantProfileController
                                                        .text;
                                              }
                                              if (teacherDesignationList.contains(
                                                  participantProfileController
                                                      .text)) {
                                                List<String> selectedGrades =
                                                    [];
                                                List<String> selectedGradeIds =
                                                    [];
                                                gradeSelection
                                                    .forEach((key, value) {
                                                  if (value) {
                                                    selectedGrades.add(key);
                                                  }
                                                });
                                                for (var element
                                                    in selectedGrades) {
                                                  var id = teacherGradeList
                                                      .firstWhere((element1) =>
                                                          element1
                                                              .teacherGrade ==
                                                          element)
                                                      .id;
                                                  selectedGradeIds
                                                      .add(id.toString());
                                                }
                                                trainingDatum.teacherGrade =
                                                    selectedGradeIds.join(',');
                                              }
                                              trainingDatum.languageId =
                                                  languageId.toString();
                                              //json.encode(data.toJson()
                                              if (trainingDatum
                                                      .registrationGuid !=
                                                  '00000000-0000-0000-0000-000000000000') {
                                                await dbhelper
                                                    .insertParticipent(
                                                        trainingDatum);

                                                List<TrainingScheduleParticipantModel>
                                                    regList = [];
                                                regList.add(trainingDatum);
                                                String jsonBatch =
                                                    jsonEncode(regList);
                                                var obj = jsonDecode(jsonBatch);

                                                var response =
                                                    await TrainingParticipantRegistrationAPI()
                                                        .postTrainingParticipantRegistration(
                                                            postBody: obj);
                                                if (response.isSuccess) {
                                                  trainingDatum.isEdited = 0;
                                                  await dbhelper
                                                      .insertParticipent(
                                                          trainingDatum);
                                                  return LabelText.success;
                                                } else {
                                                  return LabelText.uploadFailed;
                                                }
                                              }
                                            },
                                            title: LabelText.pleaseWait),
                                      );

                                      // ref.refresh(attendenceMarksheetFutureProvider);
                                      // Navigator.pop(context);
                                    } catch (error, stackTrace) {
                                      logError(error, stackTrace);
                                    }
                                  }
                                }),
                            SizedBox(height: 10.h)
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  _returnState() {
    try {
      return states
          .where((element) => element.stateId.toString() == stateVal)
          .first
          .stateName;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    return null;
  }

  void _selectDate(BuildContext context) async {
    var newSelectedDate = await showDatePicker(
        locale: const Locale(
          'en',
          '',
        ),
        context: context,
        firstDate: DateTime.parse("1930-01-01"),
        initialDate: DateTime.now(),
        lastDate: DateTime.now());

    if (newSelectedDate != null) {
      // _selectedDate = newSelectedDate;
      // trainingDate = newSelectedDate.toString();

      monthAndYearController
        ..text = DateFormat('dd/MM/yyyy').format(newSelectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: monthAndYearController.text.length,
            affinity: TextAffinity.upstream));
      // update(1);
    }
  }

  Future<String> _selectdobDate(BuildContext context) async {
    var newSelectedDate = await showDatePicker(
        locale: const Locale(
          'en',
          '',
        ),
        context: context,
        firstDate: DateTime.parse("1930-01-01"),
        initialDate: DateTime.now(),
        lastDate: DateTime.now());

    if (newSelectedDate != null) {
      // monthAndYearController
      //   ..text = DateFormat('dd/MM/yyyy').format(newSelectedDate)
      //   ..selection = TextSelection.fromPosition(TextPosition(
      //       offset: monthAndYearController.text.length,
      //       affinity: TextAffinity.upstream));
      return DateFormat('dd/MM/yyyy').format(newSelectedDate);
    } else {
      return "";
    }
  }
}
