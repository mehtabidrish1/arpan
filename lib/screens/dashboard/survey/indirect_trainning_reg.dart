import 'dart:convert';
import 'dart:io';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/models/indirectData_uploadImageModel.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../../api/TblTraningIndirectDataList_api.dart';
import '../../../api/indirectData_uploadImageApi.dart';
import '../../../constants/color_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../constants/secure_storage_keys.dart';
import '../../../constants/style/style1.dart';
import '../../../models/TrainerEstablishmentList_model.dart';
import '../../../models/training_schedule_participant_model.dart';
import '../../../table_model/tblTraningIndirectData_list.dart';
import '../../../table_model/tbl_block_model.dart';
import '../../../table_model/tbl_district_model.dart';
import '../../../table_model/tbl_master_model.dart';
import '../../../table_model/tbl_state_model.dart';
import '../../../table_model/tbl_teacher_grade_model.dart';
import '../../../table_model/training_indirect_data_model.dart';
import '../../../utils/common.dart';
import '../../../utils/lableText.dart';
import '../../../utils/log_files.dart';
import '../../../widgets/custom_curvedTextfield.dart';
import '../../../widgets/custom_loading_indicator.dart';
import '../../../widgets/registration_drop_down.dart';
import '../../../widgets/registration_text_field.dart';
import '../attendances/custom_camera.dart';
import 'indirect_reg_page2/custom_checkbox_reg.dart';
import 'indirect_reg_page2/custom_radioButton_reg.dart';

class IndirectTrainingRegistration extends StatefulWidget {
  const IndirectTrainingRegistration({Key? key}) : super(key: key);

  @override
  State<IndirectTrainingRegistration> createState() =>
      _IndirectTrainingRegistrationState();
}

class _IndirectTrainingRegistrationState
    extends State<IndirectTrainingRegistration> {
  var isDisposed = false;
  TextEditingController adultalonjointlyController = TextEditingController();
  TextEditingController ifjointlyController = TextEditingController();
  TextEditingController otherChildModuleController = TextEditingController();
  TextEditingController otherAdultModuleController = TextEditingController();
  TextEditingController childYearController = TextEditingController();
  TextEditingController childMonthController = TextEditingController();
  TextEditingController adultYearController = TextEditingController();
  TextEditingController adultMonthController = TextEditingController();
  TextEditingController reachedChildrenCountController =
      TextEditingController();
  TextEditingController reachedMaleChildrenCountController =
      TextEditingController();
  TextEditingController reachedFemaleChildrenCountController =
      TextEditingController();
  TextEditingController reachedAdultCountController = TextEditingController();
  TextEditingController reachedParentsCountController = TextEditingController();
  TextEditingController establishmentController = TextEditingController();
  TextEditingController otherStateController = TextEditingController();
  TextEditingController otherDistrictController = TextEditingController();
  TextEditingController otherBlockController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController udiseController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String stateVal = '';
  String distictValue = '';
  String blockValue = '';
  String? childModule;
  String? adultModule;
  int _maxSelection = 0;
  bool jointlyConfirm = false;

  TblTraningIndirectDataList indirectData = TblTraningIndirectDataList();
  List<TrainingScheduleParticipantModel> trainingList = [];
  TrainingScheduleParticipantModel paricipentinfo =
      TrainingScheduleParticipantModel();

  List<TrainerEstablishmentDatum> trainerEstablishment = [];
  List<String> EstablishmentlList = [];
  String? indirectGUid;
  // bool enableYear2 = false;
  List trainingParticipantList = [];
  List filteredParticipantList = [];
  Map<String, bool> selectedJointlyParticipant = {};

  String selectedLanguagevalue = 'English';
  List<String> languages = ["English", "Hindi", "Marathi"];
  int languageId = 1;

  List<File> fileList = [];
  Map<String, Object> _formdata = {};
  final _formKey = GlobalKey<FormState>();
  TrainingIndirectData trainingData = TrainingIndirectData();
  var mobileNo;
  CustomSecureStorage customSecureStorage = CustomSecureStorage();
  List<TblStateModel> states = [];
  List<TblDistrictModel> districts = [];
  List<BlockDatum> blockList = [];

  List<TblMasterModel> genderModelList = [];
  List<TblMasterModel> adultalonjointlyModelList = [];
  List<String> genderlList = [];
  List<String> adultalonjointlyList = [];

  List<TblMasterModel> reachedOutArpanListmodel = [];
  List<TblMasterModel> reachedOutArpanchildrenModuleList = [];
  List<TblMasterModel> reachedOutArpanAdultModuleList = [];
  List<TblTeacherGradeModel> teacherGradeList = [];
  List<String> teacherGrades = [];
  Map<String, bool> gradeSelection = {};
  int? givenYear, currentYear, givenMonth, currentMonth;
  List<String> yearList = [];
  List<String> childMonthList = [];
  List<String> adultMonthList = [];

  final List<String> allMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  List<TblMasterModel> noOneList = [];

  setAllListData() async {
    var sessionDate = indirectData.trainingSessionDate ?? '';
    if (sessionDate.isNotEmpty) {
      yearList.add(LabelText.getText('selectHere'));
      childMonthList.add(LabelText.getText('selectHere'));
      adultMonthList.add(LabelText.getText('selectHere'));
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(sessionDate);
      givenYear = parsedDate.year;
      givenMonth = parsedDate.month;
      currentYear = DateTime.now().year;
      currentMonth = DateTime.now().month;

      // Populate year dropdown (from given year to current year)
      List tempYearList =
          List.generate(currentYear! - givenYear! + 1, (i) => givenYear! + i);
      yearList.addAll(tempYearList.map((e) => e.toString()));
    }
    if (languages.indexOf(selectedLanguagevalue) == 1) {
      // monthList = monthListHi;

      adultalonjointlyModelList = await DataProvider()
          .getMastrerListData('IndirectDataAdultAloneJointlyHindi');
      reachedOutArpanListmodel = await DataProvider()
          .getMastrerListData('IndirectDataReachedOutHindi');
      reachedOutArpanchildrenModuleList = await DataProvider()
          .getMastrerListData('ChildrenIndicateModuleHindi');
      reachedOutArpanAdultModuleList =
          await DataProvider().getMastrerListData('AdultIndicateModuleHindi');
      noOneList =
          await DataProvider().getMastrerListData('NotYetWithNoOneHindi');
    } else if (languages.indexOf(selectedLanguagevalue) == 2) {
      // monthList = monthListMa;
      adultalonjointlyModelList = await DataProvider()
          .getMastrerListData('IndirectDataAdultAloneJointlyMarathi');
      reachedOutArpanListmodel = await DataProvider()
          .getMastrerListData('IndirectDataReachedOutMarathi');
      reachedOutArpanchildrenModuleList = await DataProvider()
          .getMastrerListData('ChildrenIndicateModuleMarathi');
      reachedOutArpanAdultModuleList =
          await DataProvider().getMastrerListData('AdultIndicateModuleMarathi');
      noOneList =
          await DataProvider().getMastrerListData('NotYetWithNoOneMarathi');
    } else {
      // monthList = monthListEng;

      adultalonjointlyModelList = await DataProvider()
          .getMastrerListData('IndirectDataAdultAloneJointly');
      reachedOutArpanListmodel =
          await DataProvider().getMastrerListData('IndirectDataReachedOut');
      reachedOutArpanchildrenModuleList =
          await DataProvider().getMastrerListData('ChildrenIndicateModule');
      reachedOutArpanAdultModuleList =
          await DataProvider().getMastrerListData('AdultIndicateModule');
      noOneList = await DataProvider().getMastrerListData('NotYetWithNoOne');
    }
    if (indirectData.mscertEnabledFlag == "0") {
      reachedOutArpanchildrenModuleList
          .removeWhere((element) => element.value == '3');
    } else if (indirectData.mscertEnabledFlag == "1") {
      reachedOutArpanchildrenModuleList
          .removeWhere((element) => element.value == '2');
    }
    teacherGradeList = await DataProvider().getTeacherGradeList();
    if (teacherGradeList.isNotEmpty) {
      teacherGrades = teacherGradeList.map((e) => e.teacherGrade).toList();
    }
    for (var grade in teacherGrades) {
      gradeSelection[grade] = false;
    }
    teacherGrades.add('OK');

    states = await DataProvider().getAllState();
    districts = await DataProvider().getAllDistrict();
    blockList = await DataProvider().getAllBlock();
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

    genderModelList = await DataProvider().getMastrerListData('GenderEnglish');
    genderlList.clear();
    genderlList.add(LabelText.selectGender);
    for (var element in genderModelList) {
      genderlList.add(element.text);
    }

    adultalonjointlyList.clear();
    adultalonjointlyList.add(LabelText.getText('pleaseSelect'));
    for (var element in adultalonjointlyModelList) {
      adultalonjointlyList.add(element.text);
    }

    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    LabelText.getLang(languageId);
  }

  void _updateMonthList(String year, int type) {
    int selectedYear = int.parse(year);
    if (type == 0) {
      childMonthList.clear();
      childMonthList.add(LabelText.getText('selectHere'));
      List<String> tempMonthList = [];
      if (selectedYear == givenYear && givenYear != currentYear) {
        // If the selected year is the given year, show months from the given month to December
        tempMonthList = allMonths.sublist(givenMonth! - 1, 12);
      } else if (selectedYear == givenYear && givenYear == currentYear) {
        tempMonthList = allMonths.sublist(givenMonth! - 1, currentMonth);
      } else if (selectedYear == currentYear) {
        // If the selected year is the current year, show months from January to the current month
        tempMonthList = allMonths.sublist(0, currentMonth);
      } else {
        // If the selected year is in between, show all 12 months (January - December)
        tempMonthList = allMonths;
      }
      childMonthList.addAll(tempMonthList);
    } else {
      adultMonthList.clear();
      adultMonthList.add(LabelText.getText('selectHere'));
      List<String> tempMonthList = [];
      if (selectedYear == givenYear && givenYear != currentYear) {
        // If the selected year is the given year, show months from the given month to December
        tempMonthList = allMonths.sublist(givenMonth! - 1, 12);
      } else if (selectedYear == givenYear && givenYear == currentYear) {
        tempMonthList = allMonths.sublist(givenMonth! - 1, currentMonth);
      } else if (selectedYear == currentYear) {
        // If the selected year is the current year, show months from January to the current month
        tempMonthList = allMonths.sublist(0, currentMonth);
      } else {
        // If the selected year is in between, show all 12 months (January - December)
        tempMonthList = allMonths;
      }
      adultMonthList.addAll(tempMonthList);
    }
    setState(() {});
  }

  void _handleParticipantSelection(
      Map<String, dynamic> participant, bool selected) {
    final mobile = participant["Mobile"]!;

    if (selected) {
      final currentSelectedCount = _getSelectedCount();
      // Check if maxSelection is valid and within limits
      if (_maxSelection > 0 && currentSelectedCount < _maxSelection) {
        selectedJointlyParticipant[mobile] = true;
      } else {
        _showMaxSelectionDialog();
        return;
      }
    } else {
      selectedJointlyParticipant[mobile] = false;
    }

    setState(() {});
  }

  void _removeParticipant(Map<String, dynamic> participant) {
    final mobile = participant["Mobile"]!;
    selectedJointlyParticipant[mobile] = false;
    setState(() {});
  }

  void _removeExcessParticipants(int excessCount) {
    if (excessCount <= 0) return;

    // Remove the last 'excessCount' selected participants
    final selectedMobiles = selectedJointlyParticipant.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();

    for (int i = 0; i < excessCount && i < selectedMobiles.length; i++) {
      selectedJointlyParticipant[selectedMobiles[i]] = false;
    }
  }

  int _getSelectedCount() {
    return selectedJointlyParticipant.values
        .where((value) => value == true)
        .length;
  }

  List<dynamic> _getSelectedParticipants() {
    final selectedMobiles = selectedJointlyParticipant.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList();

    return filteredParticipantList.where((participant) {
      return selectedMobiles.contains(participant["Mobile"]);
    }).toList();
  }

  void _showMaxSelectionDialog() {
    String message;
    if (_maxSelection == 0) {
      message = 'Please enter a valid number of participants first.';
    } else {
      message = 'You can only select $_maxSelection participants. '
          'Please remove some participants first if you want to select different ones.';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maximum Selection Reached'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        indirectData = data[0];
        indirectGUid = data[1];
      }

      trainingParticipantList = indirectData.trainingParticipant ?? [];
      if (trainingParticipantList.isNotEmpty) {
        for (var element in trainingParticipantList) {
          selectedJointlyParticipant[element['Mobile']!] = false;
        }
      }
      filteredParticipantList = List.from(trainingParticipantList);
      searchController.addListener(_onSearchChanged);
      var langID = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.langId);
      if (langID != null) {
        languageId = int.parse(langID);
        LabelText.getLang(languageId);
        selectedLanguagevalue = languages[languageId - 1];
      }

      fileList.clear();
      await DataProvider().getIndirectDataImageList().then((value) {
        value = value
            .where((element) => element.indirectDataGuid == indirectGUid)
            .toList();
        for (var element in value) {
          var file = File(element.image!);
          fileList.add(file);
        }
      });
      mobileNo = await customSecureStorage.getSecureValues(
          key: SecureStorageKeys.phone);
      filteredParticipantList.removeWhere((item) => item["Mobile"] == mobileNo);

      await setAllListData();

      trainingList = await DataProvider()
          .getTrainingParticipantWithMobile(mobileNo: mobileNo);
      if (trainingList.isNotEmpty) {
        paricipentinfo = trainingList[0];
        establishmentController.text = paricipentinfo.organisationName ?? '';
        stateVal = paricipentinfo.stateId.toString();
        distictValue = paricipentinfo.districtId.toString();
        blockValue = paricipentinfo.blockId.toString();
        otherStateController.text = paricipentinfo.otherState ?? '';
        otherDistrictController.text = paricipentinfo.otherDistrict ?? '';
        otherBlockController.text = paricipentinfo.otherBlock ?? '';
        pinCodeController.text = paricipentinfo.pinCode ?? '';
        udiseController.text = paricipentinfo.udiseCode ?? '';
      }

      var trainingDataList = await DataProvider()
          .getindirctTraingingData(indirectDataGuid: indirectGUid);
      if (trainingDataList.isNotEmpty) {
        trainingData = trainingDataList[0];
        if (trainingData.Have_you_trained_Adult_alone_or_jointly_with_others !=
                null &&
            trainingData.Have_you_trained_Adult_alone_or_jointly_with_others!
                .isNotEmpty &&
            trainingData.Have_you_trained_Adult_alone_or_jointly_with_others !=
                "0") {
          try {
            adultalonjointlyController.text = adultalonjointlyModelList
                .where((element) =>
                    element.value ==
                    trainingData
                            .Have_you_trained_Adult_alone_or_jointly_with_others
                        .toString())
                .first
                .text;
          } catch (e) {}

          _formdata['jointly'] =
              trainingData.Have_you_trained_Adult_alone_or_jointly_with_others!;
          ifjointlyController.text =
              trainingData.If_jointly_with_how_many_others ?? '';
        }

        _formdata['toWhomHaveYouReachedOutWithArpanContent'] =
            trainingData.toWhomHaveYouReachedOutWithArpanContent != null
                ? trainingData.toWhomHaveYouReachedOutWithArpanContent
                    .toString()
                : '';
        reachedChildrenCountController.text =
            trainingData.howManyChildrenDidYouTrainThroughPseProgram != null
                ? trainingData.howManyChildrenDidYouTrainThroughPseProgram
                    .toString()
                : '';
        _formdata['childrenIndicateTheModuleUsed'] =
            trainingData.childrenIndicateTheModuleUsed ?? '';
        _formdata['childrenIndicateTheModuleUsedOther'] =
            trainingData.childrenIndicateTheModuleUsedOther ?? '';
        reachedAdultCountController.text =
            trainingData.howManyAdultsDidYouTrainUsingArpanContent != null
                ? trainingData.howManyAdultsDidYouTrainUsingArpanContent
                    .toString()
                : '';
        _formdata['adultIndicateTheModulePptUsed'] =
            trainingData.adultIndicateTheModulePptUsed ?? '';
        _formdata['adultIndicateTheModulePptUsedOther'] =
            trainingData.adultIndicateTheModulePptUsedOther ?? '';

        _formdata['ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy'] =
            trainingData.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy ?? '';
        _formdata['ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther'] =
            trainingData.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther ??
                '';
        if (trainingData.whenDidYouReachOutToChildrenYear1 != null) {
          childYearController.text =
              trainingData.whenDidYouReachOutToChildrenYear1 ??
                  LabelText.getText('selectHere');
        }

        if (trainingData.whenDidYouReachOutToAdultsYear1 != null) {
          adultYearController.text =
              trainingData.whenDidYouReachOutToAdultsYear1 ??
                  LabelText.getText('selectHere');
        }
      }
      // if(indirectGUid==null){
      indirectGUid ??= const Uuid().v1();
      // }

      if (mounted) {
        setState(() {
          isDisposed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredParticipantList = List.from(trainingParticipantList);
      } else {
        filteredParticipantList = trainingParticipantList.where((participant) {
          final name = participant["Name"]?.toLowerCase() ?? '';
          final mobile = participant["Mobile"]?.toLowerCase() ?? '';
          return name.contains(query) || mobile.contains(query);
        }).toList();
      }
    });
  }

  List<String> stringToList(String data) {
    List<String> valueList = [];
    if (data == null) {
      return valueList;
    } else {
      if (data.contains(',')) {
        valueList = data.split(',');
      } else {
        valueList.add(data);
      }
    }
    return valueList;
  }

  String listToString(List data) {
    String value = '';
    if (data == null || data.isEmpty) {
      return value;
    } else {
      for (var element in data) {
        if (value.length == 0) {
          value = element;
        } else {
          value = value + ',' + element;
        }
      }
    }
    return value;
  }

/*
  var reachedOutArpanList = [
    'Only Children',
    'Only Adults',
    'Both Children & Adults',
    'Not Yet / With No One'
  ];
  */

  void _updateState(int index) {
    setState(() {});
  }

  void _updateState1(int index) {
    if (_formdata.containsKey('toWhomHaveYouReachedOutWithArpanContent') &&
        _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3') {
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy');
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther');
    } else if (_formdata
            .containsKey('toWhomHaveYouReachedOutWithArpanContent') &&
        (_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '2')) {
      reachedChildrenCountController.text = '';
      _formdata.remove('childrenIndicateTheModuleUsed');
      _formdata.remove('childrenIndicateTheModuleUsedOther');
      _formdata.remove('childrenMonthYear');
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy');
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther');
    } else if (_formdata
            .containsKey('toWhomHaveYouReachedOutWithArpanContent') &&
        (_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '1')) {
      reachedAdultCountController.text = '';
      _formdata.remove('adultIndicateTheModulePptUsed');
      _formdata.remove('adultIndicateTheModulePptUsedOther');
      _formdata.remove('adultMonthYear');
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy');
      _formdata.remove('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther');
    } else if (_formdata
            .containsKey('toWhomHaveYouReachedOutWithArpanContent') &&
        (_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '4')) {
      reachedChildrenCountController.text = '';
      _formdata.remove('childrenIndicateTheModuleUsed');
      _formdata.remove('childrenIndicateTheModuleUsedOther');
      _formdata.remove('childrenMonthYear');
      reachedAdultCountController.text = '';
      _formdata.remove('adultIndicateTheModulePptUsed');
      _formdata.remove('adultIndicateTheModulePptUsedOther');
      _formdata.remove('adultMonthYear');
    }
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
              elevation: 0,
              automaticallyImplyLeading: false,
              // leadingWidth: 300.w,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  FocusScope.of(context).unfocus();

                  isDisposed = true;
                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.indirecttrainningRegList,
                    arguments: [indirectData],
                  );
                },
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
                    selectedLanguagevalue = selectedLanguage!;
                    languageId = languages.indexOf(selectedLanguagevalue) + 1;
                    await customSecureStorage.writeSecureValue(
                        key: SecureStorageKeys.langId,
                        value: (languages.indexOf(selectedLanguagevalue) + 1)
                            .toString());
                    LabelText.getLang(
                        languages.indexOf(selectedLanguagevalue) + 1);
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
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/rightButterflyTheme.png'),
                    fit: BoxFit.fill)),
            child: SafeArea(
                child: Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        SizedBox(
                          height: 12.h,
                        ),
                        Text(
                          LabelText.getText('ifYouTransferred'),
                          style: Styles.black145,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        RegistrationTextField(
                          subTitle: LabelText.getText('nameOfOrganization'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
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
                        const SizedBox(height: 12),
                        RegistrationTextField(
                          subTitle: LabelText.getText('schoolUDISEcode'),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return LabelText.getText(
                          //         'designationempty');
                          //   }
                          //   return null;
                          // },
                          textEditingController: udiseController,
                          title: LabelText.getText('schoolUDISEcode'),
                          onChanged: (value) {
                            if (kDebugMode) {
                              print(value);
                            }
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
                                  icon: const Icon(Icons.keyboard_arrow_down),
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
                            decoration:
                                const InputDecoration(border: InputBorder.none),
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
                                                (element.stateId.toString() ==
                                                        stateVal ||
                                                    element.stateId ==
                                                        9999999) &&
                                                element.districtId.toString() ==
                                                    distictValue,
                                            orElse: () =>
                                                TblDistrictModel(), // Return null if no element matches the condition.
                                          )
                                          .districtName
                                      : null,
                                  icon: const Icon(Icons.keyboard_arrow_down),
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
                                            element.districtName! == idval &&
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
                            decoration:
                                const InputDecoration(border: InputBorder.none),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                                                  (element.stateId.toString() ==
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
                                    icon: const Icon(Icons.keyboard_arrow_down),
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
                                                (element.stateId.toString() ==
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
                                      otherBlockController.clear();
                                      blockValue = blockList
                                          .where((element) =>
                                              element.blockName! == val &&
                                              (element.stateId.toString() ==
                                                      stateVal ||
                                                  element.stateId == 9999999) &&
                                              (element.districtId.toString() ==
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
                            decoration:
                                const InputDecoration(border: InputBorder.none),
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
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LabelText.getText('zipPostalPinCodeempty');
                            } else if (value.length > 6 || value.length < 6) {
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
                          height: 12.h,
                        ),
                        RegRadioGroup(
                            fieldKey: 'toWhomHaveYouReachedOutWithArpanContent',
                            title: LabelText.getText('reachedOutArpan'),
                            content: reachedOutArpanListmodel,
                            formdata: _formdata,
                            update: _updateState1),
                        SizedBox(
                          height: 12.h,
                        ),
                        if (_formdata.containsKey(
                                'toWhomHaveYouReachedOutWithArpanContent') &&
                            (_formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '1' ||
                                _formdata[
                                        'toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '3')) ...[
                          Text(LabelText.getText('reachedChildrenCount')),
                          SizedBox(
                            height: 6.h,
                          ),
                          RegistrationTextField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${LabelText.getText('pleaseenter')}  ${LabelText.getText('reachedChildrenCount')}';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^[0-9]{1,5})')),
                            ],
                            textEditingController:
                                reachedMaleChildrenCountController,
                            title: LabelText.getText('maleChildTrained'),
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          RegistrationTextField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${LabelText.getText('pleaseenter')}  ${LabelText.getText('reachedChildrenCount')}';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^[0-9]{1,5})')),
                            ],
                            textEditingController:
                                reachedFemaleChildrenCountController,
                            title: LabelText.getText('femaleChildTrained'),
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                          if (teacherGrades.isNotEmpty) ...[
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
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownButton<String>(
                                    isExpanded: true,
                                    underline: Container(),
                                    hint:
                                        Text(LabelText.getText('selectGrade')),
                                    items: teacherGrades.map((String grade) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.topRight,
                                        value: grade,
                                        onTap: () => setState(() {}),
                                        child: grade == 'OK'
                                            ? InkWell(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(grade,
                                                      style: Styles.black164
                                                          .copyWith(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.blue)),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                  setState(() {});
                                                },
                                              )
                                            : StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return CheckboxListTile(
                                                    title: Text(grade),
                                                    value:
                                                        gradeSelection[grade],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        gradeSelection[grade] =
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
                                  if (gradeSelection.containsValue(true)) ...[
                                    Wrap(
                                      spacing: 6.0,
                                      runSpacing: 6.0,
                                      children: gradeSelection.entries
                                          .where((entry) => entry.value)
                                          .map((entry) => Chip(
                                                label: Text(entry.key),
                                                onDeleted: () {
                                                  setState(() {
                                                    gradeSelection[entry.key] =
                                                        false;
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
                          SizedBox(
                            height: 12.h,
                          ),
                          Visibility(
                            key: const Key('childrenIndicateTheModuleUsed'),
                            visible: _formdata.containsKey(
                                    'toWhomHaveYouReachedOutWithArpanContent') &&
                                (_formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                        '1' ||
                                    _formdata[
                                            'toWhomHaveYouReachedOutWithArpanContent'] ==
                                        '3'),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  LabelText.getText('reachedChildrenmodule'),
                                  wrapWords: false,
                                  style: Styles.black124,
                                  maxLines: 10,
                                ),
                                Container(
                                  height: 45.h,
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusColor: Colors.transparent,

                                        isExpanded: true,
                                        // key: const Key(
                                        //   'state',
                                        // ),
                                        hint: Text(
                                          LabelText.getText('selectHere'),
                                          style: Styles.grey12500,
                                        ),
                                        value: childModule,
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
                                        items: reachedOutArpanchildrenModuleList
                                            .map((e) => DropdownMenuItem(
                                                value: e.value,
                                                child: Text(
                                                  e.text,
                                                  style: Styles.grey12500,
                                                )))
                                            .toList(),
                                        onChanged: (val) async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          childModule = val;
                                          // var idval = val!;
                                          // stateVal = states
                                          //     .where((element) =>
                                          //         element.stateName! == idval)
                                          //     .first
                                          //     .stateId!
                                          //     .toString();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (childModule == '99') ...[
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  RegistrationTextField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LabelText.getText('Otherempty');
                                      }
                                      return null;
                                    },
                                    textEditingController:
                                        otherChildModuleController,
                                    title: LabelText.getText('Other'),
                                    onChanged: (value) {
                                      // _formdata[widget.fieldOtherKey] = value;
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          AutoSizeText(
                            LabelText.getText('yearMonthchildrenReachout'),
                            wrapWords: false,
                            style: Styles.black124,
                            maxLines: 10,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          RegistrationDropDown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LabelText.getText('selectyear');
                              } else {
                                return null;
                              }
                            },
                            initialValue: LabelText.getText('selectHere'),
                            items: yearList,
                            textEditingController: childYearController,
                            title: LabelText.getText('year'),
                            onChanged: (value) {
                              try {
                                if (yearList.isNotEmpty &&
                                    childYearController.text !=
                                        LabelText.getText('selectHere')) {
                                  _updateMonthList(childYearController.text, 0);
                                  //
                                  //  _formdata['gender'] = value.toString();
                                  setState(() {});
                                }
                              } catch (error, stackTrace) {
                                logError(error, stackTrace);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          RegistrationDropDown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LabelText.getText('selectmonth');
                              } else {
                                return null;
                              }
                            },
                            initialValue: LabelText.getText('selectHere'),
                            items: childMonthList,
                            textEditingController: childMonthController,
                            title: LabelText.getText('months'),
                            onChanged: (value) {
                              try {
                                if (childMonthList.isNotEmpty &&
                                    value != LabelText.getText('selectHere')) {
                                  //
                                  //  _formdata['gender'] = value.toString();
                                  setState(() {});
                                }
                              } catch (error, stackTrace) {
                                logError(error, stackTrace);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                        if (_formdata.containsKey(
                                'toWhomHaveYouReachedOutWithArpanContent') &&
                            (_formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '2' ||
                                _formdata[
                                        'toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '3')) ...[
                          Text(LabelText.getText('reachedAdultCount')),
                          SizedBox(
                            height: 6.h,
                          ),
                          RegistrationTextField(
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '${LabelText.getText('pleaseenter')} ${LabelText.getText('reachedAdultCount')}';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'(^[0-9]{1,5})')),
                            ],
                            textEditingController:
                                reachedParentsCountController,
                            title: LabelText.getText('reachedParentsCount'),
                            textInputType: TextInputType.number,
                            onChanged: (value) {
                              print(value);
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Visibility(
                            key: const Key('adultIndicateTheModulePptUsed'),
                            visible: _formdata.containsKey(
                                    'toWhomHaveYouReachedOutWithArpanContent') &&
                                (_formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                        '2' ||
                                    _formdata[
                                            'toWhomHaveYouReachedOutWithArpanContent'] ==
                                        '3'),
                            child: Column(
                              children: [
                                AutoSizeText(
                                  LabelText.getText('reachedAdultmodule'),
                                  wrapWords: false,
                                  style: Styles.black124,
                                  maxLines: 10,
                                ),
                                Container(
                                  height: 45.h,
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusColor: Colors.transparent,

                                        isExpanded: true,
                                        // key: const Key(
                                        //   'state',
                                        // ),
                                        hint: Text(
                                          LabelText.getText('selectHere'),
                                          style: Styles.grey12500,
                                        ),
                                        value: adultModule,
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
                                        items: reachedOutArpanAdultModuleList
                                            .map((e) => DropdownMenuItem(
                                                value: e.value,
                                                child: Text(
                                                  e.text,
                                                  style: Styles.grey12500,
                                                )))
                                            .toList(),
                                        onChanged: (val) async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          adultModule = val;
                                          // var idval = val!;
                                          // stateVal = states
                                          //     .where((element) =>
                                          //         element.stateName! == idval)
                                          //     .first
                                          //     .stateId!
                                          //     .toString();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                if (adultModule == '99') ...[
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  RegistrationTextField(
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return LabelText.getText('Otherempty');
                                      }
                                      return null;
                                    },
                                    textEditingController:
                                        otherAdultModuleController,
                                    title: LabelText.getText('Other'),
                                    onChanged: (value) {
                                      // _formdata[widget.fieldOtherKey] = value;
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          AutoSizeText(
                            LabelText.getText('adultYearMonth'),
                            wrapWords: false,
                            style: Styles.black124,
                            maxLines: 10,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          RegistrationDropDown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LabelText.getText('selectyear');
                              } else {
                                return null;
                              }
                            },
                            initialValue: LabelText.getText('selectHere'),
                            items: yearList,
                            textEditingController: adultYearController,
                            title: LabelText.getText('year'),
                            onChanged: (value) {
                              try {
                                if (yearList.isNotEmpty &&
                                    adultYearController.text !=
                                        LabelText.getText('selectHere')) {
                                  _updateMonthList(adultYearController.text, 1);
                                  //
                                  //  _formdata['gender'] = value.toString();
                                  setState(() {});
                                }
                              } catch (error, stackTrace) {
                                logError(error, stackTrace);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          RegistrationDropDown(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LabelText.getText('selectmonth');
                              } else {
                                return null;
                              }
                            },
                            initialValue: LabelText.getText('selectHere'),
                            items: adultMonthList,
                            textEditingController: adultMonthController,
                            title: LabelText.getText('months'),
                            onChanged: (value) {
                              try {
                                if (adultMonthList.isNotEmpty &&
                                    value != LabelText.getText('selectHere')) {
                                  //
                                  //  _formdata['gender'] = value.toString();
                                  setState(() {});
                                }
                              } catch (error, stackTrace) {
                                logError(error, stackTrace);
                              }
                            },
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                        ],
                        if (_formdata.containsKey(
                                'toWhomHaveYouReachedOutWithArpanContent') &&
                            (_formdata[
                                        'toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '1' ||
                                _formdata[
                                        'toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '2' ||
                                _formdata[
                                        'toWhomHaveYouReachedOutWithArpanContent'] ==
                                    '3')) ...[
                          if (adultalonjointlyList.isNotEmpty) ...[
                            RegistrationDropDown(
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value ==
                                        LabelText.getText('pleaseSelect')) {
                                  return _formdata[
                                              'toWhomHaveYouReachedOutWithArpanContent'] ==
                                          '1'
                                      ? LabelText.getText('childrenjointly')
                                      : _formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                              '2'
                                          ? LabelText.getText(
                                              'adultalonjointly')
                                          : LabelText.getText('bothjointly');
                                }
                                return null;
                              },
                              initialValue: LabelText.getText('pleaseSelect'),
                              items: adultalonjointlyList,
                              textEditingController: adultalonjointlyController,
                              title: _formdata[
                                          'toWhomHaveYouReachedOutWithArpanContent'] ==
                                      '1'
                                  ? LabelText.getText('childrenjointly')
                                  : _formdata['toWhomHaveYouReachedOutWithArpanContent'] ==
                                          '2'
                                      ? LabelText.getText('adultalonjointly')
                                      : LabelText.getText('bothjointly'),
                              onChanged: (value) {
                                try {
                                  if (adultalonjointlyList.isNotEmpty &&
                                      value !=
                                          LabelText.getText('pleaseSelect')) {
                                    if (adultalonjointlyController.text
                                            .toLowerCase() !=
                                        'jointly') {
                                      ifjointlyController.text = '';
                                    }
                                    // print(adultalonjointlyController.text);
                                    _formdata['jointly'] = value.toString();
                                    setState(() {});
                                  }
                                } catch (error, stackTrace) {
                                  logError(error, stackTrace);
                                }
                              },
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            if (adultalonjointlyController.text.toLowerCase() ==
                                'jointly') ...[
                              RegistrationTextField(
                                isReadOnly: false,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                autovalidateMode: AutovalidateMode
                                    .onUserInteraction, // Add this line
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    _maxSelection = 0; // Reset max selection
                                    return 'Please enter number of participants';
                                  }
                                  final numValue = int.tryParse(value);
                                  if (numValue == null || numValue <= 0) {
                                    _maxSelection = 0; // Reset max selection
                                    return 'Number must be more than 0';
                                  }
                                  if (numValue >
                                      filteredParticipantList.length) {
                                    _maxSelection = 0; // Reset max selection
                                    return 'Number cannot exceed total participants (${filteredParticipantList.length})';
                                  }

                                  // If validation passes, update max selection
                                  _maxSelection = numValue;

                                  // If current selection exceeds new max, remove excess participants
                                  final currentSelectedCount =
                                      _getSelectedCount();
                                  if (currentSelectedCount > _maxSelection) {
                                    _removeExcessParticipants(
                                        currentSelectedCount - _maxSelection);
                                  }

                                  return null;
                                },
                                textInputType: TextInputType.number,
                                textEditingController: ifjointlyController,
                                title: LabelText.getText('ifjointly'),
                                onChanged: (value) {
                                  print(value);
                                  // Trigger validation on change
                                  setState(() {});
                                },
                              ),
                              SizedBox(height: 12.h),

                              // Selected participants chips
                              if (_getSelectedParticipants().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: _getSelectedParticipants()
                                        .map((participant) {
                                      return Chip(
                                        label: Text(participant["Name"]!),
                                        deleteIcon:
                                            const Icon(Icons.close, size: 16),
                                        onDeleted: () {
                                          _removeParticipant(participant);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),

                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  color: ColorConstants.defaultTextfieldColor,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 15),
                                      child: Text(
                                        LabelText.participantName,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xffD71A21),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      child: CurvedTextField(
                                        height: 38.h,
                                        controller: searchController,
                                        onChanged: (e) => _onSearchChanged(),
                                        preffixIcon:
                                            const Icon(Icons.search, size: 28),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            searchController.clear();
                                            _onSearchChanged();
                                          },
                                          icon:
                                              const Icon(Icons.cancel_outlined),
                                        ),
                                        hintText: 'Search',
                                        hintStyle: Styles.grey164,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: ListView.builder(
                                          itemCount:
                                              filteredParticipantList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            final participant =
                                                filteredParticipantList[index];
                                            final mobile =
                                                participant["Mobile"]!;
                                            final isSelected =
                                                selectedJointlyParticipant[
                                                        mobile] ??
                                                    false;

                                            return CheckboxListTile(
                                              title: Text(participant["Name"]!),
                                              subtitle: Text("📞 $mobile"),
                                              value: isSelected,
                                              onChanged: (bool? value) {
                                                _handleParticipantSelection(
                                                    participant,
                                                    value ?? false);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Checkbox(
                                    value: jointlyConfirm,
                                    onChanged: (bool? value) {
                                      jointlyConfirm = value!;
                                      setState(() {});
                                    },
                                  ),
                                  Text(
                                    'I confirm that these are the joint participants.',
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                            ],
                          ],
                          if (_formdata.containsKey(
                                  'toWhomHaveYouReachedOutWithArpanContent') &&
                              (_formdata[
                                      'toWhomHaveYouReachedOutWithArpanContent'] ==
                                  '4')) ...[
                            SizedBox(
                              height: 12.h,
                            ),
                            RegCheckBoxGroup(
                                fieldKey:
                                    'ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy',
                                fieldOtherKey:
                                    'ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther',
                                title: LabelText.getText('reachedNonone'),
                                content: noOneList,
                                formdata: _formdata,
                                update: _updateState),
                            SizedBox(
                              height: 12.h,
                            ),
                          ],
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () async {
                                try {
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
                                                          const BorderRadius
                                                              .only(
                                                              topRight: Radius
                                                                  .circular(40),
                                                              topLeft: Radius
                                                                  .circular(5),
                                                              bottomLeft: Radius
                                                                  .circular(5),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                ),
                                                onTap: () async {
                                                  final pickedFile =
                                                      await ImagePicker()
                                                          .pickImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery);
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
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    40),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5))),
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
                                    var data = IndirectDataUploadImageModel(
                                        image.path, indirectGUid, '0');
                                    await DataProvider()
                                        .insertIndirectDataImage(data);
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
                          ),
                          SizedBox(height: 15.h),
                          for (int i = 0; i < fileList.length; i++) ...{
                            imageinfo(fileList[i], i)
                          },
                          SizedBox(
                            height: 20.h,
                          ),
                        ]
                      ]))),
            )),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: CurvedButton(
                      buttonColor: ColorConstants.defaultMaroon,
                      buttonTitle: LabelText.getText('submit'),
                      style: Styles.white146,
                      height: 40.h,
                      onPressed: () async {
                        // print(_formdata);
                        //  getMonthYearData('childrenMonthYear');
                        if (_formKey.currentState!.validate() &&
                            checkValidation()) {
                          // await saveConfirmationPopup();
                          try {
                            paricipentinfo.organisationName =
                                establishmentController.text;
                            paricipentinfo.udiseCode = udiseController.text;
                            paricipentinfo.stateId = stateVal;
                            paricipentinfo.districtId = distictValue;
                            paricipentinfo.blockId = blockValue;
                            paricipentinfo.otherState =
                                otherStateController.text;
                            paricipentinfo.otherDistrict =
                                otherDistrictController.text;
                            paricipentinfo.otherBlock =
                                otherBlockController.text;
                            paricipentinfo.pinCode = pinCodeController.text;
                            await DataProvider()
                                .insertParticipent(paricipentinfo);
                          } catch (e) {
                            // logError(error, stackTrace);
                          }

                          await saveSurverData();
                          isDisposed = true;
                        }
                        /*  await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.indirecttrainninglist,
                        );*/
                      }),
                ),
                Expanded(
                    child: CurvedGreyButton(
                  buttonTitle: LabelText.getText('Cancel'),
                  style: Styles.white146,
                  height: 40.h,
                  onPressed: () async {
                    isDisposed = true;
                    await Navigator.popAndPushNamed(
                      context,
                      RouteConstants.indirecttrainningRegList,
                      arguments: [indirectData],
                    );
                  },
                ))
              ],
            ),
          )),
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

  Widget imageinfo(File image_file, int index) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: SizedBox(
        height: 300.h,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Colors.red), // Customize the delete icon
                  onPressed: () async {
                    await DataProvider().deleteIndirectDataImage(
                        fileList[index]!.path, indirectGUid!);
                    fileList.removeAt(index);
                    setState(() {});
                    setState(() {});
                    // Add your delete logic here
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 180.h,
                  width: 240.w,
                  child: Image.file(
                    image_file,
                    fit: BoxFit.cover,
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<XFile?> pickImageFromCamera() async {
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
    return imageFile;
  }

  Future<void> saveSurverData() async {
    if (trainingData.indirectDataGuid == null ||
        trainingData.indirectDataGuid!.isEmpty) {
      trainingData.indirectDataGuid = indirectGUid;
      trainingData.createdBy = mobileNo;
      trainingData.createdOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
    } else {
      trainingData.updatedBy = mobileNo;
      trainingData.updatedOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
    }
    trainingData.IsEdited = 1;
    trainingData.scheduleGuid = indirectData.scheduleGuid;
    trainingData.registrationGuid = indirectData.registrationGuid;
    trainingData.sessionGuid = indirectData.sessionGuid;

    trainingData.email = paricipentinfo.email;
    trainingData.fullName = paricipentinfo.fullName;
    // trainingData.gender = int.tryParse(_formdata['gender'].toString());
    trainingData.gender = int.tryParse(paricipentinfo.gender!);
    trainingData.phoneNo = paricipentinfo.phoneNo;
    trainingData.Have_you_trained_Adult_alone_or_jointly_with_others =
        _formdata.containsKey('jointly') ? _formdata['jointly'].toString() : '';
    trainingData.If_jointly_with_how_many_others = ifjointlyController.text;
    // trainingData.establishment = ''jointly;

    // var orgName = establishmentController.text;
    // var orgCode = null;
    // if (orgName != 'Other') {
    //   try {
    //     orgCode = trainerEstablishment
    //         .where((element) =>
    //             element.name!.toString().trim().toLowerCase() ==
    //             orgName.trim().toLowerCase())
    //         .first
    //         .establishmentCode;
    //   } catch (e) {
    //     print(e);
    //   }
    // } else {
    //   orgName = organizationNameController.text;
    // }
    // trainingData.establishment = orgCode;
    trainingData.organisationName = paricipentinfo.organisationName;

    trainingData.pinCode = paricipentinfo.pinCode;
    trainingData.toWhomHaveYouReachedOutWithArpanContent = int.tryParse(
        _formdata['toWhomHaveYouReachedOutWithArpanContent'].toString());
    // trainingData.howManyChildrenDidYouTrainThroughPseProgram =
    //     int.tryParse(reachedChildrenCountController.text);
    // trainingData.childrenIndicateTheModuleUsed =
    //     returnMapValue("childrenIndicateTheModuleUsed");
    // trainingData.childrenIndicateTheModuleUsedOther =
    //     returnMapValue("childrenIndicateTheModuleUsedOther");
    trainingData.childrenIndicateTheModuleUsed = childModule;
    trainingData.childrenIndicateTheModuleUsedOther =
        otherChildModuleController.text;

    trainingData.whenDidYouReachOutToChildrenYear1 = childYearController.text;
    trainingData.whenDidYouReachOutToChildrenMonth1 = childMonthController.text;
    // listToString(listDidYouReachOutToChildrenMonth1);
    // trainingData.whenDidYouReachOutToChildrenYear2 = childYear2Controller.text;
    // trainingData.whenDidYouReachOutToChildrenMonth2 =
    //     listToString(listDidYouReachOutToChildrenMonth2);

    // trainingData.howManyAdultsDidYouTrainUsingArpanContent =
    //     int.tryParse(reachedAdultCountController.text);

    // trainingData.adultIndicateTheModulePptUsed =
    //     returnMapValue("adultIndicateTheModulePptUsed");
    // trainingData.adultIndicateTheModulePptUsedOther =
    //     returnMapValue("adultIndicateTheModulePptUsedOther");
    //getMonthYearData('adultMonthYear');
    trainingData.adultIndicateTheModulePptUsed = adultModule;
    trainingData.adultIndicateTheModulePptUsedOther =
        otherAdultModuleController.text;

    trainingData.whenDidYouReachOutToAdultsYear1 = adultYearController.text;
    trainingData.whenDidYouReachOutToAdultsMonth1 = adultMonthController.text;
    // listToString(listDidYouReachOutToAdultsMonth1);
    // trainingData.whenDidYouReachOutToAdultsYear2 = adultYear2Controller.text;
    // trainingData.whenDidYouReachOutToAdultsMonth2 =
    //     listToString(listDidYouReachOutToAdultsMonth2);

    trainingData.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy =
        returnMapValue("ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy");
    trainingData.ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther =
        returnMapValue("ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhyOther");
    trainingData.udiseCode = paricipentinfo.udiseCode;
    trainingData.state = paricipentinfo.stateId;
    trainingData.district = paricipentinfo.districtId;
    trainingData.block = paricipentinfo.blockId;
    trainingData.maleChild = reachedMaleChildrenCountController.text;
    trainingData.femaleChild = reachedFemaleChildrenCountController.text;
    // trainingData.otherChild = reachedOtherChildrenCountController.text;
    trainingData.parents = reachedParentsCountController.text;
    // trainingData.teachers = reachedTeachersCountController.text;
    trainingData.jointParticipant = selectedJointlyParticipant.entries
        .where((element) => element.value == true)
        .map((e) => e.key)
        .toList()
        .join(',');
    List<String> selectedGrades = gradeSelection.entries
        .where((entry) => entry.value) // Filter selected grades
        .map((entry) => entry.key) // Extract grade names
        .toList();
    List<String> gradeIds = teacherGradeList
        .where((grade) =>
            selectedGrades.contains(grade.teacherGrade)) // Match names
        .map((grade) => grade.id.toString()) // Extract grade IDs
        .toList();
    trainingData.grade = gradeIds.join(',');

    await DataProvider().saveIndirectTrainingData(trainingData);

    await uploadData();
  }

  // saveConfirmationPopup() async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       content: Text(
  //         LabelText.getText('submitconfirme'),
  //         textAlign: TextAlign.center,
  //         style: Styles.black145,
  //       ),
  //       actions: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
  //           children: [
  //             Expanded(
  //               child: InkWell(
  //                 child: Container(
  //                   height: 40.h,
  //                   child: Center(
  //                       child: Text(
  //                     LabelText.getText('yes'),
  //                     style: Styles.white146,
  //                   )),
  //                   decoration: BoxDecoration(
  //                       color: ColorConstants.defaultMaroon,
  //                       borderRadius: const BorderRadius.only(
  //                           topRight: Radius.circular(40),
  //                           topLeft: Radius.circular(5),
  //                           bottomLeft: Radius.circular(5),
  //                           bottomRight: Radius.circular(5))),
  //                 ),
  //                 onTap: () async {
  //                   Navigator.pop(context);
  //                   saveSurverData();
  //                 },
  //               ),
  //             ),
  //             Expanded(
  //                 child: InkWell(
  //               child: Container(
  //                 height: 40.h,
  //                 child: Center(
  //                     child: Text(
  //                  LabelText.getText('no'),
  //                   style: Styles.white146,
  //                 )),
  //                 decoration: BoxDecoration(
  //                     color: ColorConstants.greyButtonColor,
  //                     borderRadius: const BorderRadius.only(
  //                         topRight: Radius.circular(5),
  //                         topLeft: Radius.circular(5),
  //                         bottomLeft: Radius.circular(40),
  //                         bottomRight: Radius.circular(5))),
  //               ),
  //               onTap: () async {
  //                 Navigator.pop(context);
  //               },
  //             )),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  uploadData() async {
    await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
        secondFunc: () async {
          isDisposed = true;
          await Navigator.popAndPushNamed(
            context,
            RouteConstants.indirecttrainningRegList,
            arguments: [indirectData],
          );
        },
        func: () async {
          TrainingIndirectData regDetail = trainingData;
          List<TrainingIndirectData> regList = [];
          regList.add(trainingData);
          String jsonBatch = jsonEncode(regList);
          var responseBatch;

          if (trainingData.syncingDate != null &&
              trainingData.syncingDate!.isNotEmpty) {
            responseBatch = await TblTraningIndirectDataListModelApi()
                .putIndirecttrainingdata(postBody: jsonDecode(jsonBatch));
          } else {
            responseBatch = await TblTraningIndirectDataListModelApi()
                .postIndirecttrainingdata(postBody: jsonDecode(jsonBatch));
          }

          if (responseBatch.isSuccess) {
            String resBatchsession = responseBatch.response.toString();
            List<dynamic> data = jsonDecode(resBatchsession);
            if (data != null && data.isNotEmpty) {
              String dateTimeString = data[0]["SyncingDate"];
              DateTime dateTime = DateTime.now();
              if (dateTimeString != null && dateTimeString.isNotEmpty) {
                dateTime = DateTime.parse(dateTimeString);
              }
              String syncingDate = DateFormat('yyyy-MM-dd').format(dateTime);
              if (syncingDate.isNotEmpty) {
                regDetail.syncingDate = syncingDate;
                regDetail.IsEdited = 0;
                await DataProvider().saveIndirectTrainingData(regDetail);
              }
            }
            if (fileList.isNotEmpty) {
              var isUpload = await IndirectDataUploadImageAPI()
                  .postImagesToserver(
                      imageFiles: fileList, indirectDataGuid: indirectGUid);
              if (isUpload) {
                await DataProvider()
                    .updateFlagOfIndirectUploadImage(indirectGUid!);
              }
            }

            return LabelText.success;
          }
          return LabelText.uploadFailed;
        },
        goOnline: false,
        title: LabelText.pleaseWait,
      ),
    );
  }

  // void getMonthYearData(String key) {
  //   String year1 = '';
  //   String year2 = '';
  //   String month1 = '';
  //   String month2 = '';
  //   Map<String, bool> yearSet = {};
  //   Set<String> monthSet = {};
  //   List<String> strings = [];
  //   if (!_formdata.containsKey(key)) {
  //     return;
  //   } else {
  //     Map<String, bool> checkvalue = _formdata[key] as Map<String, bool>;
  //     checkvalue.forEach((key, value) {
  //       String yearVal = key.split('#')[0];
  //       String month = key.split('#')[1];
  //       if (yearVal == yearmonthList[0]) {
  //         year1 = yearVal;
  //         if (month1.length == 0) {
  //           month1 = month;
  //         } else {
  //           month1 = month1 + ',' + month;
  //         }
  //       } else {
  //         year2 = yearVal;
  //         if (month2.length == 0) {
  //           month2 = month;
  //         } else {
  //           month2 = month2 + ',' + month;
  //         }
  //       }
  //     });
  //   }
  //   if (key == 'childrenMonthYear') {
  //     trainingData.whenDidYouReachOutToChildrenYear1 = year1;
  //     trainingData.whenDidYouReachOutToChildrenMonth1 = month1;
  //     trainingData.whenDidYouReachOutToChildrenYear2 = year2;
  //     trainingData.whenDidYouReachOutToChildrenMonth2 = month2;
  //   }
  //   if (key == 'adultMonthYear') {
  //     trainingData.whenDidYouReachOutToAdultsYear1 = year1;
  //     trainingData.whenDidYouReachOutToAdultsMonth1 = month1;
  //     trainingData.whenDidYouReachOutToAdultsYear2 = year2;
  //     trainingData.whenDidYouReachOutToAdultsMonth2 = month2;
  //   }
  //   print('Year 1: $year1');
  //   print('Year 2: $year2');
  //   print('Month 1: $month1');
  //   print('Month 2: $month2');
  // }
  // Map<String, bool> generateStrings(
  //     String year1, String year2, String month1, String month2, String key) {
  //   if (year1 == null) {
  //     return {};
  //   }
  //   late Map<String, bool> checkvalue = {};
  //   //  List<String> strings = [];
  //   if (month1.contains(',')) {
  //     var month1List = month1.split(',');
  //     for (var element in month1List) {
  //       String keyval = '${year1}#${element}';
  //       checkvalue[keyval] = true;
  //     }
  //   } else if (month1 != null && month1.isNotEmpty) {
  //     String keyval = '${year1}#${month1}';
  //     checkvalue[keyval] = true;
  //   }
  //   if (month2.contains(',')) {
  //     var month1List = month2.split(',');
  //     for (var element in month1List) {
  //       String keyval = '${year2}#${element}';
  //       checkvalue[keyval] = true;
  //     }
  //   } else if (month2 != null && month2.isNotEmpty) {
  //     String keyval = '${year2}#${month2}';
  //     checkvalue[keyval] = true;
  //   }
  //   return checkvalue;
  // }

  String returnMapValue(String key) {
    if (_formdata.containsKey(key)) {
      return _formdata[key].toString();
    } else {
      return '';
    }
  }

  bool checkValidation() {
    if (!_formdata.containsKey('toWhomHaveYouReachedOutWithArpanContent')) {
      showerrorToast(
          '${LabelText.getText('reachedOutArpan')} ${LabelText.getText('mandatory')}');
      return false;
    } else if (((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '1' ||
            _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3')) &&
        // !_formdata.containsKey('childrenIndicateTheModuleUsed')) {
        childModule == null) {
      showerrorToast(
          '${LabelText.getText('reachedChildrenmodule')} ${LabelText.getText('mandatory')}');
      return false;
    } else if (((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '1' ||
            _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3')) &&
        gradeSelection.entries.every((element) => element.value != true)) {
      showerrorToast(
          '${LabelText.getText('selectGrade')} ${LabelText.getText('mandatory')}');
      return false;
    }
    // else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '1' ||
    //         _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3') &&
    //     (childMonthController.text == LabelText.getText('selectHere'))) {
    //   showerrorToast(
    //       '${LabelText.getText('yearMonthchildrenReachout')} ${LabelText.getText('mandatory')}');
    //   return false;
    // }
    else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '2' ||
            _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3') &&
        // !_formdata.containsKey('adultIndicateTheModulePptUsed')) {
        adultModule == null) {
      showerrorToast(
          '${LabelText.getText('reachedAdultCount')} ${LabelText.getText('mandatory')}');
      return false;
    } else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '2' ||
            _formdata['toWhomHaveYouReachedOutWithArpanContent'] == '3') &&
        (adultMonthController.text == LabelText.getText('selectHere'))) {
      showerrorToast(
          '${LabelText.getText('yearMonthAdultsReachout')} ${LabelText.getText('mandatory')}');
      return false;
    } else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] != '4') &&
        adultalonjointlyController.text.toLowerCase() == 'jointly' &&
        filteredParticipantList.isNotEmpty &&
        selectedJointlyParticipant.entries
                .where((element) => element.value == true)
                .toList()
                .length <
            _maxSelection) {
      showerrorToast('Please select at least $_maxSelection participants');
      return false;
    } else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] != '4') &&
        adultalonjointlyController.text.toLowerCase() == 'jointly' &&
        filteredParticipantList.isNotEmpty &&
        !jointlyConfirm) {
      showerrorToast('Please confirm joint participants');
      return false;
    } else if ((_formdata['toWhomHaveYouReachedOutWithArpanContent'] == '4') &&
        !_formdata
            .containsKey('ifYouHaveChosenNotYetWithNoOnePleaseIndicateWhy')) {
      showerrorToast(
          '${LabelText.getText('reachedNonone')} ${LabelText.getText('mandatory')}');
      return false;
    } else {
      return true;
    }
  }

  showerrorToast(String error) {
    Toast.show(error,
        duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
  }
}
