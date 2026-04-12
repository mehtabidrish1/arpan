import 'dart:convert';
import 'dart:math';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/screens/training/training_batch_session_creation.dart';
import 'package:arpan/utils/validate.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../api/training_reg_api.dart';
import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../models/custom_model.dart';
import '../../models/tbl_trainner_list.dart';
import '../../table_model/tbl_block_model.dart';
import '../../table_model/tbl_district_model.dart';
import '../../table_model/tbl_state_model.dart';
import '../../table_model/tbl_training_registration_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../utils/log_files.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/registration_text_field.dart';

class TrainingBatchCreation extends StatefulWidget {
  const TrainingBatchCreation({Key? key}) : super(key: key);

  @override
  State<TrainingBatchCreation> createState() => _TrainingBatchCreationState();
}

class _TrainingBatchCreationState extends State<TrainingBatchCreation> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var myModel = <MyModel>[];
  var myModelTopic = <MyModel>[];
  var myModelTrainner = <MyModel>[];
  var selectedTrainer = <MyModel>[];
  // var myModelEstablishmentName = <MyModel>[];
  TextEditingController myController = TextEditingController();
  TextEditingController batchnoController = TextEditingController();
  TextEditingController batchVenueController = TextEditingController();

  List<dynamic> dataSourceTopic = [];
  // List<dynamic> dataSourceTrainner = [];
  // List<dynamic> dataSourceEstablishmentName = [];
  List<TrainerModel> trainerModulelist = [];

  // String moiVal = '';
  // String topicCovered = '';
  // String nameOfTrainner = '';
  String participantEstablishmentName = '';

  TblTrainingRegistration traingbatch = TblTrainingRegistration();
  var userInfo;
  DateTime _selectedDate = DateTime.now();
  String trainingDate = '';
  String stateVal = '';
  String distictValue = '';
  String blockValue = '';
  int? noInternet = 0;

  List<TblStateModel> states = [];
  List<TblDistrictModel> districts = [];
  List<BlockDatum> blocks = [];
  var myModelTrainnerList = <TrainerModel>[];

  //List<String> _stateNames = [];

  // Map of districts by state
  // Map<int, List<TblDistrictModel>> _districtsByState = {};
  bool isDisposed = false;
  @override
  void initState() {
    super.initState();
    LabelText.getLang(1);
  }
  // Selected state and district

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data[0];
        traingbatch = data[1] ?? TblTrainingRegistration();
      }
      _selectedDate = DateTime.parse(mainTrainingSchedule.firstDate!);
      userInfo = await UserInfo().getUserCredentials();
      myModel = Validate.ConvertIDValueIntoList(
          mainTrainingSchedule.mediumofInstruction!,
          mainTrainingSchedule.mediumofInstructionName!);
      myModelTopic = Validate.ConvertIDValueIntoList(
          mainTrainingSchedule.topicsCovered!,
          mainTrainingSchedule.topicsCoveredName!);
      myModelTrainner = Validate.ConvertIDValueIntoList(
          mainTrainingSchedule.trainer!, mainTrainingSchedule.trainerName!);
      // myModelEstablishmentName = Validate.ConvertIDValueIntoList(
      //     mainTrainingSchedule.participantEstablishment!,
      //     mainTrainingSchedule.participantEstablishmentName!);

      states = await DataProvider().getAllState();
      stateVal = mainTrainingSchedule.stateId.toString();
      String districtIdString = mainTrainingSchedule.districtId.toString();
      List<int> targetDistrictIds =
          districtIdString.split(',').map((id) => int.parse(id)).toList();

      var districtsAll = await DataProvider().getAllDistrict();
      districts = districtsAll.where((district) {
        return (targetDistrictIds.contains(district.districtId) &&
            district.stateId == int.tryParse(stateVal));
      }).toList();

      String blockIdString = mainTrainingSchedule.blockId.toString();
      List<int> targetBlockIds =
          blockIdString.split(',').map((id) => int.parse(id)).toList();

      var blockAll = await DataProvider().getAllBlock();
      blocks = blockAll.where((block) {
        return (targetBlockIds.contains(block.id));
      }).toList();
      myModelTrainnerList = await DataProvider().getTrainerList();
      fillTrainnerModule();
      await setAllData();

      dataSourceTopic.clear();
      if (myModelTopic != null) {
        for (var i = 0; i < myModelTopic.length; i++) {
          dataSourceTopic.add({
            'display': myModelTopic[i].value,
            'value': myModelTopic[i].id.toString(),
          });
        }
      }

      // dataSourceTrainner.clear();
      // if (myModelTrainner != null) {
      //   for (var i = 0; i < myModelTrainner.length; i++) {
      //     dataSourceTrainner.add({
      //       'display': myModelTrainner[i].value,
      //       'value': myModelTrainner[i].id.toString(),
      //     });
      //   }
      // }
      // dataSourceEstablishmentName.clear();
      // if (myModelEstablishmentName != null) {
      //   for (var i = 0; i < myModelEstablishmentName.length; i++) {
      //     dataSourceEstablishmentName.add({
      //       'display': myModelEstablishmentName[i].value,
      //       'value': myModelEstablishmentName[i].id.toString(),
      //     });
      //   }
      // }

      if (mounted) {
        setState(() {
          isDisposed = true;
        });
      }
    }
  }

  List<MultiSelectItem<TrainerModel>> _trainnerItems = [];
  fillTrainnerModule() {
    _trainnerItems = myModelTrainnerList
        .map((item) => MultiSelectItem<TrainerModel>(item, item.name!))
        .toList();
  }

  setAllData() async {
    if (traingbatch == null ||
        traingbatch.scheduleGuid == null ||
        traingbatch.scheduleGuid!.isEmpty) {
      traingbatch = TblTrainingRegistration();
    } else {
      trainerModulelist = getListTrainner(traingbatch.observer!);

      var traingDate = traingbatch.trainingDate;

      participantEstablishmentName = traingbatch.participantEstablishment!;
      stateVal = traingbatch.stateId!;
      distictValue = traingbatch.districtId!;
      blockValue = traingbatch.Block!;
      noInternet = traingbatch.noInternet;
      //  moiVal = traingbatch.mediumOfInstruction!;
      //  topicCovered = traingbatch.topicsCovered!;
      // nameOfTrainner = traingbatch.trainer!;
      if (traingbatch.trainer != null && traingbatch.trainer!.isNotEmpty) {
        selectedTrainer = getTrainerfromIds(traingbatch.trainer!);
      }
      myController.text = traingDate!;
      batchVenueController.text = traingbatch.batchVenue ?? '';
      String outputDateString = '';
      if (traingDate.isNotEmpty) {
        DateTime inputDate = DateFormat("yyyy-MM-dd").parse(traingDate!);
        outputDateString = DateFormat("dd/MM/yyyy").format(inputDate);
      }
      myController.text = outputDateString!;

      batchnoController.text = traingbatch.batchNo ?? '';
    }
    //  setState(() {});
  }

  List<MyModel> getTrainerfromIds(String ids) {
    List<MyModel> dataList = [];
    if (ids.isEmpty) {
      return [];
    } else if (ids.contains(',')) {
      var idarr = ids.split(',');

      for (var item in idarr) {
        var data = MyModel();
        try {
          data = myModelTrainner
              .where((element) => element.id.toString() == item)
              .first;
          dataList.add(data);
        } catch (error, stackTrace) {
          logError(error, stackTrace);
        }
      }
    } else {
      var data = MyModel();
      try {
        data = myModelTrainner
            .where((element) => element.id.toString() == ids)
            .first;
        dataList.add(data);
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    return dataList;
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
          data = myModelTrainnerList
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
        data = myModelTrainnerList
            .where((element) => element.empID.toString() == ids)
            .first;
        dataList.add(data);
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    return dataList;
  }

  List returnCheckVal(String val) {
    List allData = [];
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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        // Navigator.pop(context);
        isDisposed = true;
        await Navigator.popAndPushNamed(
          context,
          RouteConstants.trainingBatchList,
          arguments: mainTrainingSchedule,
        );
        return true;
      },
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
                      RouteConstants.trainingBatchList,
                      arguments: mainTrainingSchedule,
                    );
                  },
                ),
                Text(LabelText.BatchCreation,
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
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Card(
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
                                        mainTrainingSchedule.trainingName ?? '',
                                        "assets/trainingName.png"),
                                    const Divider(color: Color(0xff707070)),
                                    createRowWidget(
                                        LabelText.tog,
                                        mainTrainingSchedule.typeOfGroup ?? '',
                                        "assets/theme.png"),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),

                          CheckboxListTile(
                            title: Text('No Internet'),
                            value: noInternet == 0 ? false : true,
                            onChanged: (value) {
                              setState(() {
                                noInternet = value! ? 1 : 0;
                              });
                            },
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RegistrationTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z0-9@.,()_' ]"))
                              ],
                              height: 41.h,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${LabelText.batchno}';
                                }
                                return null;
                              },
                              textEditingController: batchnoController,
                              title: LabelText.batchno,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RegistrationTextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"^[a-zA-Z\s]+$"))
                              ],
                              height: 41.h,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${LabelText.batchVenue}';
                                }
                                return null;
                              },
                              textEditingController: batchVenueController,
                              title: LabelText.batchVenue,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          //code for state
                          AutoSizeText(
                            LabelText.states,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          if (states != null && states.isNotEmpty) ...[
                            AbsorbPointer(
                              absorbing:
                                  (stateVal != null && stateVal.isNotEmpty)
                                      ? true
                                      : false,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        focusColor: Colors.transparent,
                                        isExpanded: true,
                                        key: Key(
                                          'state',
                                        ),
                                        hint: Text(
                                          LabelText.selectHere,
                                          style: Styles.grey12500,
                                        ),
                                        value: stateVal.isNotEmpty
                                            ? states
                                                .where((element) =>
                                                    element.stateId
                                                        .toString() ==
                                                    stateVal)
                                                .first
                                                .stateName
                                            : null,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Color.fromARGB(
                                              255, 159, 160, 160),
                                        ),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: Styles.grey12500,
                                        underline: Container(
                                          height: 2,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        // ignore: prefer_null_aware_operators
                                        items: states != null
                                            ? states
                                                .map((e) => DropdownMenuItem(
                                                    value: e.stateName,
                                                    child: Text(
                                                      e.stateName!,
                                                      style: Styles.grey12500,
                                                    )))
                                                .toList()
                                            : null,
                                        onChanged: (val) async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          var idval = val! as String;
                                          stateVal = states
                                              .where((element) =>
                                                  element.stateName! == idval)
                                              .first
                                              .stateId!
                                              .toString();
                                          distictValue = '';
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(height: 10),
                          AutoSizeText(
                            LabelText.district,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          if (districts != null && districts.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      key: Key(
                                        'district',
                                      ),
                                      hint: Text(
                                        LabelText.selectHere,
                                        style: Styles.grey12500,
                                      ),
                                      value: distictValue.isNotEmpty
                                          ? districts
                                              .firstWhere(
                                                (element) =>
                                                    element.stateId
                                                            .toString() ==
                                                        stateVal &&
                                                    element.districtId
                                                            .toString() ==
                                                        distictValue,
                                                orElse: () =>
                                                    TblDistrictModel(), // Return null if no element matches the condition.
                                              )
                                              .districtName
                                          : null,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: Styles.grey12500,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      // ignore: prefer_null_aware_operators
                                      items: districts != null
                                          ? districts
                                              .where((element) =>
                                                  element.stateId.toString() ==
                                                  stateVal)
                                              .toList()
                                              .map((e) => DropdownMenuItem(
                                                  value: e.districtName,
                                                  child: Text(
                                                    e.districtName!,
                                                    style: Styles.grey12500,
                                                  )))
                                              .toList()
                                          : null,
                                      onChanged: (val) async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        var idval = val! as String;
                                        distictValue = districts
                                            .where((element) =>
                                                element.districtName! ==
                                                    idval &&
                                                element.stateId.toString() ==
                                                    stateVal)
                                            .first
                                            .districtId!
                                            .toString();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          SizedBox(height: 10),
                          AutoSizeText(
                            LabelText.block,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          if (blocks != null && blocks.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      key: Key(
                                        'blocks',
                                      ),
                                      hint: Text(
                                        LabelText.selectHere,
                                        style: Styles.grey12500,
                                      ),
                                      value: blockValue.isNotEmpty
                                          ? blocks
                                              .firstWhere(
                                                (element) =>
                                                    element.districtId
                                                            .toString() ==
                                                        distictValue &&
                                                    element.id.toString() ==
                                                        blockValue,
                                                orElse: () =>
                                                    BlockDatum(), // Return null if no element matches the condition.
                                              )
                                              .blockName
                                          : null,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: Styles.grey12500,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      // ignore: prefer_null_aware_operators
                                      items: blocks != null
                                          ? blocks
                                              .where((element) =>
                                                  element.districtId
                                                      .toString() ==
                                                  distictValue)
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
                                        var idval = val! as String;
                                        blockValue = blocks
                                            .where((element) =>
                                                element.blockName! == idval &&
                                                element.districtId.toString() ==
                                                    distictValue)
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

                          SizedBox(
                            height: 5.h,
                          ),
                          /* Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RegistrationTextField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${LabelText.block}';
                                }
                                return null;
                              },
                              textEditingController: myBlockController,
                              title: LabelText.block,
                              onChanged: (value) {
                                print(value);
                              },
                            ),
                          ),
          
                          SizedBox(
                            height: 5.h,
                          ),*/
                          //training data
                          AutoSizeText(
                            LabelText.trainingDate,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              key: Key(LabelText.trainingDate),
                              focusNode: AlwaysDisabledFocusNode(),
                              controller: myController,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                _selectDate(context);
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
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          /*
                          //medium of instruction
                          AutoSizeText(
                            LabelText.MOI,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          if (myModel != null && myModel.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      key: Key(
                                        'Moi',
                                      ),
                                      hint: Text(
                                        LabelText.selectHere,
                                        style: Styles.grey12500,
                                      ),
                                      value: moiVal.isNotEmpty
                                          ? myModel
                                              .where((element) =>
                                                  element.id == moiVal)
                                              .first
                                              .value
                                          : null,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: Styles.grey12500,
                                      underline: Container(
                                        height: 2,
                                        color: Colors.deepPurpleAccent,
                                      ),
                                      // ignore: prefer_null_aware_operators
                                      items: myModel != null
                                          ? myModel
                                              .map((e) => DropdownMenuItem(
                                                  value: e.value,
                                                  child: Text(
                                                    e.value!,
                                                    style: Styles.grey12500,
                                                  )))
                                              .toList()
                                          : null,
                                      onChanged: (val) async {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        var idval = val! as String;
                                        moiVal = myModel
                                            .where((element) =>
                                                element.value == idval)
                                            .first
                                            .id!;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 5.h,
                          ),
                          if (dataSourceTopic != null &&
                              dataSourceTopic.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: MultiSelectFormField(
                                  initialValue: returnCheckVal(topicCovered),
                                  checkBoxActiveColor:
                                      Theme.of(context).primaryColor,
          
                                  title: Text(
                                    LabelText.topicCovered,
                                    style: Styles.grey12500,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return LabelText.selectHere;
                                    }
                                  },
          
                                  dataSource: dataSourceTopic,
                                  textField: 'display',
                                  valueField: 'value',
                                  okButtonLabel: LabelText.ok,
                                  cancelButtonLabel: LabelText.cancel,
                                  // required: true,
                                  // hintText: 'Please choose one or more',
                                  //value: _myActivities,
                                  onSaved: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (value == null) {
                                      topicCovered = '';
                                      return;
                                    }
                                    setState(() {
                                      var dataval = checkValue(value);
                                      if (dataval == null || dataval.isEmpty) {
                                        topicCovered = '';
                                      } else {
                                        topicCovered = dataval;
                                      }
          
                                      setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                          */
                          SizedBox(
                            height: 5.h,
                          ),
                          if (myModelTrainner != null &&
                              myModelTrainner.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: Color(0xff9E9E9E),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: MultiSelectDialogField<MyModel>(
                                  initialValue: selectedTrainer,
                                  selectedColor: Theme.of(context).primaryColor,
                                  title: Text(
                                    LabelText.trainerName,
                                    style: Styles.grey12500,
                                  ),
                                  buttonText: Text(
                                    LabelText.trainerName,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return LabelText.selectHere;
                                    }
                                  },
                                  searchable: true,
                                  items: myModelTrainner
                                      .map((e) =>
                                          MultiSelectItem<MyModel>(e, e.value!))
                                      .toList(),
                                  onConfirm: (value) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (value.isEmpty) {
                                      selectedTrainer = [];
                                      return;
                                    }
                                    selectedTrainer = value;

                                    setState(() {});
                                  },
                                ),
                                // child: MultiSelectFormField(
                                //   initialValue: returnCheckVal(nameOfTrainner),
                                //   checkBoxActiveColor:
                                //       Theme.of(context).primaryColor,

                                //   title: Text(
                                //     LabelText.trainerName,
                                //     style: Styles.grey12500,
                                //   ),
                                //   validator: (value) {
                                //     if (value == null || value.length == 0) {
                                //       return LabelText.selectHere;
                                //     }
                                //   },

                                //   dataSource: dataSourceTrainner,
                                //   textField: 'display',
                                //   valueField: 'value',
                                //   okButtonLabel: LabelText.ok,
                                //   cancelButtonLabel: LabelText.cancel,
                                //   // required: true,
                                //   // hintText: 'Please choose one or more',
                                //   //value: _myActivities,
                                //   onSaved: (value) {
                                //     FocusScope.of(context)
                                //         .requestFocus(FocusNode());
                                //     if (value == null) {
                                //       nameOfTrainner = '';
                                //       return;
                                //     }
                                //     setState(() {
                                //       var dataval = checkValue(value);
                                //       if (dataval == null || dataval.isEmpty) {
                                //         nameOfTrainner = '';
                                //       } else {
                                //         nameOfTrainner = dataval;
                                //       }

                                //       setState(() {});
                                //     });
                                //   },
                                // ),
                              ),
                            ),
                          ],
                          SizedBox(
                            height: 5.h,
                          ),
                          if (_trainnerItems.isNotEmpty) ...[
                            Padding(
                              key: Key('trainner'),
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(
                                    color: Color(0xffBABABA),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: MultiSelectDialogField<TrainerModel>(
                                  searchable: true,
                                  initialValue: trainerModulelist,
                                  items: _trainnerItems,
                                  title: Text(LabelText.observer),
                                  buttonText: Text(
                                    LabelText.observer,
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
                          // if (mainTrainingSchedule.typeOfGroup!.toLowerCase() !=
                          //         'single group' &&
                          //     dataSourceEstablishmentName != null &&
                          //     dataSourceEstablishmentName.isNotEmpty) ...[
                          //   Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //         color: Theme.of(context).cardColor,
                          //         border: Border.all(
                          //           color: Color(0xff9E9E9E),
                          //           width: 1,
                          //         ),
                          //         borderRadius: BorderRadius.circular(4),
                          //       ),
                          //       child: MultiSelectFormField(
                          //         initialValue: returnCheckVal(
                          //             participantEstablishmentName),
                          //         checkBoxActiveColor:
                          //             Theme.of(context).primaryColor,

                          //         title: Text(
                          //           LabelText.pEn,
                          //           style: Styles.grey12500,
                          //         ),
                          //         validator: (value) {
                          //           if (value == null || value.length == 0) {
                          //             return LabelText.selectHere;
                          //           }
                          //         },

                          //         dataSource: dataSourceEstablishmentName,
                          //         textField: 'display',
                          //         valueField: 'value',
                          //         okButtonLabel: LabelText.ok,
                          //         cancelButtonLabel: LabelText.cancel,
                          //         // required: true,
                          //         // hintText: 'Please choose one or more',
                          //         //value: _myActivities,
                          //         onSaved: (value) {
                          //           FocusScope.of(context)
                          //               .requestFocus(FocusNode());
                          //           if (value == null) {
                          //             participantEstablishmentName = '';
                          //             return;
                          //           }
                          //           setState(() {
                          //             var dataval = checkValue(value);
                          //             if (dataval == null || dataval.isEmpty) {
                          //               participantEstablishmentName = '';
                          //             } else {
                          //               participantEstablishmentName = dataval;
                          //             }

                          //             setState(() {});
                          //           });
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ]
                        ])))),
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
                      bool isSaved = await SaveData();
                      if (isSaved) {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.trainingBatchList,
                          arguments: mainTrainingSchedule,
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CurvedGreyButton(
                    buttonTitle: LabelText.cancel,
                    style: Styles.white146,
                    height: 35.h,
                    onPressed: () async {
                      isDisposed = true;
                      await Navigator.popAndPushNamed(
                        context,
                        RouteConstants.trainingBatchList,
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
        firstDate: DateTime.parse(mainTrainingSchedule.firstDate!),
        initialDate: _selectedDate ?? DateTime.now(),
        lastDate: DateTime.parse(mainTrainingSchedule.lastDate!));

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      trainingDate = newSelectedDate.toString();

      myController
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: myController.text.length, affinity: TextAffinity.upstream));
      // update(1);
    }
  }

  Future<bool> SaveData() async {
    bool isValid = checkValidation();

    if (isValid) {
      traingbatch.scheduleGuid = mainTrainingSchedule.scheduleGuid;
      if ((traingbatch.registrationGuid == null ||
          traingbatch.registrationGuid!.isEmpty)) {
        traingbatch.registrationGuid = Uuid().v1();
        traingbatch.createdBy = userInfo['email'].toString();
        traingbatch.createdOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
      }

      if (mainTrainingSchedule.typeOfGroup!.toLowerCase() != 'single group') {
        // traingbatch.participantEstablishment = participantEstablishmentName;
        // traingbatch.participantEstablishmentName = retunValueFromId(
        //     myModelEstablishmentName, participantEstablishmentName);
        traingbatch.participantEstablishment =
            mainTrainingSchedule.participantEstablishment;
        traingbatch.participantEstablishmentName =
            mainTrainingSchedule.participantEstablishmentName;
      } else {
        traingbatch.participantEstablishment =
            mainTrainingSchedule.participantEstablishment;
        traingbatch.participantEstablishmentName =
            mainTrainingSchedule.participantEstablishmentName;
      }
      traingbatch.countryId = '101';
      traingbatch.stateId = stateVal;
      traingbatch.districtId = distictValue;
      traingbatch.Block = blockValue;
      traingbatch.noInternet = noInternet;
      traingbatch.batchNo = batchnoController.text;
      traingbatch.batchVenue = batchVenueController.text;
      traingbatch.observer = retunTrainnerIds(trainerModulelist);
      traingbatch.observerName = retunTrainerName(trainerModulelist);
/*
      traingbatch.mediumOfInstruction = moiVal;
      traingbatch.topicsCovered = topicCovered;
      traingbatch.topicsCoveredName =
          retunValueFromId(myModelTopic, topicCovered);
          */
      traingbatch.mediumOfInstruction = null;
      traingbatch.topicsCovered = null;
      traingbatch.topicsCoveredName = null;

      traingbatch.trainer = returnTrainerIdNew(selectedTrainer);
      traingbatch.trainerName = returnTrainerNameNew(selectedTrainer);
      if (traingbatch.trainingCode == null ||
          traingbatch.trainingCode!.isEmpty) {
        var code = traingbatch.registrationGuid!.substring(0, 9);
        final random = Random();
        int fiveDigitRandom = 10000 + random.nextInt(90000);
        traingbatch.trainingCode = code + fiveDigitRandom.toString();
      }
      traingbatch.isEdited = 1;

      traingbatch.updatedBy = userInfo['email'].toString();
      traingbatch.updatedOn = DateFormat('yyyy-MM-dd').format(DateTime.now());

      String outputDateString = '';
      if (myController.text.isNotEmpty) {
        DateTime inputDate = DateFormat("dd/MM/yyyy").parse(myController.text);
        outputDateString = DateFormat("yyyy-MM-dd").format(inputDate);
      }
      traingbatch.trainingDate = outputDateString;

      await DataProvider().insertTrainingBatch(traingbatch);

      await showCustomDialog(
        context,
        widget: ShowAlertDialogBox(
          func: () async {
            var checkInternet =
                await CustomSecureStorage().checkInternetConnectivity();
            if (!checkInternet) {
              return LabelText.noInternetError;
            }
            List<TblTrainingRegistration> regList = [];
            regList.add(traingbatch);
            String jsonBatch = jsonEncode(regList);
            TblTrainingRegistration regDetail = traingbatch;
            var responseBatch;
            if (traingbatch.syncingDate != null &&
                traingbatch.syncingDate!.isNotEmpty) {
              responseBatch = await TrainingRegistrationAPI()
                  .putTrainingRegistration(postBody: jsonDecode(jsonBatch));
            } else {
              responseBatch = await TrainingRegistrationAPI()
                  .postTrainingRegistration(postBody: jsonDecode(jsonBatch));
            }

            if (responseBatch.isSuccess) {
              String resBatch = responseBatch.response.toString();
              List<dynamic> data = jsonDecode(resBatch);
              if (data != null && data.isNotEmpty) {
                //String syncingDate = data[0]["SyncingDate"];
                //  String batchno = data[0]["BatchNo"] ?? regDetail.batchNo;
                String dateTimeString = data[0]["SyncingDate"];
                DateTime dateTime = DateTime.now();
                if (dateTimeString != null && dateTimeString.isNotEmpty) {
                  dateTime = DateTime.parse(dateTimeString);
                }
                String syncingDate = DateFormat('yyyy-MM-dd').format(dateTime);
                if (syncingDate.isNotEmpty) {
                  regDetail.syncingDate = syncingDate;
                  //  regDetail.batchNo = batchno;
                  regDetail.isEdited = 0;
                  await DataProvider().insertTrainingBatch(regDetail);
                }
              }
            }

            if (responseBatch.isSuccess) {
              return LabelText.success;
            } else if (!responseBatch.isSuccess) {
              return LabelText.batchFailed;
            }
            return LabelText.success;
          },
          goOnline: false,
          title: LabelText.pleaseWait,
        ),
      );

      return true;
    }

    return false;
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

  String returnTrainerIdNew(List<MyModel> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.id.toString();

      if (idsValue.isEmpty) {
        idsValue = data;
      } else {
        idsValue = '$idsValue,$data';
      }
    }
    return idsValue;
  }

  String returnTrainerNameNew(List<MyModel> dataList) {
    if (dataList.isEmpty) {
      return '';
    }
    String idsValue = '';
    for (var element in dataList) {
      String data = element.value.toString();

      if (idsValue.isEmpty) {
        idsValue = data;
      } else {
        idsValue = '$idsValue,$data';
      }
    }
    return idsValue;
  }

  String retunValueFromId(List<MyModel> listval, String ids) {
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
      names = listval
          .where((element) => element.id!.toLowerCase() == ids.toLowerCase())
          .first
          .value!;
    }
    return names;
  }

  bool checkValidation() {
    print(stateVal);
    print(distictValue);
    if (batchnoController.text == null || batchnoController.text.isEmpty) {
      Toast.show('${LabelText.batchno} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (stateVal == null || stateVal.isEmpty) {
      Toast.show('${LabelText.states} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (distictValue == null || distictValue.isEmpty) {
      Toast.show('${LabelText.district} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (blockValue == null || blockValue.isEmpty) {
      Toast.show('${LabelText.block} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (myController.text == null || myController.text.isEmpty) {
      Toast.show('${LabelText.trainingDate} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } /* else if (moiVal == null || moiVal.isEmpty) {
      Toast.show('${LabelText.MOI} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (topicCovered == null || topicCovered.isEmpty) {
      Toast.show('${LabelText.topicCovered} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);

      return false;
    }*/
    else if (selectedTrainer.isEmpty) {
      Toast.show('${LabelText.trainerName} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);

      return false;
    } else if ((mainTrainingSchedule.typeOfGroup!.toLowerCase() !=
            'single group') &&
        (participantEstablishmentName == null ||
            participantEstablishmentName.isEmpty)) {
      participantEstablishmentName = '';
      // Toast.show('${LabelText.participantName} is mandatory',
      //     duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);

      return true;
    }
    /*else if (trainerModulelist == null || trainerModulelist.isEmpty) {
      Toast.show('${LabelText.observer} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);

      return false;
    }*/
    return true;
  }
}

Widget createRowWidget(String title, String value, String? icon) {
  // var newImage = "assets/year.png";
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon!.isNotEmpty
            ? Image.asset(
                '$icon',
                // height: 15.h,
                scale: 3.3,
              )
            : SizedBox(
                height: 10.h,
              ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: AutoSizeText(
            title,
            wrapWords: false,
            style: Styles.grey124.copyWith(color: ColorConstants.defaultMaroon),
            maxLines: 10,
          ),
        ),
        Spacer(),
        Expanded(
          child: AutoSizeText(
            value ?? '',
            wrapWords: false,
            style: Styles.black124,
            maxLines: 10,
          ),
        ),
      ],
    ),
  );
}
