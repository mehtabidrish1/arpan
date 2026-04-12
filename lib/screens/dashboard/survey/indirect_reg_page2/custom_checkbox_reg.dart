import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/style/style1.dart';
import '../../../../table_model/tbl_master_model.dart';
import '../../../../utils/lableText.dart';
import '../../../../widgets/registration_text_field.dart';

class RegCheckBoxGroup extends StatefulWidget {
  final String title;
  final String fieldKey;
  final String fieldOtherKey;
  final ValueChanged<int> update;

  final List<TblMasterModel> content;
  final Map<String, Object> formdata;

  const RegCheckBoxGroup(
      {Key? key,
      required this.fieldKey,
      required this.fieldOtherKey,
      required this.title,
      required this.content,
      required this.formdata,
      required this.update})
      : super(key: key);

  @override
  State<RegCheckBoxGroup> createState() => _RegCheckBoxGroupState();
}

class _RegCheckBoxGroupState extends State<RegCheckBoxGroup> {
  late Map<String, Object> _formdata;
  Map<String, String> checkvalue = {};
  TextEditingController otherController = TextEditingController();

  final dataKey = GlobalKey();
  late String keyvalue;
  late ValueChanged<int> update;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkvalue.clear();
    update = widget.update;

    _formdata = widget.formdata;
    keyvalue = widget.fieldKey;
    if (_formdata.containsKey(keyvalue)) {
      setCheckedValue();
    }
    if (_formdata.containsKey(keyvalue) &&
        !_formdata[keyvalue].toString().toLowerCase().contains('99')) {
      _formdata.remove(widget.fieldOtherKey);
    }
    if (_formdata.containsKey(widget.fieldOtherKey)) {
      otherController.text = _formdata[widget.fieldOtherKey].toString();
    } else {
      otherController.text = '';
    }

    //data = checkedValue(_formdata[keyvalue].toString());
  }

  void setCheckedValue() {
    var allValue = _formdata[keyvalue].toString();
    if (allValue.isNotEmpty) {
      if (allValue.contains(',')) {
        var value = allValue.split(',');
        for (var element in value) {
          checkvalue[element] = element;
        }
      } else {
        checkvalue[allValue] = allValue;
      }
    }
  }

  void getCheckedValue() {
    var allValue = '';
    checkvalue.forEach((key, value) {
      if (allValue.length == 0) {
        allValue = value;
      } else {
        allValue = allValue + ',' + value;
      }
    });
    _formdata[keyvalue] = allValue;
    if (_formdata.containsKey(keyvalue) &&
        !_formdata[keyvalue].toString().toLowerCase().contains('99')) {
      _formdata.remove(widget.fieldOtherKey);
      otherController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(
        widget.fieldKey,
      ),
      children: [
        Text(widget.title, style: Styles.black124),
        SizedBox(
          height: 3.h,
        ),
        for (var item in widget.content) ...{
          CheckboxListTile(
            title: Text(
              '${item.text}',
              style: Styles.grey12500,
            ),
            value: checkvalue.containsKey(item.value),
            onChanged: (value) {
              setState(() {
                if (!value!) {
                  checkvalue.remove(item.value);
                } else {
                  checkvalue[item.value] = item.value;
                }

                getCheckedValue();
                update(1);
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        },
        if (_formdata.containsKey(keyvalue) &&
            _formdata[keyvalue].toString().toLowerCase().contains('99')) ...[
          SizedBox(
            height: 12.h,
          ),
          RegistrationTextField(
            decoration: InputDecoration(border: InputBorder.none),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return LabelText.getText('Otherempty');
              }
              return null;
            },
            textEditingController: otherController,
            title: LabelText.getText('Other'),
            onChanged: (value) {
              _formdata[widget.fieldOtherKey] = value;
            },
          ),
          SizedBox(
            height: 12.h,
          ),
        ]
      ],
    );
  }
}
