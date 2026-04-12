import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../constants/route_constants.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isTrainer = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            height: 640.h,
            child: Stack(children: [
              Positioned(
                top: -6.h,
                right: -11.w,
                child: Image.asset(
                  ImageConstants.loginTopImage,
                  width: 300.w,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: 190.h,
                right: 0,
                left: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: CustomButton(
                              buttonTitle: LabelText.trainer,
                              textColor: isTrainer
                                  ? ColorConstants.whiteColorText
                                  : ColorConstants.defaultTextColor,
                              textFontWeight:
                                  isTrainer ? FontWeight.w600 : FontWeight.w400,
                              buttonColor: isTrainer
                                  ? ColorConstants.buttonColor1
                                  : ColorConstants.buttonColor,
                              onPressed: () {
                                setState(() {
                                  isTrainer = true;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Expanded(
                            child: CustomButton(
                              buttonTitle: LabelText.participant,
                              onPressed: () {
                                setState(() {
                                  isTrainer = false;
                                });
                              },
                              textColor: !isTrainer
                                  ? ColorConstants.whiteColorText
                                  : ColorConstants.defaultTextColor,
                              buttonColor: !isTrainer
                                  ? ColorConstants.buttonColor1
                                  : ColorConstants.buttonColor,
                              textFontWeight: !isTrainer
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 21.h,
                      ),
                      Text(
                        LabelText.arpan,
                        style: Styles.black145.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        LabelText.developParagraph,
                        style: Styles.defaultFont,
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                            strutStyle: StrutStyle.fromTextStyle(
                                TextStyle(height: 1.1.h)),
                            text: TextSpan(
                                text: LabelText.otpNo,
                                style: Styles.defaultFont,
                                children: <InlineSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (BuildContext
                                        //                 context) =>
                                        //             const RegistrationScreen()));
                                        Navigator.pushNamed(context,
                                            RouteConstants.registrationScreen);
                                      },
                                    text: "+91 9345657896",
                                    style: Styles.defaultFont.copyWith(
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12.sp),
                                  )
                                ])),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Pinput(
                        length: 5,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        showCursor: true,
                        validator: (s) {
                          print('validating code: $s');
                        },
                        onCompleted: null,
                      ),
                      SizedBox(
                        height: 25.h,
                      ),
                      CustomButton(
                        buttonColor: ColorConstants.defaultRedColor,
                        textColor: ColorConstants.whiteColorText,
                        buttonTitle: LabelText.submit,
                        height: 48.h,
                        onPressed: () {
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (_) => const RegistrationScreen()));

                          Navigator.pushReplacementNamed(
                              context, RouteConstants.registrationScreen);
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                            strutStyle: StrutStyle.fromTextStyle(
                                TextStyle(height: 1.1.h)),
                            text: TextSpan(
                                text: LabelText.dontHaveAccount,
                                style: Styles.defaultFont,
                                children: <InlineSpan>[
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (BuildContext
                                        //                 context) =>
                                        //             const RegistrationScreen()));

                                        Navigator.pushNamed(context,
                                            RouteConstants.registrationScreen);
                                      },
                                    text: LabelText.signUp,
                                    style: Styles.defaultFont.copyWith(
                                        color: ColorConstants.defaultRedColor,
                                        fontSize: 14.sp),
                                  )
                                ])),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
