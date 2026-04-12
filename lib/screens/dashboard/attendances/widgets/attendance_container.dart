import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Info {
  String ParticipantName;
  int Age;
  String No;
  bool isSelected;
  String id;
  Info(
      {required this.id,
      required this.ParticipantName,
      required this.Age,
      required this.No,
      this.isSelected = false});
}

class AttendanceContainer extends StatelessWidget {
  const AttendanceContainer({
    Key? key,
    required this.info,
    required this.age,
    required this.mobileNumber,
    required this.participantName,
  }) : super(key: key);

  final Info info;
  final String participantName;
  final String mobileNumber;
  final String age;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: 26.w, left: 18.w, top: 12.h, bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RichText(
              text: TextSpan(
                  text: participantName,
                  style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 17, 7, 7)),
                  children: <InlineSpan>[
                TextSpan(
                  text: mobileNumber,
                  style: GoogleFonts.poppins(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 17, 7, 7)),
                )
              ])),
          const Spacer(),
          Text(
            age.toString(),
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 79.w,
          ),
        ],
      ),
    );
  }
}
