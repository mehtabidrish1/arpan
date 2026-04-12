import 'package:arpan/screens/dashboard/attendances/attendanceDetail.dart';
import 'package:arpan/utils/download_data.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/default_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../models/training_registration.dart';
import '../../viewmodels/attendence_marksheet_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../utils/common.dart';
import '../../widgets/custom_loading_indicator.dart';

class TrainingDetailScreen extends ConsumerStatefulWidget {
  final TrainingRegistration? trainingRegistration;
  const TrainingDetailScreen({Key? key, this.trainingRegistration})
      : super(key: key);

  @override
  ConsumerState<TrainingDetailScreen> createState() => _TrainingDetailScreen();
}

class _TrainingDetailScreen extends ConsumerState<TrainingDetailScreen> {
  TextEditingController typeTrainingController = TextEditingController();
  TextEditingController durationTrainingController = TextEditingController();
  TextEditingController traingDateController = TextEditingController();
  TextEditingController placeTrainingController = TextEditingController();
  TextEditingController trainingHereController = TextEditingController();
  TextEditingController trainingThemeController = TextEditingController();
  TextEditingController trainingTopicController = TextEditingController();
  DataDownload dataDownload = DataDownload();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xff26AA9F), Color(0xff37D7C9)],
              )),
          child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                Icons.refresh,
                size: 35.w,
              ),
              onPressed: () async {
                showCustomDialog(
                  context,
                  widget: ShowAlertDialogBox(
                    func: () async {
                      // await dataDownload.getTrainingParticipantList();
                      // ref.refresh(attendenceMarksheetFutureProvider);
                      await DataDownload()
                          .getTrainingRegistrationAttendanceList('');
                      return LabelText.success;
                    },
                    goOnline: false,
                    title: LabelText.pleaseWait,
                  ),
                );
              }),
        ),
      ),
      appBar: AppBar(
        backgroundColor: ColorConstants.defaultBackgroundColor,
        title: Text(LabelText.trainingDetails, style: Styles.black145),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrainingDetailsTextFormField(
                    isreadOnly: true,
                    title: LabelText.trainingName,
                    initialValue: widget.trainingRegistration?.trainerName
                        ?.replaceAll(',', ', ')
                        .capitalizeFirstofEach),
                SizedBox(
                  height: 16.h,
                ),
                if (false) ...[
                  Text(
                    LabelText.typesoftraining,
                    style: GoogleFonts.poppins(
                        color: Color(0xffB1B1B1),
                        fontSize: 8,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    child: TextFormField(
                      readOnly: true,
                      initialValue:
                          widget.trainingRegistration!.trainerName != null
                              ? widget.trainingRegistration!.trainerName!
                                      .toLowerCase()
                                      .contains('adv')
                                  ? LabelText.advancedTraining
                                  : LabelText.basicTraining
                              : LabelText.notAvailable,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter types of training';
                        }
                        return null;
                      },
                      // controller: typeTrainingController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: LabelText.typehere,
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    LabelText.durationofTraining,
                    style: GoogleFonts.poppins(
                        color: Color(0xffB1B1B1),
                        fontSize: 8,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    child: TextFormField(
                      readOnly: true,
                      // initialValue: widget.trainingRegistration!.trainingName
                      //     ?.replaceAll(',', ', ')
                      //     .capitalizeFirstofEach,
                      initialValue: LabelText.notAvailable,

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter duration of training';
                        }
                        return null;
                      },
                      // controller: durationTrainingController,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: LabelText.typehere,
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
                SizedBox(
                  height: 16.h,
                ),
                TrainingDetailsTextFormField(
                  isreadOnly: true,
                  title: LabelText.placeofTraining,
                  initialValue: widget
                          .trainingRegistration?.participantEstablishmentName
                          ?.replaceAll(',', ', ')
                          .capitalizeFirstofEach ??
                      LabelText.notAvailable,
                ),
                SizedBox(
                  height: 16.h,
                ),
                TrainingDetailsTextFormField(
                  isreadOnly: true,
                  title: LabelText.trainingHere,
                  initialValue: widget.trainingRegistration!.trainerName
                          ?.replaceAll(',', ', ')
                          .capitalizeFirstofEach ??
                      LabelText.notAvailable,
                ),
                SizedBox(
                  height: 16.h,
                ),
                TrainingDetailsTextFormField(
                  isreadOnly: true,
                  title: LabelText.trainingTheme,
                  initialValue: widget.trainingRegistration!.topicsCoveredName
                          ?.replaceAll(',', ', ')
                          .capitalizeFirstofEach ??
                      LabelText.notAvailable,
                ),
                SizedBox(
                  height: 16.h,
                ),
                TrainingDetailsTextFormField(
                  isreadOnly: true,
                  title: LabelText.trainingTopics,
                  initialValue: widget.trainingRegistration!.topicsCoveredName
                          ?.replaceAll(',', ', ')
                          .capitalizeFirstofEach ??
                      LabelText.notAvailable,
                ),
                SizedBox(
                  height: 50.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AttendanceDetail(
                                        title: LabelText.totalRegistered,
                                        trainingRegistration: null,
                                      )));
                        },
                        child: Card(
                          child: AttendanceDetailInfo(
                            image: Image.asset(
                              "assets/markedattendance.png",
                              scale: 2,
                            ),
                            title: LabelText.totalRegistered,
                            value: ref
                                .read(attendenceMarksheetProvider(''))
                                .length,
                            color: ColorConstants.greyColor1,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => AttendanceDetail(
                                        title: LabelText.attendanceMarked,
                                        trainingRegistration: null,
                                      )));
                        },
                        child: Card(
                          child: AttendanceDetailInfo(
                            image: Image.asset(
                              "assets/markedattendance.png",
                              scale: 2,
                            ),
                            title: LabelText.attendanceMarked,
                            color: ColorConstants.attendancemarkedcard,
                            value: ref
                                .read(attendenceMarksheetProvider(''))
                                .where((element) => false)
                                .length,
                          ),
                        ),
                      ),
                    ),
                    // Card(
                    //   child: AttendanceDetailInfo(
                    //     title: LabelText.unmarkedAttendance,
                    //     value: ref
                    //         .read(attendenceMarksheetProvider)
                    //         .where(
                    //             (element) => element.isAttendanceMarked != true)
                    //         .length,
                    //     color: ColorConstants.greyColor1,
                    //   ),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: AttendanceDetailInfo(
                          image: Image.asset(
                            "assets/presession.png",
                            scale: 2,
                          ),
                          title: LabelText.preSessionsFields,
                          value: 0,
                          color: ColorConstants.presessioncard,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: AttendanceDetailInfo(
                          image: Image.asset(
                            "assets/presession.png",
                            scale: 2,
                          ),
                          title: LabelText.postSessionsFields,
                          color: ColorConstants.greyColor1,
                          value: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: AttendanceDetailInfo(
                          image: Image.asset(
                            "assets/feedbacksession.png",
                            scale: 2,
                          ),
                          title: LabelText.feedback,
                          value: 0,
                          color: ColorConstants.feedbacksessioncard,
                        ),
                      ),
                    ),
                  ],
                ),
                if (false)
                  IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: ColorConstants.defaultWhiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AttendanceDetailInfo(
                                title: LabelText.totalRegistered,
                                value: ref
                                    .read(attendenceMarksheetProvider(''))
                                    .length,
                                color: ColorConstants.greyColor1,
                              ),
                              AttendanceDetailInfo(
                                title: LabelText.attendanceMarked,
                                color: ColorConstants.defaultWhiteColor,
                                value: ref
                                    .read(attendenceMarksheetProvider(''))
                                    .where((element) => false)
                                    .length,
                              ),
                              AttendanceDetailInfo(
                                title: LabelText.unmarkedAttendance,
                                value: 0,
                                color: ColorConstants.defaultWhiteColor,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          color: ColorConstants.defaultWhiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              AttendanceDetailInfo(
                                title: LabelText.preSessionsFields,
                                value: 0,
                                color: ColorConstants.defaultWhiteColor,
                              ),
                              AttendanceDetailInfo(
                                title: LabelText.postSessionsFields,
                                color: ColorConstants.defaultWhiteColor,
                                value: 0,
                              ),
                              AttendanceDetailInfo(
                                title: LabelText.feedbackSessionsFields,
                                value: 0,
                                color: ColorConstants.defaultWhiteColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (false)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: ColorConstants.defaultWhiteColor,
                        height: 53.h,
                        width: 78.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LabelText.attendanceMarked,
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 17, 7, 7)),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "0  ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 17, 7, 7)),
                                    children: <InlineSpan>[
                                  TextSpan(
                                    text: LabelText.details,
                                    style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.defaultRedColor),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      Container(
                        color: Color(0xffEEEEEE),
                        height: 53.h,
                        width: 78.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LabelText.preSessionsFields,
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 17, 7, 7)),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "0  ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 17, 7, 7)),
                                    children: <InlineSpan>[
                                  TextSpan(
                                    text: LabelText.details,
                                    style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.defaultRedColor),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      Container(
                        color: ColorConstants.defaultWhiteColor,
                        height: 53.h,
                        width: 78.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LabelText.feedbackSessions,
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 17, 7, 7)),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "0 ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 17, 7, 7)),
                                    children: <InlineSpan>[
                                  TextSpan(
                                    text: LabelText.details,
                                    style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.defaultRedColor),
                                  )
                                ])),
                          ],
                        ),
                      ),
                      Container(
                        color: ColorConstants.defaultWhiteColor,
                        height: 53.h,
                        width: 78.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LabelText.postSessionsFields,
                              style: GoogleFonts.poppins(
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 17, 7, 7)),
                            ),
                            RichText(
                                text: TextSpan(
                                    text: "0  ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromARGB(255, 17, 7, 7)),
                                    children: <InlineSpan>[
                                  TextSpan(
                                    text: LabelText.details,
                                    style: GoogleFonts.poppins(
                                        fontSize: 8.sp,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.defaultRedColor),
                                  )
                                ])),
                          ],
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  height: 80.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        textColor: ColorConstants.whiteColorText,
                        buttonTitle: LabelText.markAttendance,
                        height: 43.h,
                        onPressed: () {
                          // Navigator.pushNamed(
                          //   context,
                          //   RouteConstants.markAttendanceScreen,
                          // );
                          FocusScope.of(context).unfocus();
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => MarkAttendance(
                          //             // trainingRegistration:null
                          //             //widget.trainingRegistration!,
                          //             )));
                        },
                      ),
                    ),
                    // SizedBox(
                    //   width: 4.w,
                    // ),
                    // CustomButton(
                    //   width: 134.w,
                    //   buttonColor: ColorConstants.buttonColor2,
                    //   textColor: ColorConstants.whiteColorText,
                    //   buttonTitle: LabelText.cancel,
                    //   height: 43.h,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class TrainingDetailsTextFormField extends StatelessWidget {
  const TrainingDetailsTextFormField(
      {Key? key,
      this.initialValue,
      this.validator,
      this.isreadOnly = false,
      this.controller,
      this.onChanged,
      required this.title})
      : super(key: key);

  final String? initialValue;
  final String? Function(String?)? validator;
  final bool? isreadOnly;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title + ": ",
            style: Styles.defaultFont
                .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
          ),
        ),
        Expanded(
          flex: 2,
          child: TextFormField(
            readOnly: isreadOnly!,
            initialValue: initialValue ?? LabelText.notAvailable,
            validator: validator,
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              isDense: true,
              hintText: LabelText.typehere,
              hintStyle: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceDetailInfo extends StatelessWidget {
  const AttendanceDetailInfo(
      {Key? key,
      required this.title,
      required this.value,
      this.color,
      this.image})
      : super(key: key);
  final String title;
  final dynamic value;
  final Color? color;
  final Image? image;
  @override
  Widget build(BuildContext context) {
    Color initialColor = color ?? ColorConstants.whiteColorText;
    return Container(
      color: initialColor,
      height: 70,
      width: 103,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
        ),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 5, right: 2), child: image),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$value  ",
                    style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 17, 7, 7)),
                  ),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 17, 7, 7)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
