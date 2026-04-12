import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/style/style1.dart';
import '../../../../table_model/tbl_master_model.dart';
import '../../../../utils/lableText.dart';
import '../../../../utils/log_files.dart';

class RegRadioGroup extends StatefulWidget {
  final String title;
  final String fieldKey;
  final ValueChanged<int> update;

  final List<TblMasterModel> content;
  final Map<String, dynamic> formdata;

  const RegRadioGroup(
      {Key? key,
      required this.fieldKey,
      required this.title,
      required this.content,
      required this.formdata,
      required this.update})
      : super(key: key);

  @override
  State<RegRadioGroup> createState() => _RegRadioGroupState();
}

class _RegRadioGroupState extends State<RegRadioGroup> {
  @override
  Widget build(BuildContext context) {
    String? pick = '';
    if (widget.formdata.containsKey(widget.fieldKey)) {
      try {
        var data = widget.formdata[widget.fieldKey];

        if (data != null) {
          pick = widget.content
              ?.where((element) => element.value.toString() == data)
              ?.first
              ?.text;
        }
      } catch (error, stackTrace) {
        logError(error, stackTrace);
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: Styles.black124),
        SizedBox(
          height: 3.h,
        ),
        for (var item in widget.content) ...{
          Container(
            height: 35,
            child: RadioListTile(
              value: item.text,
              groupValue: pick,
              title: Text(item.text),
              onChanged: (checked) async {
                print(checked);
                FocusScope.of(context).requestFocus(FocusNode());
                String master = checked as String;
                widget.formdata[widget.fieldKey] = widget.content
                    .where((element) => element.text == master)
                    .first
                    .value;

                widget.update(1);
              },
              selected: pick == item.text,
              // activeColor:
            ),
          ),
        }
      ],
    );
  }
}
