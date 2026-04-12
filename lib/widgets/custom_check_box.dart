import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/color_constants.dart';
import '../constants/style/style1.dart';

typedef IntCallBack = void Function(int val);

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    required this.title,
    required this.callback,
  }) : super(key: key);
  final List<String> title;
  final IntCallBack callback;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool checkedStatus = false;
  List<bool> checkBoxesStatus = [];
  generateCheckBoxStatus(List<String> title) {
    List<bool> checkBoxesStatus = [];
    for (var i = 0; i < title.length; i++) {
      if (i == 0) {
        checkBoxesStatus.add(true);
      } else {
        checkBoxesStatus.add(false);
      }
    }
    return checkBoxesStatus;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!checkedStatus) {
      checkBoxesStatus = generateCheckBoxStatus(widget.title);
      checkedStatus = true;
      widget.callback(widget.title.indexOf(widget.title[0]));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        for (var each in widget.title) ...[
          GestureDetector(
            onTap: () {
              for (var i = 0; i < widget.title.length; i++) {
                if ((widget.title.indexOf(each) == i)) {
                  checkBoxesStatus[widget.title.indexOf(each)] = true;
                  widget.callback(i);
                } else {
                  checkBoxesStatus[i] = false;
                }
              }

              setState(() {});
            },
            child: IndividualCheckBox(
              checkedStatus: checkBoxesStatus[widget.title.indexOf(each)],
              title: each,
              color: each == widget.title.first
                  ? ColorConstants.checkBoxGreenColor
                  : each == widget.title.last
                      ? ColorConstants.checkBoxBlueColor
                      : ColorConstants.checkBoxOrangeColor,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ],
    );
  }
}

class IndividualCheckBox extends StatelessWidget {
  const IndividualCheckBox({
    Key? key,
    required this.checkedStatus,
    required this.title,
    this.color,
  }) : super(key: key);

  final bool checkedStatus;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Styles.defaultFont.copyWith(fontWeight: FontWeight.w500),
        ),
        SizedBox(
          width: 5.w,
        ),
        Container(
          height: 20.h,
          width: 20.h,
          decoration: BoxDecoration(
            color: color ?? ColorConstants.checkBoxGreenColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: checkedStatus
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 15.h,
                )
              : const SizedBox.shrink(),
        )
      ],
    );
  }
}
