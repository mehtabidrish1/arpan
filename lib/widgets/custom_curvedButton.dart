import 'package:arpan/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CurvedButton extends StatelessWidget {
  final String buttonTitle;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color? buttonColor;
  final TextStyle? style;
  const CurvedButton(
      {Key? key,
      required this.buttonTitle,
      this.style,
      this.width,
      this.height,
      this.onPressed,
      this.buttonColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 27.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor ?? ColorConstants.defaultMaroon,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8))),
          ),
          onPressed: onPressed,
          child: Text(
            buttonTitle,
            style: style,
            textAlign: TextAlign.center,
          )),
    );
  }
}
