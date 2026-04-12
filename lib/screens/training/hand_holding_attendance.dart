import 'dart:convert';

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
import 'package:intl/intl.dart';

import '../../api/dynamic_response/dynamic_responses.dart';
import '../../api/hand_holding_apis.dart';
import '../../constants/color_constants.dart';
import '../../constants/image_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../database/dataProvider.dart';
import '../../table_model/tbl_Training_HandHolding_Particepent.dart';
import '../../table_model/tbl_training_handHolding_attendance.dart';
import '../../table_model/tbl_training_hand_holding.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/custom_loading_indicator.dart';
import '../../widgets/registration_text_field.dart';
import 'house_holding_particepent.dart';

class HandHoldingAttendance extends StatefulWidget {
  const HandHoldingAttendance({Key? key}) : super(key: key);

  @override
  State<HandHoldingAttendance> createState() => _HandHoldingAttendanceState();
}

class _HandHoldingAttendanceState extends State<HandHoldingAttendance> {
  var isDisposed = false;
  final ScrollController scrcontroller = ScrollController();
  DataProvider dbProvider = DataProvider();
  var traingingScheduleParticipantList = <TrainingHandHoldingParticepent>[];
  var maintraingingScheduleParticipantList = <TrainingHandHoldingParticepent>[];
  final ScrollController controller = ScrollController();
  String mobileNumber = '';
  var mainTrainingSchedule = TblTrainingSchedule();
  var userInfo;
  var attendance = {};
  var handholding = TblTrainingHandHolding();
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      dynamic data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        mainTrainingSchedule = data[0];
        handholding = data[1];
      }
      userInfo = await UserInfo().getUserCredentials();
      maintraingingScheduleParticipantList = await DataProvider()
          .getTrainingHandHoldingParticepentData(
              mainTrainingSchedule, handholding);
      traingingScheduleParticipantList = maintraingingScheduleParticipantList;

      List<TrainingHandHoldingAttendance> attenData =
          await dbProvider.getHandHoldAttendance(handholding.handHoldingGuid!);
      for (var element in attenData) {
        attendance[element.mobileNo] = true;
      }
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
                    RouteConstants.handholdingreglist,
                    arguments: mainTrainingSchedule,
                  );
                },
              ),
              Text(
                LabelText.markAttendance,
                style:
                    Styles.red164.copyWith(color: ColorConstants.defaultMaroon),
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
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // CurvedTextField(textInputType: ,
                  //   onChanged: onChanged),
                  CurvedTextField(
                    textInputType: TextInputType.phone,
                    hintText: LabelText.searchMobileno,
                    hintStyle: Styles.grey164,
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
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  traingingScheduleParticipantList.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return listparticipent(
                                    traingingScheduleParticipantList[index]);
                              })
                        ],
                      )),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: CustomButton(
                          textColor: ColorConstants.whiteColorText,
                          buttonTitle: LabelText.submit,
                          buttonColor: Colors.green,
                          height: 43.h,
                          onPressed: () async {
                            await insetAttendance();

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
                                  if (attendance.isNotEmpty) {
                                    List<TrainingHandHoldingAttendance>
                                        allData = await DataProvider()
                                            .getHandHoldAttendance(
                                                handholding.handHoldingGuid!);

                                    String jsonBatch = jsonEncode(allData);
                                    var responseModel = await HandHoldinApi()
                                        .postHandHoldinAttendance(
                                            postBody: jsonDecode(jsonBatch));
                                    if (responseModel.isSuccess) {
                                      await DataProvider().updateHandHolingFlag(
                                          handholding.handHoldingGuid!);

                                      return LabelText.success;
                                    } else {
                                      return LabelText.uploadFailed;
                                    }

                                    //  return responseModel;
                                  } else {
                                    return LabelText
                                        .attendenceSheetEmptyMessage;
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
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CurvedButton(
                          buttonColor: ColorConstants.defaultMaroon,
                          // textColor: ColorConstants.defaultWhiteColor,
                          buttonTitle: LabelText.addParticipant,
                          style: Styles.white146,
                          height: 43.h,
                          onPressed: () async {
                            final response = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        HouseHoldRegistraionParticipantModule(
                                            handholing: handholding,
                                            particepentDetail: null)));
                            if (response != null) {
                              maintraingingScheduleParticipantList
                                  .add(response);
                              attendance[response.phoneNo] = true;
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      // const Spacer(),
                      Expanded(
                        child: CurvedGreyButton(
                          // buttonColor: ColorConstants.defaultGreyColor,
                          // textColor: ColorConstants.defaultBlackColor,
                          buttonTitle: LabelText.cancel,
                          style: Styles.white146,
                          height: 43.h,
                          onPressed: () async {
                            isDisposed = true;
                            await Navigator.popAndPushNamed(
                                context, RouteConstants.handholdingreglist,
                                arguments: mainTrainingSchedule);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Future<void> insetAttendance() async {
    await dbProvider.deleteHandHoldingAttendance(handholding.handHoldingGuid!);
    attendance.forEach((key, value) async {
      var sessionAtten = TrainingHandHoldingAttendance();
      sessionAtten.handHoldingGuid = handholding.handHoldingGuid;
      sessionAtten.mobileNo = key;
      sessionAtten.createdBy = userInfo['email'].toString();
      sessionAtten.createdOn = DateFormat('yyyy-MM-dd').format(DateTime.now());
      sessionAtten.updatedBy = userInfo['email'].toString();
      sessionAtten.updatedOn = DateFormat('yyyy-MM-dd').format(DateTime.now());

      sessionAtten.isEdited = 1;

      await dbProvider.insertHandHoldingAttendance(sessionAtten);
    });
  }

  Widget listparticipent(TrainingHandHoldingParticepent particepent) {
    final ValueNotifier<bool> buttonClickedTimes =
        ValueNotifier(attendance.containsKey(particepent.phoneNo));
    return Padding(
      padding:
          EdgeInsets.only(right: 26.w, left: 18.w, top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: false,
                child: InkWell(
                  onTap: () async {
                    final response = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                HouseHoldRegistraionParticipantModule(
                                    handholing: handholding,
                                    particepentDetail: particepent)));
                    if (response != null) {
                      //   maintraingingScheduleParticipantList.add(response);
                      int index = maintraingingScheduleParticipantList
                          .indexOf(particepent);
                      maintraingingScheduleParticipantList.remove(response);
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
            flex: 3,
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
              buttonClickedTimes.value = !buttonClickedTimes.value;
              if (buttonClickedTimes.value) {
                attendance[particepent.phoneNo] = true;
              } else {
                if (attendance.containsKey(particepent.phoneNo)) {
                  attendance.remove(particepent.phoneNo);
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
