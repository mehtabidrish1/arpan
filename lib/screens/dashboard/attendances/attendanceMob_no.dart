import 'dart:math';

import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/registration_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../viewmodels/attendence_marksheet_view_model.dart';
import 'widgets/attendance_container.dart';

class AttendanceMobileNo extends ConsumerStatefulWidget {
  const AttendanceMobileNo({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AttendanceMobileNo> createState() => _AttendanceMobileNoState();
}

class _AttendanceMobileNoState extends ConsumerState<AttendanceMobileNo> {
  String mobileNumber = '';
  List<Info> info = [
    // Info(ParticipantName: 'Amit Kumar', Age: 21, No: "(9256325415)"),
    // Info(ParticipantName: 'Aman Singh', Age: 34, No: "(9256325415)"),
    // Info(ParticipantName: 'Babita Kumari', Age: 21, No: "(9256325415)"),
    // Info(ParticipantName: 'Chandan Kumar', Age: 42, No: "(9256325415)"),
    // Info(ParticipantName: 'Eshan Kumar', Age: 17, No: "(9256325415)"),
    // Info(ParticipantName: 'Eshan Kumar', Age: 13, No: "(9256325415)"),
    // Info(ParticipantName: 'Aman Singh', Age: 34, No: "(9256325415)"),
    // Info(ParticipantName: 'Amit Kumar', Age: 21, No: "(9256325415)"),
    // Info(ParticipantName: 'Aman Singh', Age: 34, No: "(9256325415)"),
    // Info(ParticipantName: 'Babita Kumari', Age: 21, No: "(9256325415)"),
    // Info(ParticipantName: 'Chandan Kumar', Age: 42, No: "(9256325415)"),
    // Info(ParticipantName: 'Eshan Kumar', Age: 17, No: "(9256325415)"),
    // Info(ParticipantName: 'Eshan Kumar', Age: 13, No: "(9256325415)"),
    // Info(ParticipantName: 'Aman Singh', Age: 34, No: "(9256325415)"),
  ];
  final ScrollController controller = ScrollController();

  List<Info> getDynamicFilteredAttendance(
      {required String mobile, required List<Info> infoList}) {
    List<Info> infoTempList = [];

    if (mobile.isEmpty) {
      infoTempList = infoList;
    }
    infoTempList =
        infoList.where((element) => element.No.contains(mobile)).toList();
    return infoTempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              RegistrationTextField(
                subTitle: LabelText.searchMobileno,
                onChanged: (value) {
                  mobileNumber = value;
                  ref.refresh(attendenceMarksheetFutureProvider(''));
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 18.h),
                        child: Row(
                          children: [
                            Text(
                              LabelText.participantName,
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.defaultRedColor),
                            ),
                            const Spacer(),
                            Text(
                              LabelText.age,
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.defaultRedColor),
                            )
                          ],
                        ),
                      ),
                      ChildScrollWidget(
                        controller: controller,
                        child: SizedBox(
                          height: 320.h,
                          child: Consumer(builder: (context, ref, child) {
                            return ref
                                .watch(attendenceMarksheetFutureProvider(''))
                                .when(
                                    data: (data) {
                                      info = data
                                          .map((e) => Info(
                                              id: e.phoneNo.toString(),
                                              ParticipantName: e.fullName!,
                                              Age: 20,
                                              No: ' (${e.phoneNo})'))
                                          .toList();
                                      info = getDynamicFilteredAttendance(
                                          mobile: mobileNumber, infoList: info);
                                      return ListView.separated(
                                          separatorBuilder: ((context, index) =>
                                              Divider(
                                                thickness: 1.h,
                                                indent: 6.h,
                                                endIndent: 11.h,
                                                color: ColorConstants
                                                    .defaultBackgroundColor,
                                              )),
                                          itemCount: info.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return AttendanceContainer(
                                              info: info[index],
                                              participantName:
                                                  info[index].ParticipantName,
                                              age: info[index].Age.toString(),
                                              mobileNumber: info[index].No,
                                            );
                                          });
                                    },
                                    error: (error, stackTrace) {
                                      return Center(
                                          child: Text(
                                              LabelText.defaultErrorMessage));
                                    },
                                    loading: (() => const Center(
                                          child: CircularProgressIndicator(),
                                        )));
                          }),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 25.h,
              ),
              Row(
                children: [
                  Container(
                    color: ColorConstants.defaultWhiteColor,
                    height: 53,
                    width: 103,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LabelText.attendanceMarked,
                                style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 17, 7, 7)),
                              ),
                              Spacer(),
                              Image.asset("assets/markedattendance.png")
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "40  ",
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
                  ),
                  Container(
                    color: Color(0xffEEEEEE),
                    height: 53,
                    width: 103,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LabelText.preSessionsFields,
                                style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 17, 7, 7)),
                              ),
                              Spacer(),
                              Image.asset("assets/presession.png")
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "25  ",
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
                  ),
                  Container(
                    color: ColorConstants.defaultWhiteColor,
                    height: 53,
                    width: 103,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                LabelText.feedbackSessions,
                                style: GoogleFonts.poppins(
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromARGB(255, 17, 7, 7)),
                              ),
                              Spacer(),
                              Image.asset("assets/feedbacksession.png")
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "30 ",
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
                  )
                ],
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.refresh,
            size: 40,
          ),
          backgroundColor: Color(0xff26AA9F),
          onPressed: () {
            /*
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FeedBackScreen()));
                */

            ref.refresh(attendenceMarksheetFutureProvider(''));
            print("refresh");
          }),
    );
  }
}

class ChildScrollWidget extends StatelessWidget {
  const ChildScrollWidget(
      {Key? key, required this.controller, required this.child})
      : super(key: key);
  final Widget child;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification value) {
        if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
          if (controller.offset != 0) controller.jumpTo(0);
          return true;
        }
        if (controller.offset + value.overscroll >=
            controller.position.maxScrollExtent) {
          if (controller.offset != controller.position.maxScrollExtent) {
            controller.jumpTo(controller.position.maxScrollExtent);
          }
          return true;
        }
        controller.jumpTo(controller.offset + value.overscroll);
        return true;
      },
      child: child,
    );
  }
}
