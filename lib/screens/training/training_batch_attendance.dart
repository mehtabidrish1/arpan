import 'dart:convert';

import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/widgets/custom_GreyButton.dart';
import 'package:arpan/widgets/custom_curvedButton.dart';
import 'package:arpan/widgets/custom_curvedTextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../api/batch_partial_attendance_api.dart';
import '../../constants/color_constants.dart';
import '../../constants/image_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../models/tbl_batch_attendence_data.dart';
import '../../models/tbl_partial_attendance_data.dart';
import '../../table_model/tbl_training_registration_model.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../utils/validate.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/registration_text_field.dart';

class TraingBatchAttendance extends StatefulWidget {
  const TraingBatchAttendance({Key? key}) : super(key: key);

  @override
  State<TraingBatchAttendance> createState() => _TraingBatchAttendanceState();
}

class _TraingBatchAttendanceState extends State<TraingBatchAttendance> {
  var mainTrainingSchedule = TblTrainingSchedule();
  var trainingRegistration = TblTrainingRegistration();
  var traingingBatchParticipantList = <TblBatchAttendanceData>[];
  var maintraingingBatchParticipantList = <TblBatchAttendanceData>[];
  String mobileNumber = '';
  var userInfo;

  var partialAttendanceList = <TblBatchPartialAttendanceData>[];

  var attendance = {};
  var isDisposed = false;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data[0];
        trainingRegistration = data[1];
      }
      userInfo = await UserInfo().getUserCredentials();
      maintraingingBatchParticipantList = await DataProvider()
          .getBatchAttendanceList(trainingRegistration.registrationGuid!);

      partialAttendanceList = await DataProvider()
          .getBatchPartialAttendanceList(
              trainingRegistration.registrationGuid!);

      for (var element in partialAttendanceList) {
        attendance[element.MobileNo] = true;
        /*   var mobileData = maintraingingBatchParticipantList
            .where((element1) => element1.MobileNo == element.MobileNo)
            .toList();
         if (mobileData.isEmpty) {
          var dataval = TblBatchAttendanceData();
          dataval.FullName = '';
          dataval.MobileNo = element.MobileNo;
          dataval.RegistrationGuid = trainingRegistration.registrationGuid!;
          maintraingingBatchParticipantList.add(dataval);
          await DataProvider().insertBatchAttendance([dataval]);
        }*/
      }

      traingingBatchParticipantList = maintraingingBatchParticipantList;

      setState(() {
        isDisposed = true;
      });
    }
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
              Text(LabelText.markPartialAttendance,
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
                  SizedBox(
                    height: 15.h,
                  ),
                  CurvedTextField(
                    textInputType: TextInputType.phone,
                    hintText: LabelText.searchMobileno,
                    hintStyle: Styles.grey124,
                    onChanged: (value) {
                      mobileNumber = value;
                      var length = value.length;
                      if (mobileNumber.isNotEmpty &&
                          traingingBatchParticipantList.isNotEmpty) {
                        traingingBatchParticipantList =
                            maintraingingBatchParticipantList
                                .where((element) =>
                                    element.MobileNo?.substring(0, length) ==
                                    mobileNumber)
                                .toList();
                      } else {
                        traingingBatchParticipantList =
                            maintraingingBatchParticipantList;
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
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  traingingBatchParticipantList.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return listparticipent(
                                    traingingBatchParticipantList[index]);
                              })
                        ],
                      )),
                  SizedBox(
                    height: 20.h,
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
                          secondFunc: () async {
                            if (attendance.isNotEmpty) {
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
                          func: () async {
                            if (attendance.isNotEmpty) {
                              List<TblBatchPartialAttendanceData> dataList = [];
                              attendance.forEach((key, value) {
                                var data = TblBatchPartialAttendanceData();
                                data.ScheduleGuid =
                                    mainTrainingSchedule.scheduleGuid!;
                                data.RegistrationGuid =
                                    trainingRegistration.registrationGuid;
                                data.MobileNo = key;
                                data.CreatedBy = userInfo['email'].toString();
                                data.CreatedOn = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now());
                                data.SyncDate = DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now());
                                data.IsEdited = 1;
                                dataList.add(data);
                              });

                              if (dataList.isNotEmpty) {
                                await DataProvider().insertPartial_Attendance(
                                    dataList,
                                    trainingRegistration.registrationGuid);
                                var checkInternet = await CustomSecureStorage()
                                    .checkInternetConnectivity();
                                if (!checkInternet) {
                                  return LabelText.noInternetError;
                                }
                                String jsonBatch = jsonEncode(dataList);
                                var responseBatch =
                                    await BatchPartialAttendanceApi()
                                        .postPartialAttendance(
                                            postBody: jsonDecode(jsonBatch));
                                if (responseBatch.isSuccess) {
                                  await DataProvider().UpdatePartial_Attendance(
                                      trainingRegistration.registrationGuid);
                                  return LabelText.success;
                                }
                              }
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
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  /*    Expanded(
                        child: CurvedButton(
                          buttonTitle: LabelText.addParticipant,
                          style: Styles.white146,
                          buttonColor: ColorConstants.defaultMaroon,
                          height: 40.h,
                          onPressed: () async {
                            await addParticepent();
                            setState(() {});
                          },
                        ),
                      ),*/
                      Expanded(
                        child: CurvedGreyButton(
                          buttonTitle: LabelText.cancel,
                          style: Styles.white146,
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
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  addParticepent() {
    final _formKey = GlobalKey<FormState>();

    TextEditingController mobileController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Container(
          height: 200.h,
          width: 200.w,
          child: Column(
            children: [
              Text(
                "Add Participant",
                style: Styles.black145,
              ),
              Spacer(),
              Center(
                child: Form(
                  key: _formKey,
                  child: RegistrationTextField(
                    decoration: InputDecoration(border: InputBorder.none),
                    validator: (value) {
                      var validate = Validate().validateMobileNumber(value!);
                      return validate;
                    },
                    maxlength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'(^[0-9]{1,10})')),
                    ],
                    textEditingController: mobileController,
                    title: LabelText.getText('mobileNo'),
                    textInputType: TextInputType.number,
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: CurvedButton(
                  buttonTitle: 'Add',
                  style: Styles.white146,
                  buttonColor: ColorConstants.defaultMaroon,
                  height: 35.h,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var dataval = TblBatchAttendanceData();
                      dataval.FullName = '';
                      dataval.MobileNo = mobileController.text;
                      dataval.RegistrationGuid =
                          trainingRegistration.registrationGuid!;

                      var mobileData = maintraingingBatchParticipantList
                          .where((element1) =>
                              element1.MobileNo == mobileController.text)
                          .toList();
                      if (mobileData.isEmpty) {
                        maintraingingBatchParticipantList.add(dataval);
                        attendance[dataval.MobileNo] = true;
                        traingingBatchParticipantList =
                            maintraingingBatchParticipantList;
                        await DataProvider().insertBatchAttendance([dataval]);

                        setState(() {});
                      }

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
              Expanded(
                child: CurvedGreyButton(
                  style: Styles.white146,
                  buttonTitle: LabelText.cancel,
                  height: 35.h,
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
  }

  Widget listparticipent(TblBatchAttendanceData particepent) {
    final ValueNotifier<bool> buttonClickedTimes =
        ValueNotifier(attendance.containsKey(particepent.MobileNo));
    return Padding(
      padding:
          EdgeInsets.only(right: 26.w, left: 18.w, top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                  text: TextSpan(
                text: particepent.FullName ?? '',
                style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(255, 17, 7, 7)),
              )),
              RichText(
                  text: TextSpan(
                text: particepent.MobileNo ?? '',
                style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromARGB(255, 17, 7, 7)),
              )),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              buttonClickedTimes.value = !buttonClickedTimes.value;
              if (buttonClickedTimes.value) {
                attendance[particepent.MobileNo] = true;
              } else {
                if (attendance.containsKey(particepent.MobileNo)) {
                  attendance.remove(particepent.MobileNo);
                }
              }
              // info[index].isSelected = buttonClickedTimes.value;

              // callback(info);
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
          )
        ],
      ),
    );
  }
}
