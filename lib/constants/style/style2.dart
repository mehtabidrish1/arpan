import 'package:flutter/material.dart';

class Style {
  TextStyle extend(
    TextStyle headerstyle,
    TextStyle textStyle,
  ) {
    return headerstyle.merge(textStyle);
  }
}
