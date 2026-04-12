import 'dart:convert';
import 'package:arpan/models/tbl_trainner_list.dart';
import 'package:arpan/screens/training/training_batch_creation.dart';
import 'package:arpan/screens/training/training_batch_session_creation.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../api/hand_holding_apis.dart';
import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../database/dataProvider.dart';
import '../../models/custom_model.dart';
import '../../models/training_hand_holding_module_model.dart';
import '../../table_model/tbl_block_model.dart';
import '../../table_model/tbl_district_model.dart';
import '../../table_model/tbl_master_model.dart';
import '../../table_model/tbl_state_model.dart';
import '../../table_model/tbl_training_hand_holding.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../utils/log_files.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/registration_drop_down.dart';
import '../../widgets/registration_text_field.dart';

class HandHoldingRegistration extends StatefulWidget {
  const HandHoldingRegistration({Key? key}) : super(key: key);

  @override
  State<HandHoldingRegistration> createState() =>
      _HandHoldingRegistrationState();
}

class _HandHoldingRegistrationState extends State<HandHoldingRegistration> {
  bool isDisposed = false;
  var mainTrainingSchedule = TblTrainingSchedule();
  var handholding = TblTrainingHandHolding();
  var userInfo;

  TextEditingController interventionController = TextEditingController();
  TextEditingController typeofSessionController = TextEditingController();
  TextEditingController modeOfGroupMeetingController = TextEditingController();
  TextEditingController handholdingdateController = TextEditingController();
  TextEditingController implementedPSEcontroller = TextEditingController();

  TextEditingController facilitatorNameController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  // TextEditingController otherStateController = TextEditingController();
  // TextEditingController otherDistrictController = TextEditingController();
  // TextEditingController otherBlockController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String handholdingDate = '';
  List<TblMasterModel> handHoldingInterventionModelList = [];
  List<TblMasterModel> modeGroupMeetingModelList = [];
  List<String> handHoldingInterventionList = [];
  List<String> modeGroupMeetingList = [];
  List<TblMasterModel> handHoldingSessionParticipantsModelList = [];
  List<String> handHoldingSessionParticipantsList = [];
  List<TblMasterModel> handHoldingTopicsCoveredModelList = [];
  List<String> handHoldingTopicsCoveredList = [];
  List<String> implementedPSElist = [];

  String topicCovered = '';
  // String observerName = '';
  List<dynamic> dataSourceTopic = [];
  List<dynamic> dataSourceTrainner = [];
  List<TrainingHandHoldingModuleData> trainingModulelist = [];
  List<TrainerModel> trainerModulelist = [];

  List<TblStateModel> states = [];
  List<TblDistrictModel> districts = [];
  List<BlockDatum> blockList = [];
  String stateVal = '';
  String distictValue = '';
  String blockValue = '';

  var trainingHandHoldingModuleData = <TrainingHandHoldingModuleData>[];
  var childtrainingHandHoldingModuleData = <TrainingHandHoldingModuleData>[];

  var selectedModule = [];
  var myModelTrainner = <TrainerModel>[];
  var myModelTopic = <MyModel>[];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    LabelText.getLang(1);
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data[0];
        handholding = data[1] ?? TblTrainingHandHolding();
      }
      userInfo = await UserInfo().getUserCredentials();
      await setDropDownValue();

      await setData();
      setState(() {
        isDisposed = true;
      });
    }
  }

  DateTime parseFlexibleDate(String input) {
    final formats = [
      DateFormat("M/d/yyyy h:mm:ss a"),
      DateFormat("yyyy-MM-dd"),
    ];

    for (var format in formats) {
      try {
        return format.parseStrict(input);
      } catch (_) {
        // Try next format
      }
    }

    // If no format matched
    return DateTime.now();
  }

  setData() {
    if (handholding.handHoldingGuid != null &&
        handholding.handHoldingGuid!.isNotEmpty) {
      String outputDateString = '';
      if (handholding.handHoldingDate!.isNotEmpty) {
        DateTime inputDate =
            // DateFormat("yyyy-MM-dd").parse(handholding.handHoldingDate!);
            parseFlexibleDate(handholding.handHoldingDate!);
        outputDateString = DateFormat("dd/MM/yyyy").format(inputDate);
      }
      handholdingdateController.text = outputDateString;

      interventionController.text = handHoldingInterventionModelList
          .where((element) =>
              element.value == handholding.handHoldingIntervention!)
          .first
          .text;
      try {
        typeofSessionController.text = handHoldingSessionParticipantsModelList
            .where(
                (element) => element.value == handholding.sessionParticipant!)
            .first
            .text;
      } catch (e) {
        typeofSessionController.text = "";
      }
      try {
        stateVal = handholding.stateId ?? '';
        distictValue = handholding.districtId ?? '';
        blockValue = handholding.blockId ?? '';
        implementedPSEcontroller.text =
            handholding.attendingPseArpanTraining ?? LabelText.pleaseSelect;
        modeOfGroupMeetingController.text = modeGroupMeetingModelList
            .where(
                (element) => element.value == handholding.modeOfGroupMeeting!)
            .first
            .text;
      } catch (e) {}

      topicCovered = handholding.topicsCovered!;
      //  facilitatorNameController.text = handholding.facilitatorName!;
      trainerModulelist = getListTrainner(handholding.observer!);
      trainingModulelist = getListFromId(handholding.Module!);
      try {
        String sessionId = handHoldingSessionParticipantsModelList
            .where((element) => element.text == typeofSessionController.text)
            .first
            .value;

        childtrainingHandHoldingModuleData = trainingHandHoldingModuleData
            .where((element) => element.TypeOfSession == sessionId)
            .toList();
      } catch (e) {}

      fillModule();

      remarkController.text = handholding.remark!;
      otherController.text = handholding.other!;
    }
  }

  setDropDownValue() async {
    states = await DataProvider().getAllState();
    districts = await DataProvider().getAllDistrict();
    blockList = await DataProvider().getAllBlock();
    // states.add(
    //     TblStateModel(stateId: 9999999, stateName: LabelText.getText('Other')));
    // districts.add(TblDistrictModel(
    //     stateId: 9999999,
    //     districtId: 9999999,
    //     districtName: LabelText.getText('Other')));
    // blockList.add(BlockDatum(
    //     stateId: 9999999,
    //     districtId: '9999999',
    //     id: 9999999,
    //     blockName: LabelText.getText('Other')));

    handHoldingInterventionModelList =
        await DataProvider().getMastrerListData('HandHoldingIntervention');
    handHoldingInterventionList.clear();
    handHoldingInterventionList.add(LabelText.selectHere);
    for (var element in handHoldingInterventionModelList) {
      handHoldingInterventionList.add(element.text);
    }

    modeGroupMeetingModelList = await DataProvider()
        .getMastrerListData('HandHoldingModeofGroupMeeting');
    modeGroupMeetingList.clear();
    modeGroupMeetingList.add(LabelText.selectHere);
    for (var element in modeGroupMeetingModelList) {
      modeGroupMeetingList.add(element.text);
    }

    implementedPSElist.clear();
    implementedPSElist = [LabelText.pleaseSelect, LabelText.yes, LabelText.no];

    handHoldingSessionParticipantsModelList = await DataProvider()
        .getMastrerListData('HandHoldingSessionParticipants');
    handHoldingSessionParticipantsList.clear();
    handHoldingSessionParticipantsList.add(LabelText.selectHere);
    for (var element in handHoldingSessionParticipantsModelList) {
      handHoldingSessionParticipantsList.add(element.text);
    }

    handHoldingTopicsCoveredModelList =
        await DataProvider().getMastrerListData('HandHoldingTopicsCovered');

    dataSourceTopic.clear();
    myModelTopic.clear();
    if (handHoldingTopicsCoveredModelList != null) {
      for (var i = 0; i < handHoldingTopicsCoveredModelList.length; i++) {
        myModelTopic.add(MyModel(
            id: handHoldingTopicsCoveredModelList[i].value!.toString(),
            value: handHoldingTopicsCoveredModelList[i].text.toString()));

        dataSourceTopic.add({
          'display': handHoldingTopicsCoveredModelList[i].text.toString(),
          'value': handHoldingTopicsCoveredModelList[i].value.toString(),
        });
      }
    }
    myModelTrainner = await DataProvider().getTrainerList();
    fillTrainnerModule();

    trainingHandHoldingModuleData =
        await DataProvider().getTrainingHandHoldingModuleList();
    childtrainingHandHoldingModuleData = trainingHandHoldingModuleData;
    fillModule();
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

  List<MultiSelectItem<TrainerModel>> _trainnerItems = [];
  fillTrainnerModule() {
    _trainnerItems = myModelTrainner
        .map((item) => MultiSelectItem<TrainerModel>(item, item.name!))
        .toList();
  }

  List<MultiSelectItem<TrainingHandHoldingModuleData>> _items = [];
  fillModule() {
    _items = childtrainingHandHoldingModuleData
        .map((item) =>
            MultiSelectItem<TrainingHandHoldingModuleData>(item, item.Module!))
        .toList();
  }

  // List of available options

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
                      context,
                      RouteConstants.handholdingreglist,
                      arguments: mainTrainingSchedule,
                    );
                  },
                ),
                Text(
                  LabelText.handholdingReg,
                  style: Styles.red164
                      .copyWith(color: ColorConstants.defaultMaroon),
                )
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
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Card(
                              color: Color(0xffFFF7F7),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Color(0xff707070),
                                    width: 1), // set the border color and width
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
                                          mainTrainingSchedule.year ?? '',
                                          "assets/dateBetween.png"),
                                      const Divider(color: Color(0xff707070)),
                                      createRowWidget(
                                          LabelText.trainingName,
                                          mainTrainingSchedule.trainingName ??
                                              '',
                                          "assets/trainingName.png"),
                                      const Divider(color: Color(0xff707070)),
                                      createRowWidget(
                                          LabelText.tog,
                                          mainTrainingSchedule.typeOfGroup ??
                                              '',
                                          "assets/theme.png"),
                                    ]),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            AutoSizeText(
                              LabelText.handholdingdate,
                              wrapWords: false,
                              style: Styles.grey12500,
                              maxLines: 10,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                key: Key(LabelText.handholdingdate),
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: handholdingdateController,
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  _selectDate(context);
                                  //update(1);
                                },
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintText: 'Select date',
                                  hintStyle: Styles.grey124,
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
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (handHoldingInterventionList.isNotEmpty) ...[
                              RegistrationDropDown(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select ${LabelText.handholdingIntervention}';
                                  } else {
                                    return null;
                                  }
                                },
                                initialValue: LabelText.selectHere,
                                items: handHoldingInterventionList,
                                textEditingController: interventionController,
                                title: LabelText.handholdingIntervention,
                                onChanged: (value) {
                                  try {
                                    if (handHoldingInterventionList
                                            .isNotEmpty &&
                                        value != LabelText.selectHere) {
                                      if (value != "3") {
                                        trainingModulelist = [];
                                        typeofSessionController.text = '';
                                      }

                                      //
                                      //  _formdata['gender'] = value.toString();
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
                            if (interventionController.text
                                .contains("Group Meeting")) ...[
                              RegistrationDropDown(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select ${LabelText.modeOfGroupMeeting}';
                                  } else {
                                    return null;
                                  }
                                },
                                initialValue: LabelText.selectHere,
                                items: modeGroupMeetingList,
                                textEditingController:
                                    modeOfGroupMeetingController,
                                title: LabelText.modeOfGroupMeeting,
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                              if (modeOfGroupMeetingController.text
                                  .contains("In-Person")) ...[
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
                                // if (stateVal == '9999999') ...[
                                //   const SizedBox(height: 12),
                                //   RegistrationTextField(
                                //     subTitle: LabelText.getText('stateOther'),
                                //     decoration: const InputDecoration(
                                //         border: InputBorder.none),
                                //     validator: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         return LabelText.getText('pleaseenter');
                                //       }
                                //       return null;
                                //     },
                                //     textEditingController: otherStateController,
                                //     title: LabelText.getText('stateOther'),
                                //     onChanged: (value) {
                                //       if (kDebugMode) {
                                //         print(value);
                                //       }
                                //     },
                                //   ),
                                // ],
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
                                                    (element.stateId
                                                                .toString() ==
                                                            stateVal ||
                                                        element.stateId ==
                                                            9999999))
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
                                // if (distictValue == '9999999') ...[
                                //   const SizedBox(height: 12),
                                //   RegistrationTextField(
                                //     subTitle:
                                //         LabelText.getText('districtOther'),
                                //     decoration: const InputDecoration(
                                //         border: InputBorder.none),
                                //     validator: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         return LabelText.getText('pleaseenter');
                                //       }
                                //       return null;
                                //     },
                                //     textEditingController:
                                //         otherDistrictController,
                                //     title: LabelText.getText('districtOther'),
                                //     onChanged: (value) {
                                //       if (kDebugMode) {
                                //         print(value);
                                //       }
                                //     },
                                //   ),
                                // ],
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
                                                          (element
                                                                      .stateId
                                                                      .toString() ==
                                                                  stateVal ||
                                                              element.stateId ==
                                                                  9999999) &&
                                                          (element.districtId
                                                                      .toString() ==
                                                                  distictValue ||
                                                              element.districtId ==
                                                                  '9999999') &&
                                                          element.id
                                                                  .toString() ==
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
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                            value: e.blockName,
                                                            child: Text(
                                                              e.blockName!,
                                                              style: Styles
                                                                  .grey12500,
                                                            )))
                                                    .toList()
                                                : null,
                                            onChanged: (val) async {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              // var idval = val;
                                              blockValue = blockList
                                                  .where((element) =>
                                                      element.blockName! ==
                                                          val &&
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
                                // if (blockValue == '9999999') ...[
                                //   const SizedBox(height: 12),
                                //   RegistrationTextField(
                                //     subTitle: LabelText.getText('blockOther'),
                                //     decoration: const InputDecoration(
                                //         border: InputBorder.none),
                                //     validator: (value) {
                                //       if (value == null || value.isEmpty) {
                                //         return LabelText.getText('pleaseenter');
                                //       }
                                //       return null;
                                //     },
                                //     textEditingController: otherBlockController,
                                //     title: LabelText.getText('blockOther'),
                                //     onChanged: (value) {
                                //       if (kDebugMode) {
                                //         print(value);
                                //       }
                                //     },
                                //   ),
                                // ]
                              ]
                            ],
                            if (interventionController.text
                                .contains("Observation")) ...{
                              if (handHoldingSessionParticipantsList
                                  .isNotEmpty) ...[
                                RegistrationDropDown(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select ${LabelText.typeofSession}';
                                    } else {
                                      return null;
                                    }
                                  },
                                  initialValue: LabelText.selectHere,
                                  items: handHoldingSessionParticipantsList,
                                  textEditingController:
                                      typeofSessionController,
                                  title: LabelText.typeofSession,
                                  onChanged: (value) {
                                    try {
                                      if (handHoldingSessionParticipantsList
                                              .isNotEmpty &&
                                          value != LabelText.selectHere) {
                                        String sessionId =
                                            handHoldingSessionParticipantsModelList
                                                .where((element) =>
                                                    element.text ==
                                                    typeofSessionController
                                                        .text)
                                                .first
                                                .value;

                                        childtrainingHandHoldingModuleData =
                                            trainingHandHoldingModuleData
                                                .where((element) =>
                                                    element.TypeOfSession ==
                                                    sessionId)
                                                .toList();

                                        trainingModulelist = [];

                                        fillModule();
                                        //
                                        //  _formdata['gender'] = value.toString();
                                        setState(() {});
                                      }
                                    } catch (error, stackTrace) {
                                      logError(error, stackTrace);
                                    }
                                  },
                                ),
                              ],
                              SizedBox(
                                height: 5.h,
                              ),
                              if (childtrainingHandHoldingModuleData
                                  .isNotEmpty) ...[
                                SizedBox(height: 10.h),
                                Padding(
                                  key: Key('Module'),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Container(
                                    // height: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xff707070), width: 1),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x4d000000),
                                          offset: Offset(0.0, 1.0),
                                          blurRadius: 3.0,
                                        ),
                                      ], //border of dropdown button
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: MultiSelectDialogField<
                                        TrainingHandHoldingModuleData>(
                                      searchable: true,
                                      initialValue: trainingModulelist,
                                      items: _items,
                                      title: Text("Module"),
                                      buttonText: Text(
                                        "Module",
                                      ),
                                      onConfirm: (results) {
                                        trainingModulelist = results;
                                        //_selectedAnimals = results;
                                      },
                                      onSaved: (results) {
                                        print(results);
                                        //_selectedAnimals = results;
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              SizedBox(
                                height: 10.h,
                              ),
                            },
                            if (interventionController.text
                                .contains("Mentoring Calls")) ...[
                              RegistrationDropDown(
                                subTitle: LabelText.implementedPSEafterTraining,
                                validator: (value) {
                                  if (value == null || value == '0') {
                                    return 'Please select ${LabelText.implementedPSEafterTraining}';
                                  } else {
                                    return null;
                                  }
                                },
                                initialValue: LabelText.pleaseSelect,
                                textEditingController: implementedPSEcontroller,
                                items: implementedPSElist,
                                title: LabelText.implementedPSEafterTraining,
                                onChanged: (value) {
                                  if (value == null) {
                                    // attendanceBeforeindex = 0;
                                  } else {
                                    // attendanceBeforeindex = int.parse(value);
                                  }
                                },
                              ),
                            ],
                            /*   Padding(
                              padding: const EdgeInsets.all(10),
                              child: RegistrationTextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    iconColor: Color(0xff9E9E9E)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter ${LabelText.facilitatorName}';
                                  }
                                  return null;
                                },
                                textEditingController: facilitatorNameController,
                                title: LabelText.facilitatorName,
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                            ),
                            */
                            SizedBox(
                              height: 10.h,
                            ),
                            if (_trainnerItems.isNotEmpty) ...[
                              Padding(
                                key: Key('trainner'),
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  // height: 40.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xff707070), width: 1),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x4d000000),
                                        offset: Offset(0.0, 1.0),
                                        blurRadius: 3.0,
                                      ),
                                    ], //border of dropdown button
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: MultiSelectDialogField<TrainerModel>(
                                    searchable: true,
                                    initialValue: trainerModulelist,
                                    items: _trainnerItems,
                                    title: Text(LabelText.responsibleperson),
                                    buttonText: Text(
                                      LabelText.responsibleperson,
                                    ),
                                    onConfirm: (results) {
                                      trainerModulelist = results;
                                      //_selectedAnimals = results;
                                    },
                                    onSaved: (results) {
                                      print(results);
                                      //_selectedAnimals = results;
                                    },
                                  ),
                                ),
                              ),
                            ],
                            SizedBox(
                              height: 5.h,
                            ),
                            RegistrationTextField(
                              // isTitleAnimated: false,

                              subTitle: 'Type here',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${LabelText.remark}';
                                }
                                return null;
                              },
                              textEditingController: remarkController,
                              title: LabelText.remark,
                              maxlength: 500,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            if (false) ...{
                              RegistrationTextField(
                                subTitle: 'Type here',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter ${LabelText.other}';
                                  }
                                  return null;
                                },
                                textEditingController: otherController,
                                title: LabelText.other,
                                maxlength: 500,
                                onChanged: (value) {
                                  print(value);
                                },
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                            }
                          ])),
                    ))),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CurvedButton(
                    buttonTitle: LabelText.submit,
                    style: Styles.white146,
                    buttonColor: ColorConstants.defaultMaroon,
                    height: 35.h,
                    onPressed: () async {
                      //  bool isSaved = await SaveData();
                      if (handholdingdateController.text == null ||
                          handholdingdateController.text.isEmpty) {
                        Toast.show('${LabelText.handholdingdate} is mandatory',
                            duration: 3,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);
                        return false;
                      } else if (trainerModulelist == null ||
                          trainerModulelist.isEmpty) {
                        Toast.show(
                            '${LabelText.responsibleperson} is mandatory',
                            duration: 3,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);

                        return false;
                      }
                      if (_formKey.currentState!.validate()) {
                        await SaveData();
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CurvedGreyButton(
                    buttonTitle: LabelText.cancel, style: Styles.white146,
                    // buttonColor: Color(0xff898989),
                    height: 35.h,
                    onPressed: () async {
                      isDisposed = true;
                      await Navigator.popAndPushNamed(
                        context,
                        RouteConstants.handholdingreglist,
                        arguments: mainTrainingSchedule,
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void _selectDate(BuildContext context) async {
    var newSelectedDate = await showDatePicker(
        locale: Locale(
          'en',
          '',
        ),
        context: context,
        firstDate: DateTime(2000, 1),
        initialDate: _selectedDate ?? DateTime.now(),
        lastDate: DateTime(2100, 1));

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      handholdingDate = newSelectedDate.toString();

      handholdingdateController
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: handholdingdateController.text.length,
            affinity: TextAffinity.upstream));
      // update(1);
    }
  }

  List returnCheckVal(String val) {
    List<String> allData = [];
    if (val != null && val.isNotEmpty) {
      if (val.contains(',')) {
        allData = val.split(',');
      } else {
        allData.add(val);
      }
    }

    return allData;
  }

  String checkValue(List value) {
    String valStr = '';
    for (int i = 0; i < value.length; i++) {
      if (valStr.length == 0) {
        valStr = value[i];
      } else {
        valStr = valStr + ',' + value[i];
      }
    }
    return valStr;
  }

  String retunValueFromId(List<MyModel> listval, String ids) {
    if (listval.isEmpty || ids.isEmpty) {
      return '';
    }
    String names = '';
    if (ids.contains(',')) {
      var allId = ids.split(',');
      for (int i = 0; i < allId.length; i++) {
        var value = listval
            .where((element) =>
                element.id!.toLowerCase() == allId[i].toLowerCase())
            .first
            .value!;
        if (names.isNotEmpty) {
          names = names + ',' + value;
        } else {
          names = value;
        }
      }
    } else {
      try {
        names = listval
            .where((element) => element.id!.toLowerCase() == ids.toLowerCase())
            .first
            .value!;
      } catch (e) {}
    }
    return names;
  }

  List<TrainingHandHoldingModuleData> getListFromId(String ids) {
    List<TrainingHandHoldingModuleData> dataList = [];
    if (ids.isEmpty) {
      return [];
    } else if (ids.contains(',')) {
      var idarr = ids.split(',');

      for (var item in idarr) {
        TrainingHandHoldingModuleData data = TrainingHandHoldingModuleData();
        try {
          data = trainingHandHoldingModuleData
              .where((element) => element.ID.toString() == item)
              .first;
          dataList.add(data);
        } catch (error, stackTrace) {
          logError(error, stackTrace);
        }
      }
    } else {
      TrainingHandHoldingModuleData data = TrainingHandHoldingModuleData();
      try {
        data = trainingHandHoldingModuleData
            .where((element) => element.ID.toString() == ids)
            .first;
        dataList.add(data);
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    return dataList;
  }

  String retunModuleIds(List<TrainingHandHoldingModuleData> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.ID.toString();

      if (idsValue.length == 0) {
        idsValue = data;
      } else {
        idsValue = idsValue + ',' + data;
      }
    }
    return idsValue;
  }

  String retunModuleName(List<TrainingHandHoldingModuleData> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.Module.toString();

      if (idsValue.length == 0) {
        idsValue = data;
      } else {
        idsValue = idsValue + ',' + data;
      }
    }
    return idsValue;
  }

  List<TrainerModel> getListTrainner(String ids) {
    List<TrainerModel> dataList = [];
    if (ids.isEmpty) {
      return [];
    } else if (ids.contains(',')) {
      var idarr = ids.split(',');

      for (var item in idarr) {
        TrainerModel data = TrainerModel();
        try {
          data = myModelTrainner
              .where((element) => element.empID.toString() == item)
              .first;
          dataList.add(data);
        } catch (error, stackTrace) {
          logError(error, stackTrace);
        }
      }
    } else {
      TrainerModel data = TrainerModel();
      try {
        data = myModelTrainner
            .where((element) => element.empID.toString() == ids)
            .first;
        dataList.add(data);
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    return dataList;
  }

  String retunTrainnerIds(List<TrainerModel> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.empID.toString();

      if (idsValue.length == 0) {
        idsValue = data;
      } else {
        idsValue = idsValue + ',' + data;
      }
    }
    return idsValue;
  }

  String retunTrainerName(List<TrainerModel> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.name.toString();

      if (idsValue.length == 0) {
        idsValue = data;
      } else {
        idsValue = idsValue + ',' + data;
      }
    }
    return idsValue;
  }

  SaveData() async {
    handholding ??= TblTrainingHandHolding();
    if (handholding.handHoldingGuid == null ||
        handholding.handHoldingGuid!.isEmpty) {
      handholding.handHoldingGuid = Uuid().v1();
    }
    handholding.scheduleGuid = mainTrainingSchedule.scheduleGuid;
    handholding.year = mainTrainingSchedule.year;
    handholding.trainingName = mainTrainingSchedule.trainingName;

    String outputDateString = '';
    if (handholdingdateController.text.isNotEmpty) {
      DateTime inputDate =
          DateFormat("dd/MM/yyyy").parse(handholdingdateController.text);
      outputDateString = DateFormat("yyyy-MM-dd").format(inputDate);
    }
    handholding.handHoldingDate = outputDateString;
    handholding.handHoldingIntervention = handHoldingInterventionModelList
        .where((element) => element.text == interventionController.text)
        .first
        .value;
    if (interventionController.text.contains("Group Meeting")) {
      handholding.modeOfGroupMeeting = modeGroupMeetingModelList
          .where((element) => element.text == modeOfGroupMeetingController.text)
          .first
          .value;
      if (modeOfGroupMeetingController.text == "In-Person") {
        handholding.stateId = stateVal;
        handholding.districtId = distictValue;
        handholding.blockId = blockValue;
      }
    } else if (interventionController.text.contains("Mentoring Calls")) {
      handholding.attendingPseArpanTraining = implementedPSEcontroller.text;
    }
    handholding.topicsCovered = topicCovered;

    handholding.Module = retunModuleIds(trainingModulelist);
    handholding.ModuleName = retunModuleName(trainingModulelist);

    handholding.topicsCoveredName =
        retunValueFromId(myModelTopic, topicCovered);

    // handholding.facilitatorName = facilitatorNameController.text;
    handholding.facilitatorName = "";
    handholding.observer = retunTrainnerIds(trainerModulelist);
    handholding.observerName = retunTrainerName(trainerModulelist);
    try {
      handholding.sessionParticipant = handHoldingSessionParticipantsModelList
          .where((element) => element.text == typeofSessionController.text)
          .first
          .value;
    } catch (e) {
      handholding.sessionParticipant = "";
    }

    handholding.remark = remarkController.text;
    handholding.other = otherController.text;
    handholding.createdBy = userInfo['email'].toString();
    handholding.createdOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
    handholding.updatedBy = userInfo['email'].toString();
    handholding.updatedOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
    handholding.active = 1;
    handholding.isEdited = 1;
    await DataProvider().saveHandHoldingData(handholding);

    uploadData();
  }

  uploadData() async {
    try {} catch (error, stackTrace) {
      logError(error, stackTrace);
    }
    await showCustomDialog(
      context,
      widget: ShowAlertDialogBox(
        secondFunc: () async {
          isDisposed = true;
          await Navigator.popAndPushNamed(
            context,
            RouteConstants.handholdingreglist,
            arguments: mainTrainingSchedule,
          );
        },
        func: () async {
          TblTrainingHandHolding regDetail = handholding;
          List<TblTrainingHandHolding> regList = [];
          regList.add(handholding);
          String jsonBatch = jsonEncode(regList);
          var responseBatch;

          if (handholding.SyncingDate != null &&
              handholding.SyncingDate!.isNotEmpty) {
            responseBatch = await HandHoldinApi()
                .putHandHoldinData(postBody: jsonDecode(jsonBatch));
          } else {
            responseBatch = await HandHoldinApi()
                .postHandHoldinData(postBody: jsonDecode(jsonBatch));
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
                regDetail.SyncingDate = syncingDate;
                regDetail.isEdited = 0;
                await DataProvider().saveHandHoldingData(regDetail);
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
}
