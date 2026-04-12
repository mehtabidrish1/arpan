import 'package:arpan/screens/training/hand_holding_schedule_list_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/style/style1.dart';
import '../utils/lableText.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
          child: Container(
        decoration: BoxDecoration(
          color: Color(0xffF7F8FA),
          border: Border.all(color: Color(0xffBABABA)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: 'Session Date',
                text: 'Session Date',
                icon: "assets/date.png",
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: LabelText.attendanceMarked,
                text: 'Session Date',
                icon: "assets/trainingName.png",
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(5),
              child: TrainingTitle(
                title: 'Session Hour',
                text: 'Session Date',
                icon: "assets/Day.png",
              ),
            ),
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Color(0xffFFE5E6),
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffFFE5E6)!,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () async {},
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/batch.png',
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            LabelText.attendence,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        // await showQrCode(trainingBatchsession);
                      },
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/new_qr.png',
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            LabelText.qrcode,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/other_new.png',
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            LabelText.captureImage,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/edit.png',
                            width: 25,
                            height: 25,
                          ),
                          Text(
                            LabelText.edit,
                            style: Styles.black840,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
