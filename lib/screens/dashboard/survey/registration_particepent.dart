// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:arpan/table_model/qr_code_model.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import '../../../api/training_participant_registration_api.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../database/dataProvider.dart';
import '../../../models/TrainerEstablishmentList_model.dart';
import '../../../models/training_schedule_participant_model.dart';
import '../../../table_model/tbl_block_model.dart';
import '../../../table_model/tbl_designation_model.dart';
import '../../../table_model/tbl_district_model.dart';
import '../../../table_model/tbl_master_model.dart';
import '../../../table_model/tbl_participant_scan_details.dart';
import '../../../table_model/tbl_state_model.dart';
import '../../../table_model/tbl_teacher_grade_model.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import '../../../utils/validate.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../../widgets/registration_drop_down.dart';
import '../../../widgets/registration_text_field.dart';
import '../../training/training_batch_session_creation.dart';

class RegistraionParticipantModule extends StatefulWidget {
  const RegistraionParticipantModule({Key? key}) : super(key: key);

  @override
  State<RegistraionParticipantModule> createState() =>
      _RegistraionParticipantModuleState();
}

class _RegistraionParticipantModuleState
    extends State<RegistraionParticipantModule> {
  DataProvider dbhelper = DataProvider();
  QrCodeModel? qrCodeData;
  TrainingScheduleParticipantModel? trainingParticipantDatum;
  List<TrainingScheduleParticipantModel> trainingParticipantList = [];

  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController participantProfileController = TextEditingController();
  TextEditingController establishmentController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController attendedBeforeController = TextEditingController();
  TextEditingController monthAndYearController = TextEditingController();
  TextEditingController otherStateController = TextEditingController();
  TextEditingController otherDistrictController = TextEditingController();
  TextEditingController otherBlockController = TextEditingController();
  TextEditingController udiseCodeController = TextEditingController();
  TextEditingController otherParticipantProfileController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var userInfo;
  DateTime? dob;
  bool hasAttendedBefore = false;
  String? mobileNo;
  String? selectedMinistryId;
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  List<TblMasterModel> genderModelList = [];
  List<TblDesignationModel> designationModelList = [];
  List<TrainerEstablishmentDatum> trainerEstablishmentall = [];

  List<TblStateModel> states = [];
  List<TblDistrictModel> districts = [];
  List<BlockDatum> blockList = [];
  List<TblTeacherGradeModel> teacherGradeList = [];

  List<String> establishmentStringList = [];
  List<String> genderlList = [];
  List<String> designationList = [];
  List<String> individualStringList = [];
  List<String> attendanceBeforeList = [];
  List<String> teacherGrades = [];
  List<String> teacherDesignationList = [];
  List<int> targetMinistryIds = [];
  Map<String, bool> gradeSelection = {};
  bool apiData = false;
  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];
  bool isBackPressed = false;
  int genderindex = 0;
  int ngoindex = 0;
  int designationindex = 0;
  int attendanceBeforeindex = 0;
  String stateVal = '';
  String distictValue = '';
  String blockValue = '';
  int languageId = 1;
  bool locationDisabled = true;
  String long = "", lat = "";
  bool emailMandatory = false;
  dynamic data;

  @override
  void initState() {
    super.initState();
    // checkGps();
    LabelText.getLang(1);
  }

  Widget impText(String text, {TextStyle? textStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
            text: TextSpan(
                text: "*",
                style: const TextStyle(color: Colors.red),
                children: <InlineSpan>[
              TextSpan(
                text: text,
                style: textStyle ?? Styles.black124,
              )
            ])),
      ],
    );
  }

  var isEditedPage = false;
  ParticipantScanDetails participantScanDetails = ParticipantScanDetails();
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isBackPressed) {
      mobileNo = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.phone);
      userInfo = await UserInfo().getUserCredentials();
      data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        qrCodeData = data;
      } else {
        participantScanDetails =
            await DataProvider().getParticipantScanDetails(mobileNo!);
        qrCodeData = QrCodeModel();
        qrCodeData!.individualPartnerLists =
            participantScanDetails.individualPartnerLists == null
                ? []
                : List<IndividualPartnerList>.from(json
                    .decode(participantScanDetails.individualPartnerLists!)!
                    .map((x) => IndividualPartnerList.fromJson(x)));

        qrCodeData!.typeOfGroup = participantScanDetails.typeOfGroup;
        qrCodeData!.scheduleGuid = participantScanDetails.scheduleGuid;
        qrCodeData!.registrationGuid = participantScanDetails.registrationGuid;
        qrCodeData!.surveyId = participantScanDetails.surveyId;
        qrCodeData!.trainerName = participantScanDetails.trainerName;
        qrCodeData!.firstDate = participantScanDetails.firstDate;
        qrCodeData!.lastDate = participantScanDetails.lastDate;
        qrCodeData!.topicsCoveredName =
            participantScanDetails.topicsCoveredName;
        qrCodeData!.trainingName = participantScanDetails.trainingName;
        qrCodeData!.blockName = participantScanDetails.blockName;
        qrCodeData!.stateId = participantScanDetails.stateId;
        qrCodeData!.districtId = participantScanDetails.districtId;
        qrCodeData!.blockId = participantScanDetails.blockId;
        qrCodeData!.ministryId = participantScanDetails.ministryId;
      }
      // if (qrCodeData!.typeOfGroup == null) {
      //   qrCodeData = null;
      // }

      if (mobileNo != null) {
        mobileController.text = mobileNo ?? '';
      }
      var langID = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.langId);
      if (langID != null) {
        languageId = int.parse(langID);
        LabelText.getLang(languageId);
        selectedLanguagevalue = languages[languageId - 1];
      }
      var countryCode = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.countryCode);
      if (countryCode != '+91') {
        emailMandatory = true;
      }

      await setAllListData();

      if (mobileNo != null && mobileNo.toString().isNotEmpty) {
        var trainingListData = await DataProvider()
            .getTrainingParticipantWithMobile(mobileNo: mobileNo);
        if (trainingListData.isNotEmpty) {
          trainingParticipantDatum = trainingListData[0];

          setAllData();
        }
      }

      try {
        var sessionData = await DataProvider()
            .getTrainingSessionAttendance(qrCodeData!.registrationGuid!);
        if (sessionData != null && sessionData.isNotEmpty) {
          var session = sessionData.last;
          lat = session.latitude ?? '';
          long = session.longitude ?? '';
        }
      } catch (e) {}

      setState(() {
        isBackPressed = true;
      });
    }
  }

  bool clearEsta = false;
  setAllListData() async {
    var tempStates = await DataProvider().getAllState();
    var tempDistricts = await DataProvider().getAllDistrict();
    var tempBlockList = await DataProvider().getAllBlock();
    teacherGradeList = await DataProvider().getTeacherGradeList();
    var trainingParticipantDistrictId = qrCodeData!.districtId ?? '';
    var trainingParticipantStateId = qrCodeData!.stateId ?? '';
    var trainingParticipantBlockId = qrCodeData!.blockId ?? '';
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
    var trainingParticipantMinistryId = qrCodeData!.ministryId ?? '';
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

    // designationList.add(LabelText.getText('Other'));
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
    if (mounted) {
      setState(() {});
    }
  }

  setAllData() {
    // if (qrCodeData != null) {}
    if (trainingParticipantDatum != null) {
      isEditedPage = true;
      fullNameController.text = trainingParticipantDatum!.fullName ?? '';
      emailController.text = trainingParticipantDatum!.email ?? '';
      mobileController.text = trainingParticipantDatum!.phoneNo ?? '';
      pinCodeController.text = trainingParticipantDatum!.pinCode ?? '';
      udiseCodeController.text = trainingParticipantDatum!.udiseCode ?? '';
      otherParticipantProfileController.text =
          trainingParticipantDatum!.otherDesignation ?? '';
      establishmentController.text =
          trainingParticipantDatum!.organisationName ?? '';
      otherStateController.text = trainingParticipantDatum!.otherState ?? '';
      otherDistrictController.text =
          trainingParticipantDatum!.otherDistrict ?? '';
      otherBlockController.text = trainingParticipantDatum!.otherBlock ?? '';
      String dobdate = trainingParticipantDatum!.dob ?? '';
      String outputDateString1 = '';
      try {
        stateVal = trainingParticipantDatum!.stateId ?? '';
        distictValue = trainingParticipantDatum!.districtId ?? '';
        blockValue = trainingParticipantDatum!.blockId ?? '';
      } catch (e) {
        stateVal = '';
      }
      if (trainingParticipantDatum!.teacherGrade != null &&
          trainingParticipantDatum!.teacherGrade!.isNotEmpty) {
        List<String> gradeIdList =
            trainingParticipantDatum!.teacherGrade!.split(',');
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
      try {
        genderController.text = genderModelList
            .where(
                (element) => element.value == trainingParticipantDatum!.gender)
            .first
            .text;
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
      if (qrCodeData != null) {
        String outputDateString = 'N/a';
        if (trainingParticipantDatum!.monthYearAttendSession != null &&
            trainingParticipantDatum!.monthYearAttendSession != 'N/a' &&
            trainingParticipantDatum!.monthYearAttendSession!.isNotEmpty) {
          DateTime inputDate = DateFormat("yyyy-MM-dd")
              .parse(trainingParticipantDatum!.monthYearAttendSession!);
          outputDateString = DateFormat("dd/MM/yyyy").format(inputDate);
        }
        monthAndYearController.text = outputDateString;

        try {
          if (languages.indexOf(selectedLanguagevalue) == 1) {
            participantProfileController.text = designationModelList
                .where((element) =>
                    element.id.toString() ==
                    trainingParticipantDatum!.designation)
                .first
                .hindiDesignation!;
          } else if (languages.indexOf(selectedLanguagevalue) == 2) {
            participantProfileController.text = designationModelList
                .where((element) =>
                    element.id.toString() ==
                    trainingParticipantDatum!.designation)
                .first
                .marathiDesignation!;
          } else {
            participantProfileController.text = designationModelList
                .where((element) =>
                    element.id.toString() ==
                    trainingParticipantDatum!.designation)
                .first
                .englishDesignation!;
          }
          selectedMinistryId = designationModelList
              .where((element) =>
                  element.id.toString() ==
                  trainingParticipantDatum!.designation)
              .first
              .ministryId!;
        } catch (error, stackTrace) {
          logError(error, stackTrace);
        }

        attendedBeforeController.text =
            trainingParticipantDatum!.attendedArpanSessionChildSexualAbuse ??
                '';
        if (attendedBeforeController.text == LabelText.getText('yes')) {
          hasAttendedBefore = true;
        } else {
          hasAttendedBefore = false;
          monthAndYearController.text = 'N/a';
        }
      }
    }
    apiData = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 300.w,
          leading: Row(
            children: [
              /*  IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  isBackPressed = true;
                  Navigator.pushReplacementNamed(
                      context,
                      // isEditedPage
                      //     ?
                      RouteConstants.participentdashboardScreen
                      // : RouteConstants.loginScreen,
                      );
                },
              ),*/
              Text(" Profile Registration",
                  style: Styles.red164
                      .copyWith(color: ColorConstants.defaultMaroon))
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
                LabelText.getLang(languages.indexOf(selectedLanguagevalue) + 1);
                await customSecureStorage.writeSecureValue(
                    key: SecureStorageKeys.langId,
                    value: (languages.indexOf(selectedLanguagevalue) + 1)
                        .toString());
                languageId = languages.indexOf(selectedLanguagevalue) + 1;
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
          ],
          elevation: 0,
        ),
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Form Details',
                              style: Styles.black164,
                            ),
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
                                if (emailMandatory) {
                                  if (value == null || value.isEmpty) {
                                    return LabelText.getText('emailempty');
                                  }

                                  if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return LabelText.getText('emailvalid');
                                  }
                                } else {
                                  if (value != null && value.isNotEmpty) {
                                    if (!RegExp(r'\S+@\S+\.\S+')
                                        .hasMatch(value)) {
                                      return LabelText.getText('emailvalid');
                                    }
                                  }
                                }

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
                              textEditingController: fullNameController,
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

                                dobController.text = await _selectDate(context);
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
                                  otherParticipantProfileController.clear();
                                  try {
                                    // if (value != null &&
                                    //     value !=
                                    //         LabelText.getText(
                                    //             'selectDesignation')) {
                                    // designationindex = int.parse(value) - 1;
                                    // designationindex = id + 1;

                                    if (languages
                                            .indexOf(selectedLanguagevalue) ==
                                        1) {
                                      selectedMinistryId = designationModelList
                                          .firstWhere((element) =>
                                              element.hindiDesignation ==
                                              participantProfileController.text)
                                          .ministryId!;
                                    } else if (languages
                                            .indexOf(selectedLanguagevalue) ==
                                        2) {
                                      selectedMinistryId = designationModelList
                                          .firstWhere((element) =>
                                              element.marathiDesignation ==
                                              participantProfileController.text)
                                          .ministryId!;
                                    } else {
                                      selectedMinistryId = designationModelList
                                          .firstWhere((element) =>
                                              element.englishDesignation ==
                                              participantProfileController.text)
                                          .ministryId!;
                                    }
                                    setState(() {});
                                    // }
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
                                        otherStateController.clear();
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
                                        otherDistrictController.clear();
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
                                          otherBlockController.clear();
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
                              textEditingController: pinCodeController,
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

                                  monthAndYearController.text =
                                      await _selectDate(context);
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
                            //   ]),
                            // ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 45.w),
                              child: CurvedButton(
                                  buttonTitle: data != null
                                      ? LabelText.getText('submit')
                                      : LabelText.close,
                                  style: Styles.white146,
                                  buttonColor: ColorConstants.defaultMaroon,
                                  height: 35.h,
                                  onPressed: () async {
                                    if (data == null) {
                                      await Navigator.pushReplacementNamed(
                                        context,
                                        RouteConstants
                                            .participentdashboardScreen,
                                      );
                                    } else if (_formKey.currentState!
                                        .validate()) {
                                      // if (establishmentController.text ==
                                      //     'Other') {
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
                                      // }
                                      if (dobController.text.isEmpty) {
                                        Toast.show(
                                            "Please select Date of birth",
                                            duration: 3,
                                            gravity: Toast.bottom,
                                            backgroundColor: Colors.red);
                                        return false;
                                      }
                                      if (teacherDesignationList.isNotEmpty &&
                                          teacherDesignationList.contains(
                                              participantProfileController
                                                  .text)) {
                                        if (!gradeSelection
                                            .containsValue(true)) {
                                          Toast.show("Please select Grade",
                                              duration: 3,
                                              gravity: Toast.bottom,
                                              backgroundColor: Colors.red);
                                          return false;
                                        }
                                      }

                                      if (attendedBeforeController
                                          .text.isEmpty) {
                                        monthAndYearController.text = 'N/a';
                                      }
                                      if (monthAndYearController.text.isEmpty) {
                                        monthAndYearController.text = 'N/a';
                                      }
                                      try {
                                        showCustomDialog(
                                          context,
                                          widget: ShowAlertDialogBox(
                                              secondFunc: () async {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                isBackPressed = true;
                                                /* await Navigator
                                                    .pushReplacementNamed(
                                                        context,
                                                        RouteConstants
                                                            .questionListScreen,
                                                        arguments: qrCodeData);*/

                                                await Navigator
                                                    .pushReplacementNamed(
                                                  context,
                                                  RouteConstants
                                                      .participentdashboardScreen,
                                                );
                                              },
                                              func: () async {
                                                String gendervalue =
                                                    genderModelList
                                                        .where((element) =>
                                                            element.text ==
                                                            genderController
                                                                .text)
                                                        .first
                                                        .value;
                                                String designationvalue = "";

                                                if (languages.indexOf(
                                                        selectedLanguagevalue) ==
                                                    1) {
                                                  designationvalue =
                                                      designationModelList
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
                                                  designationvalue =
                                                      designationModelList
                                                          .where((element) =>
                                                              element
                                                                  .marathiDesignation ==
                                                              participantProfileController
                                                                  .text)
                                                          .first
                                                          .id
                                                          .toString();
                                                } else {
                                                  designationvalue =
                                                      designationModelList
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
                                                    establishmentController
                                                        .text;
                                                String outputDateString =
                                                    monthAndYearController.text;
                                                if (monthAndYearController
                                                        .text.isNotEmpty &&
                                                    monthAndYearController
                                                            .text !=
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
                                                  DateTime inputDate =
                                                      DateFormat("dd/MM/yyyy")
                                                          .parse(dobController
                                                              .text);
                                                  dobdateString =
                                                      DateFormat("yyyy-MM-dd")
                                                          .format(inputDate);
                                                }

                                                var trainingDatum =
                                                    TrainingScheduleParticipantModel(
                                                        stateId: stateVal,
                                                        districtId:
                                                            distictValue,
                                                        fullName:
                                                            fullNameController
                                                                .text,
                                                        blockId: blockValue,
                                                        email: emailController
                                                            .text,
                                                        phoneNo:
                                                            mobileController
                                                                .text,
                                                        attendedArpanSessionChildSexualAbuse:
                                                            attendedBeforevalue,
                                                        dob: dobdateString,
                                                        scheduleGuid: qrCodeData!
                                                                .scheduleGuid ??
                                                            trainingParticipantDatum!
                                                                .scheduleGuid,
                                                        gender: gendervalue,
                                                        udiseCode:
                                                            udiseCodeController
                                                                .text,
                                                        pinCode:
                                                            pinCodeController
                                                                .text,
                                                        organisationName:
                                                            orgName,
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
                                                            mobileController
                                                                .text,
                                                        isEdited: 1,
                                                        registrationGuid: qrCodeData!
                                                                .registrationGuid ??
                                                            trainingParticipantDatum!
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
                                                  trainingDatum
                                                          .otherDesignation =
                                                      otherParticipantProfileController
                                                          .text;
                                                }
                                                if (teacherDesignationList.contains(
                                                    participantProfileController
                                                        .text)) {
                                                  List<String> selectedGrades =
                                                      [];
                                                  List<String>
                                                      selectedGradeIds = [];
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
                                                      selectedGradeIds
                                                          .join(',');
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
                                                  var obj =
                                                      jsonDecode(jsonBatch);

                                                  var response =
                                                      await TrainingParticipantRegistrationAPI()
                                                          .postTrainingParticipantRegistration(
                                                              postBody: obj);
                                                  if (response.isSuccess) {
                                                    trainingDatum.isEdited = 0;
                                                    await dbhelper
                                                        .insertParticipent(
                                                            trainingDatum);
                                                  }
                                                  if (response.isSuccess) {
                                                    return LabelText.success;
                                                  } else {
                                                    return LabelText
                                                        .uploadFailed;
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
                            ),
                            SizedBox(height: 20.h)
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

  Future<String> _selectDate(BuildContext context) async {
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
