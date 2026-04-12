import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class ColorConstants {
  static Color whiteColorText = HexColor('#FFFFFF');
  static Color defaultBackgroundColor = HexColor('#F7F8FA');
  static Color defaultTextColor = HexColor('#333333');
  static Color defaultTextfieldColor = HexColor('#F3F3F3');
  static Color defaultWhiteColor = whiteColorText;
  static Color buttonColor = whiteColorText;
  static Color attendancemarkedcard = HexColor('#F2F5FF');
  static Color presessioncard = HexColor('#FFEFEF');
  static Color feedbacksessioncard = HexColor('#FEFFDA');
  static Color defaultMaroon = HexColor('#D12023');

  static Color buttonColor1 = HexColor('#565656');
  static Color buttonColor2 = HexColor('#C2C2C2');
  static Color greyButtonColor = HexColor('#7D7D7D');
  static Color textFieldTitleColor = HexColor('#B1B1B1');
  static Color defaultRedColor = HexColor('#D71A21');
  static Color defaultCancelColor = HexColor('#C2C2C2');
  static Color defaultGreenColor = HexColor('#26AA9F');

  static Color defaultBlueColor = HexColor('#567DF4');
  static Color defaultYellowColor = HexColor('#FFB110');
  static Color checkBoxGreenColor = HexColor('#81C784');
  static Color checkBoxBlueColor = HexColor('#64B5F6');
  static Color checkBoxOrangeColor = HexColor('#FFB74D');

  static Color defaultBlackColor = HexColor('#000000');
  static Color defaultGreyColor = HexColor('#E4E4E4');
  static Color greyColor1 = const Color(0xffEEEEEE);
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
