import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String buttonTitle;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final FontWeight? textFontWeight;
  final Color? textColor;
  const CustomButton(
      {Key? key,
      required this.buttonTitle,
      this.width,
      this.height,
      this.onPressed,
      this.buttonColor,
      this.textColor,
      this.textFontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 27.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? ColorConstants.buttonColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          onPressed: onPressed,
          child: Text(
            buttonTitle,
            style: textFontWeight != null && textColor != null
                ? Styles.defaultButtonNormalFont
                    .copyWith(fontWeight: textFontWeight, color: textColor)
                : textFontWeight != null && textColor == null
                    ? Styles.defaultButtonNormalFont
                        .copyWith(fontWeight: textFontWeight)
                    : textFontWeight == null && textColor != null
                        ? Styles.defaultButtonNormalFont.copyWith(
                            fontWeight: textFontWeight, color: textColor)
                        : Styles.defaultButtonNormalFont,
            textAlign: TextAlign.center,
          )),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  final String buttonTitle;
  final Function()? onPressed;
  final double? width;
  final double? height;

  final FontWeight? textFontWeight;
  final Color? textColor;
  const CustomElevatedButton(
      {Key? key,
      required this.buttonTitle,
      this.width,
      this.height,
      this.onPressed,
      this.textColor,
      this.textFontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: LinearGradient(
            colors: [Color(0xffF97378), Color(0xffD91E25)],
          )),
      width: width ?? double.infinity,
      height: height ?? 27.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          onPressed: onPressed,
          child: Text(
            buttonTitle,
            style: textFontWeight != null && textColor != null
                ? Styles.defaultButtonNormalFont
                    .copyWith(fontWeight: textFontWeight, color: textColor)
                : textFontWeight != null && textColor == null
                    ? Styles.defaultButtonNormalFont
                        .copyWith(fontWeight: textFontWeight)
                    : textFontWeight == null && textColor != null
                        ? Styles.defaultButtonNormalFont.copyWith(
                            fontWeight: textFontWeight, color: textColor)
                        : Styles.defaultButtonNormalFont,
            textAlign: TextAlign.center,
          )),
    );
  }
}
