import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/style/style1.dart';
import '../../../../utils/lableText.dart';

class RegCheckBoxYearMonthGroup extends StatefulWidget {
  final String title;
  final String fieldKey;
  final ValueChanged<int> update;

  final List<String> content;
  final Map<String, dynamic> formdata;

  const RegCheckBoxYearMonthGroup(
      {Key? key,
      required this.fieldKey,
      required this.title,
      required this.content,
      required this.formdata,
      required this.update})
      : super(key: key);

  @override
  State<RegCheckBoxYearMonthGroup> createState() =>
      _RegCheckBoxYearMonthGroupState();
}

class _RegCheckBoxYearMonthGroupState extends State<RegCheckBoxYearMonthGroup> {
  var monthList = [
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
    'Jan',
    'Feb',
    'Mar',
  ];
  late Map<String, bool> checkvalue = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.formdata.containsKey(widget.fieldKey)) {
      checkvalue = widget.formdata[widget.fieldKey];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (widget.content.length * 60) + 100,
      color: Colors.white,
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              for (var items in widget.content) ...{
                SizedBox(
                    width: 60,
                    height: 40,
                    child: Center(
                      child: Text(
                        items,
                        style: TextStyle(fontSize: 16),
                      ),
                    )),
                SizedBox(
                  height: 20.h,
                ),
              }
            ],
          ),
          SizedBox(
            width: 50,
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (var items in monthList) ...{
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: Text(
                                  items,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.h,
                            )
                          }
                        ],
                      ),
                      for (var items in widget.content) ...{
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (var item1 in monthList) ...{
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Transform.scale(
                                  scale: 2,
                                  child: Checkbox(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    value: checkvalue
                                        .containsKey('${items}#$item1'),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value!) {
                                          checkvalue['${items}#$item1'] = value;
                                        } else {
                                          checkvalue.remove('${items}#$item1');
                                        }
                                      });

                                      widget.formdata[widget.fieldKey] =
                                          checkvalue;
                                      // widget.update(1);
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.h,
                              )
                            }
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      }
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
