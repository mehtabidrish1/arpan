import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/default_dorp_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';
import '../constants/style/style1.dart';

class RegistrationDropDown extends StatelessWidget {
  final String title;
  final String? subTitle;
  final StringCallBack onChanged;
  final TextInputType? textInputType;
  final bool obsucreText;
  final bool isReadOnly;
  final Widget? suffexIcon;
  final Widget? preffixIcon;
  final TextEditingController? textEditingController;
  final double? width;
  final bool? redStar;
  final double? height;
  final TextAlignVertical? textAlignVertical;
  final bool? isTitleAnimated;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final decoration;
  final bool? isMultiLine;
  final List<String> items;

  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;
  final Function()? onTap;
  const RegistrationDropDown({
    Key? key,
    required this.onChanged,
    required this.title,
    this.obsucreText = false,
    this.isTitleAnimated = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.preffixIcon,
    this.subTitle,
    this.decoration,
    this.redStar=false,
    this.suffexIcon,
    this.textInputType = TextInputType.text,
    this.isReadOnly = false,
    this.width,
    this.textEditingController,
    this.height,
    this.textInputAction,
    this.validator,
    this.focusNode,
    this.isMultiLine = false,
    this.inputFormatters,
    this.onTap,
    required this.items,
    required this.initialValue,
  }) : super(key: key);

  Widget impText(String text, {TextStyle? textStyle}) {
    return RichText(
        text: TextSpan(
            text: "*",
            style: const TextStyle(color: Colors.red),
            children: <InlineSpan>[
          TextSpan(
            text: text,
            style: textStyle ?? Styles.black124,
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            redStar! ? impText(title) : Text(title, style: Styles.black124),
            SizedBox(
              height: 3.h,
            )
          ],
          DefaultDropDown(
            textEditingController: textEditingController,
            initialValue: initialValue,
            items: items,
            onTap: onTap,
            validator: validator,
            height: height,
            title: isTitleAnimated ?? false ? subTitle : '',
            // hintText: isTitleAnimated??false
            //     ? null
            //     : subTitle ?? LabelText.textFieldHintText,
            hintText: subTitle,
            onChanged: onChanged,
            focusNode: focusNode,
          ),
        ],
      ),
    );
  }
}
