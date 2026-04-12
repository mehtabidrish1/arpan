import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/style/style1.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
  var yearmonthList = [
    '2021-22',
    '2022-23',
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              for (var items in yearmonthList) ...{
                Text(
                  items,
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 10.h,
                ),
              }
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var items in monthList) ...{
                          SizedBox(
                            width: 100,
                            height: 50,
                            child: Text(
                              items,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          SizedBox(
                            width: 20.h,
                          )
                        }
                      ],
                    ),
                    for (var items in yearmonthList) ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var items in monthList) ...{
                            SizedBox(
                              width: 100,
                              height: 50,
                              child: Text(
                                items,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 20.h,
                            )
                          }
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    }
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
