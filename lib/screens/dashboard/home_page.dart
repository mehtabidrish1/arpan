import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/registration_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 28.w,
              ),
              Text(
                "Welcome 👋",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Color(0xff000000),
                ),
              ),
              Text(
                "Let’s order and enjoy your order now.",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xff000000),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              RegistrationTextField(
                subTitle: 'Type something...',
                onChanged: (value) {},
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
                suffexIcon: SizedBox(
                  width: 16.w,
                  height: 14.h,
                  child: Center(
                    child: Image.asset(
                      ImageConstants.filterIcon,
                      width: 16.w,
                      height: 14.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 19,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        "Tab1",
                      ),
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: Color(0xff000000)
                          // backgroundColor: Colors.red,
                          // elevation: 2,
                          ),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        "Tab2",
                      ),
                      onPressed: () {
                        style:
                        TextButton.styleFrom(
                          foregroundColor: Colors.purpleAccent, // Text Color
                        );
                      },
                      style: TextButton.styleFrom(foregroundColor: Color(0xff000000)
                          // backgroundColor: Colors.red,
                          // elevation: 2,
                          ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextButton(
                      child: Text(
                        "Tab3",
                      ),
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: Color(0xff000000)
                          // backgroundColor: Colors.red,
                          // elevation: 2,
                          ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextButton(
                      child: Text(
                        "Tab4",
                      ),
                      onPressed: () {},
                      style: TextButton.styleFrom(foregroundColor: Color(0xff000000)
                          // backgroundColor: Colors.red,
                          // elevation: 2,
                          ),
                    ),
                  ),
                ],
              ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (_) => const AttendanceScreen()));
              //   },
              //   child: Text("Attendance"),
              // ),
              // TextButton(
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (_) => const EventPage()));
              //   },
              //   child: Text("Event Page"),
              // ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 142,
                        width: 145,
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: ColorConstants.defaultWhiteColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Option 1",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Container(
                        height: 179,
                        width: 145,
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: ColorConstants.defaultWhiteColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Option 3",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 179,
                        width: 145,
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: ColorConstants.defaultWhiteColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Option 2",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      Container(
                        height: 142,
                        width: 145,
                        alignment: Alignment.bottomLeft,
                        decoration: BoxDecoration(
                            color: ColorConstants.defaultWhiteColor,
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Option 4",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff000000),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
