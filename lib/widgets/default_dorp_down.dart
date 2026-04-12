import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';
import '../constants/style/style1.dart';

typedef StringCallBack = void Function(String? val);

class DefaultDropDown extends StatefulWidget {
  final StringCallBack onChanged;

  final String? Function(String?)? validator;
  final String? title;
  final FocusNode? focusNode;
  final String? hintText;
  final double? height;
  final String? initialValue;
  final List<String>? items;
  final TextEditingController? textEditingController;
  final Function()? onTap;

  const DefaultDropDown({
    Key? key,
    this.height,
    this.validator,
    required this.onChanged,
    this.focusNode,
    this.title,
    this.hintText,
    this.onTap,
    required this.initialValue,
    required this.items,
    this.textEditingController,
  }) : super(key: key);

  @override
  State<DefaultDropDown> createState() => _DefaultDropDownState();
}

class _DefaultDropDownState extends State<DefaultDropDown> {
  bool isObscured = false;
  final TextEditingController textEditingController = TextEditingController();
  String? initialValue;
  bool shouldValidate = false;
  var items = [''];
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // List<String> items1 = [widget.initialValue!];
    if (widget.textEditingController?.text == '') {
      initialValue = widget.initialValue;
    } else {
      initialValue = widget.textEditingController?.text;
    }

    for (var each in widget.items ?? []) {
      if (each.toString().toLowerCase() !=
          initialValue.toString().toLowerCase()) items.add(each);
    }
    if (initialValue != null && initialValue!.isNotEmpty) {
      if ((widget.items ?? []).isNotEmpty) {
        if (widget.items!.contains(initialValue)) {
        } else {
          widget.items?.insert(0, initialValue!);
        }
        items = widget.items ?? [];
      }
    }

    if (initialValue!.isNotEmpty) {
      if (items.indexOf(initialValue!) != 0) {
        textEditingController.text = initialValue!;
        shouldValidate = false;
      } else {
        shouldValidate = true;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     if (widget.textEditingController!.text == '') {
      initialValue = widget.initialValue;
    } else {
      initialValue = widget.textEditingController!.text;
    }
    items = widget.items ?? [];
    // List of items in our dropdown menu
    return Stack(
      children: [
        Container(
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
          // color: Colors.red,
           decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xff707070), width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x4d000000),
                                      offset: Offset(0.0, 1.0),
                                      blurRadius: 3.0,
                                    ),
                                  ], //border of dropdown button
                                  borderRadius: BorderRadius.circular(15),
                                ),
          child: Center(
            child: Stack(
              children: [
                TextFormField(
                  validator: shouldValidate ? widget.validator : null,
                  readOnly: true,
                  style: TextStyle(color: Colors.transparent),
                  controller: widget.textEditingController,
                  // controller: widget.textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintStyle:
                        Styles.defaultFont.copyWith(color: Colors.transparent),
                    labelStyle:
                        Styles.defaultFont.copyWith(color: Colors.transparent),
                  ),
                ),
                DropdownButton(
                  isExpanded: true,
                  value: initialValue,
                 underline: Container(),
                  // Down Arrow Icon
                  icon: const Icon(Icons.keyboard_arrow_down),

                  // Array list of items
                  items: items.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item,
                          style: Styles.black164,),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      int index = items.indexOf(newValue);
                      setState(() {
                        initialValue = newValue;
                      });
                      if (index == 0) {
                        widget.onChanged(null);
                        widget.textEditingController!.clear();
                        shouldValidate = true;
                        setState(() {});
                      } else {
                        widget.textEditingController!.text = newValue;
                      }
                      if (index != 0) widget.onChanged(index.toString());
                    } else {
                      widget.textEditingController!.clear();
                      shouldValidate = true;
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
