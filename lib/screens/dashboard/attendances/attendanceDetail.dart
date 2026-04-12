import 'package:arpan/database/dataProvider.dart';
import 'package:arpan/models/training_schedule_participant_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/style/style1.dart';
import '../../../models/training_registration.dart';
import '../../../table_model/tbl_training_registration_model.dart';
import '../../../utils/lableText.dart';

class AttendanceDetail extends StatefulWidget {
  AttendanceDetail({Key? key, this.trainingRegistration, required this.title})
      : super(key: key);
  final TblTrainingRegistration? trainingRegistration;
  String title;

  @override
  State<AttendanceDetail> createState() => _AttendanceDetailState();
}

class _AttendanceDetailState extends State<AttendanceDetail> {
  List<TrainingScheduleParticipantModel> participantList = [];

  getData() async {
    var list = await DataProvider().getTrainingParticipant();
    if (widget.title == LabelText.totalRegistered) {
      participantList = list;
      // .where((element) =>
      //     element.scheduleGuid == widget.trainingRegistration!.scheduleGuid)
      // .toList();
    } else {}
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstants.defaultBackgroundColor,
          title: Text(widget.title, style: Styles.black145),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color: ColorConstants.defaultWhiteColor),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Text(
                LabelText.participantName,
                style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xffD71A21)),
              ),
            ),
            Expanded(
              child: ListView.separated(
                  primary: true,
                  separatorBuilder: ((context, index) => Divider(
                        thickness: 1.h,
                        indent: 6.h,
                        endIndent: 11.h,
                        color: ColorConstants.defaultGreyColor,
                      )),
                  itemCount: participantList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          right: 26.w, left: 18.w, top: 12.h, bottom: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                              text: TextSpan(
                            text: '${participantList[index].fullName}',
                            style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 17, 7, 7)),
                          )),
                          RichText(
                              text: TextSpan(
                            text: participantList[index].phoneNo,
                            style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 17, 7, 7)),
                          )),
                        ],
                      ),
                    );
                  }),
            )
          ]),
        ));
  }
}
