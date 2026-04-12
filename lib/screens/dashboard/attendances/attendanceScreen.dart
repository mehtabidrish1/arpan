import 'dart:developer';

import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_qr_code_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/registration_text_field.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  dialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(left: 19.w, right: 19.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0.r))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 310.w,
                  ),
                  Text(
                    "Manual Code Type",
                    style: Styles.black145,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.r),
                        border: Border.all(
                            color: ColorConstants.textFieldTitleColor)),
                    child: RegistrationTextField(
                      title: '',
                      subTitle: 'Enter your code here...',
                      textInputType: TextInputType.text,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          buttonTitle: LabelText.submit,
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                RouteConstants.attendenceListScreen,
                                (Route<dynamic> route) => false);
                          },
                          textColor: ColorConstants.whiteColorText,
                          textFontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: CustomButton(
                          buttonTitle: LabelText.cancel,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          textColor: ColorConstants.whiteColorText,
                          buttonColor: ColorConstants.defaultCancelColor,
                          textFontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  String qrValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                // Center(
                //   child: InkWell(
                //     onTap: () {
                //       Navigator.of(context)
                //           .pushNamed(RouteConstants.attendenceListScreen);
                //     },
                //     child: Text(
                //       LabelText.attendence,
                //       style: Styles.black145,
                //     ),
                //   ),
                // ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Container(
                    height: 38,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: ColorConstants.defaultWhiteColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            var data = await showDialog(
                                context: context,
                                builder: ((context) =>
                                    CustomQRCodeScanner(callback: (value) {
                                      log(value.code.toString(),
                                          name: 'Barcode code');
                                      log(value.format.name.toString(),
                                          name: 'Barcode fprmat name');
                                      if (value.format.name == 'qrcode') {
                                        qrValue = value.code ?? '';
                                      }
                                    })));
                            if (data != null) {
                              qrValue = data;
                            }
                            await showDialog(
                                context: context,
                                builder: (_) => Container(
                                      height: 100.h,
                                      width: 300.w,
                                      color: Colors.white,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Center(
                                              child: Text(
                                                  'Registration guid: ' +
                                                      qrValue),
                                            ),
                                            CustomButton(
                                              buttonTitle: 'Close',
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorConstants.defaultGreenColor,
                                borderRadius: BorderRadius.circular(2.r)),
                            padding: EdgeInsets.all(5.w),
                            child: Image.asset(
                              "assets/scanner.png",
                              filterQuality: FilterQuality.high,
                              width: 20.8.w,
                              color: ColorConstants.whiteColorText,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          "or ",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Color.fromRGBO(0, 0, 0, 0.65),
                          ),
                        ),
                        Text(" Add Manually",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.65))),
                        InkWell(
                          onTap: () {
                            dialog();
                          },
                          child: Text(
                            " Click here",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 8,
                              color: Color(0xffD71A21),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
