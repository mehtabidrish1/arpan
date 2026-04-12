import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/constants/style/style2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';

class DefaultTextField extends StatefulWidget {
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
  final AutovalidateMode? autovalidateMode;
  final TextEditingController? controller;
  final double? height;
  final TextAlignVertical? textAlignVertical;
  final bool? isMultiLine;
  final Function()? onTap;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final BoxDecoration? borderDecoration;
  final int? maxlength;
  const DefaultTextField(
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
      this.autovalidateMode,
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
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
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
                boxShadow: const [
                  // BoxShadow(
                  //   color: Color(0x4d000000),
                  //   offset: Offset(0.0, 1.0),
                  //   blurRadius: 3.0,
                  // ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
          child: Center(
            child: TextFormField(
              textAlignVertical: widget.textAlignVertical,
              maxLines: widget.isMultiLine! ? null : 1,
              scrollPadding: EdgeInsets.zero,
              readOnly: widget.isReadOnly!,
              validator: widget.validator,
              focusNode: widget.focusNode,
              autovalidateMode: widget.autovalidateMode,
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
                        RegExp(r"[a-zA-Z0-9@.,()-_' ]"))
                    // FilteringTextInputFormatter.allow(
                    //     RegExp(r"^[\u0900-\u097F a-zA-Z0-9@.,()_' ]+$"))
                  ],
              decoration: InputDecoration(
                border: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Color(0xff707070)),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                counterText: "",
                isDense: true,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ?? Styles.grey164,
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Color(0xff707070)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // enabledBorder: widget.border ??
                //     OutlineInputBorder(
                //       borderSide:
                //           const BorderSide(width: 1, color: Color(0xff707070)),
                //       borderRadius: BorderRadius.circular(15.0),
                //     ),
                fillColor: ColorConstants.defaultWhiteColor,
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
