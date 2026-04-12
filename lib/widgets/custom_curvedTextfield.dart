import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/constants/style/style2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';

class CurvedTextField extends StatefulWidget {
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final String? title;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final String? hintText;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final InputBorder? border;
  final bool? isReadOnly;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final TextEditingController? controller;
  final double? height;
  final TextAlignVertical? textAlignVertical;
  final bool? isMultiLine;
  final Function()? onTap;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final BoxDecoration? borderDecoration;
  final int? maxlength;
  const CurvedTextField(
      {Key? key,
      this.hintStyle,
      this.borderDecoration,
      this.fillColor,
      this.inputFormatters,
      this.height,
      this.validator,
      this.textAlignVertical = TextAlignVertical.center,
      this.onFieldSubmitted,
      this.controller,
      this.suffixIcon,
      this.obscureText = false,
      required this.onChanged,
      this.focusNode,
      this.textInputAction,
      this.title = '',
      this.hintText,
      this.textInputType = TextInputType.text,
      this.isReadOnly = false,
      this.preffixIcon,
      this.isMultiLine = false,
      this.maxlength,
      this.border,
      // required border,
      this.onTap})
      : super(key: key);

  @override
  State<CurvedTextField> createState() => _CurvedTextFieldState();
}

class _CurvedTextFieldState extends State<CurvedTextField> {
  bool isObscured = false;
  final TextEditingController textEditingController = TextEditingController();
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
    isObscured = widget.obscureText!;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: widget.height,
          // color: Colors.red,
          decoration: widget.borderDecoration ??
              BoxDecoration(
                color: ColorConstants.buttonColor,
                borderRadius: BorderRadius.circular(6.r),
              ),
          child: Center(
            child: TextFormField(
              textAlignVertical: widget.textAlignVertical,
              maxLines: widget.isMultiLine! ? null : 1,
              scrollPadding: EdgeInsets.zero,
              readOnly: widget.isReadOnly!,
              validator: widget.validator,
              focusNode: widget.focusNode,
              maxLength: widget.maxlength ?? 100,
              controller: widget.controller ?? textEditingController,
              autocorrect: false,
              textInputAction: widget.textInputAction ?? TextInputAction.next,
              obscureText: isObscured,
              onChanged: widget.onChanged,
              keyboardType: widget.textInputType,
              inputFormatters: widget.inputFormatters ??
                  [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"[a-zA-Z0-9@.,' ]"))
                  ],
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xff14A49B)),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                border: widget.border ??
                    const OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 1, color: Color(0xff14A49B)),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(40),
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                    ),
                counterText: "",
                isDense: true,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    Styles.defaultFont
                        .copyWith(color: ColorConstants.textFieldTitleColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xff14A49B)),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                fillColor: widget.fillColor ?? ColorConstants.defaultWhiteColor,
                filled: true,
                floatingLabelBehavior:
                    widget.hintText != null && widget.hintText!.isNotEmpty
                        ? FloatingLabelBehavior.always
                        : null,
                label: Text(
                  widget.title!,
                  style: Styles.defaultFont
                      .copyWith(color: ColorConstants.textFieldTitleColor),
                ),
                labelStyle: Theme.of(context).textTheme.bodyLarge,
                prefixIcon: widget.preffixIcon,
                suffixIcon: widget.obscureText!
                    ? InkWell(
                        child: !isObscured
                            ? Icon(
                                Icons.visibility,
                                color: ColorConstants.buttonColor1,
                              )
                            : Icon(Icons.visibility_off,
                                color: ColorConstants.buttonColor1),
                        onTap: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        })
                    : widget.suffixIcon,
              ),
            ),
          ),
        ),
        if (widget.isReadOnly!)
          Positioned.fill(
              child: GestureDetector(
            onTap: widget.onTap,
            child: Container(color: Colors.transparent),
          ))
      ],
    );
  }
}
