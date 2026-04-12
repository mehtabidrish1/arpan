import 'package:arpan/utils/lableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/style/style1.dart';
import 'default_text_field.dart';

class RegistrationTextField extends StatelessWidget {
  final String title;
  final String? subTitle;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  final bool obsucreText;
  final bool isReadOnly;
  final Widget? suffexIcon;
  final Widget? preffixIcon;
  final TextEditingController? textEditingController;
  final double? width;
  final AutovalidateMode? autovalidateMode;
  final double? height;
  final bool? redStar;
  final TextAlignVertical? textAlignVertical;
  final bool? isTitleAnimated;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final decoration;
  final bool? isMultiLine;
  final int? maxlength;

  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  final Function()? onTap;
  const RegistrationTextField({
    Key? key,
    required this.onChanged,
    required this.title,
    this.obsucreText = false,
    this.isTitleAnimated = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.preffixIcon,
    this.subTitle,
    this.decoration,
    this.suffexIcon,
    this.autovalidateMode,
    this.redStar = false,
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
    this.maxlength,
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
      child: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) ...[
              redStar! ? impText(title) : Text(title, style: Styles.black124),
              SizedBox(
                height: 3.h,
              )
            ],
            SizedBox(
              // height: height ?? 48.h,
              child: DefaultTextField(
                onTap: onTap,
                inputFormatters: inputFormatters,
                validator: validator,
                textInputAction: textInputAction,
                textAlignVertical: textAlignVertical,
                height: height,
                autovalidateMode: autovalidateMode,
                preffixIcon: preffixIcon,
                controller: textEditingController,
                isReadOnly: isReadOnly,
                title: isTitleAnimated! ? subTitle : '',
                hintStyle: Styles.grey164,
                hintText: isTitleAnimated!
                    ? null
                    : subTitle ??
                        LabelText.getText(
                            'textFieldHintText'), // textFieldHintText,
                onChanged: onChanged,
                textInputType: textInputType,
                obscureText: obsucreText,
                suffixIcon: suffexIcon,
                focusNode: focusNode,
                // border: decoration,
                isMultiLine: isMultiLine,
                maxlength: maxlength,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
