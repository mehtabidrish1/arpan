import 'dart:convert';

import 'package:arpan/screens/training/training_batch_creation.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/default_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:uuid/uuid.dart';

import '../../api/training_reg_session_api.dart';
import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../database/dataProvider.dart';
import '../../models/custom_model.dart';
import '../../models/training_registration_session.dart';
import '../../table_model/tbl_training_registration_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../utils/validate.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loading_indicator.dart';

class TrainingBatchSessionCreation extends StatefulWidget {
  const TrainingBatchSessionCreation({Key? key}) : super(key: key);

  @override
  State<TrainingBatchSessionCreation> createState() =>
      _TrainingBatchSessionCreationState();
}

class _TrainingBatchSessionCreationState
    extends State<TrainingBatchSessionCreation> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var trainingRegistration = TblTrainingRegistration();
  TextEditingController myController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String trainingDate = '';
  String hour = '';
  var myModel = <MyModel>[];
  var userInfo;
  bool isDisposed = false;
  @override
  @override
  void initState() {
    super.initState();
    LabelText.getLang(1);
    Future.delayed(const Duration(milliseconds: 3), () async {
      loadAllData();
    });
  }

  loadAllData() async {
    dynamic data = ModalRoute.of(context)!.settings.arguments;
    if (data != null) {
      mainTrainingSchedule = data[0];
      trainingRegistration = data[1];
    }
    _selectedDate = DateTime.parse(mainTrainingSchedule.firstDate!);
    userInfo = await UserInfo().getUserCredentials();
    myModel = Validate.ConvertIDValueIntoList('1,2,3', '2 Hour,4 Hour,8 Hour');

    if (mounted) {
      setState(() {});
    }
  }

 

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var hourValue = hour.isNotEmpty
        ? myModel.where((element) => element.value == hour).first.value
        : null;
    print('load $hourValue');

    hourValue = '2 Hour';
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
                      RouteConstants.trainingBatchSessionList,
                      arguments: [mainTrainingSchedule, trainingRegistration],
                    );
                  },
                ),
                Text(
                  LabelText.addSession,
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
                    padding: const EdgeInsets.all(10.0),
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
                                        "assets/trainerName.png"),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          AutoSizeText(
                            LabelText.trainingDate,
                            wrapWords: false,
                            style: Styles.grey12500,
                            maxLines: 10,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          DefaultTextField(
                            onChanged: (a) {},
                            key: Key(
                              LabelText.trainingDate,
                            ),
                            focusNode: AlwaysDisabledFocusNode(),
                            controller: myController,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());

                              _selectDate(context);
                              //update(1);
                            },
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: ColorConstants.defaultRedColor,
                            ),
                            // decoration: InputDecoration(
                            //   //fillColor: Theme.of(context).backgroundColor,
                            //   filled: true,
                            //   enabledBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Color(0xffBABABA),
                            //       width: 1.0,
                            //     ),
                            //   ),
                            //   focusedBorder: OutlineInputBorder(
                            //     borderSide: BorderSide(
                            //       color: Theme.of(context).primaryColor,
                            //       width: 1.0,
                            //     ),
                            //   ),
                            //   suffixIcon: Icon(
                            //     Icons.calendar_month,
                            //     color: ColorConstants.defaultRedColor,
                            //   ),
                            // ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Visibility(
                            visible: false,
                            child: AutoSizeText(
                              LabelText.hour,
                              wrapWords: false,
                              style: Styles.grey12500,
                              maxLines: 10,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Visibility(
                            visible: false,
                            child: Padding(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      focusColor: Colors.transparent,
                                      isExpanded: true,
                                      key: Key(
                                        'hour',
                                      ),
                                      hint: Text(
                                        LabelText.selectHere,
                                        style: Styles.grey12500,
                                      ),
                                      value: hourValue,
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

                                        hour = val! as String;
                                        print(hour);
                                        //setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
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
                    height: 40.h,
                    onPressed: () async {
                      bool isSaved = await SaveData();
                      if (isSaved) {
                        isDisposed = true;
                        await Navigator.popAndPushNamed(
                          context,
                          RouteConstants.trainingBatchSessionList,
                          arguments: [
                            mainTrainingSchedule,
                            trainingRegistration
                          ],
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: CurvedGreyButton(
                    buttonTitle: LabelText.cancel,
                    style: Styles.white146,
                    height: 40.h,
                    onPressed: () async {
                      await Navigator.popAndPushNamed(
                        context,
                        RouteConstants.trainingBatchSessionList,
                        arguments: [mainTrainingSchedule, trainingRegistration],
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
        firstDate: _selectedDate,
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
    
      return true;
    }
    return false;
  }

  bool checkValidation() {
    hour = '2 Hour';
    if (myController.text == null || myController.text.isEmpty) {
      Toast.show('${LabelText.trainingDate} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);
      return false;
    } else if (hour == null || hour.isEmpty) {
      Toast.show('${LabelText.hour} is mandatory',
          duration: 3, gravity: Toast.bottom, backgroundColor: Colors.red);

      return false;
    }
    return true;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
