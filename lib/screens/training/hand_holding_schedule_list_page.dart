import 'package:arpan/database/dataProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/custom_curvedTextfield.dart';
import '../dashboard/dashboard_screen.dart';

class HandHoldingScheduleListPage extends StatefulWidget {
  const HandHoldingScheduleListPage({Key? key}) : super(key: key);

  @override
  State<HandHoldingScheduleListPage> createState() =>
      _HandHoldingScheduleListPageState();
}

class _HandHoldingScheduleListPageState
    extends State<HandHoldingScheduleListPage> {
  TextEditingController controller = TextEditingController();
  var mainTrainingScheduleList = <TblTrainingSchedule>[];
  var fillTrainingScheduleList = <TblTrainingSchedule>[];
  final ScrollController scrcontroller = ScrollController();
  final today = DateTime.now();
  var isDisposed = false;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      var userInfo = await UserInfo().getUserCredentials();
      String userid = userInfo['email'];
      mainTrainingScheduleList =
          await DataProvider().getTrainingSchedule(userid);

      fillTrainingScheduleList = mainTrainingScheduleList
          .where((schedule) =>
              DateTime(today.year, today.month,
                                                    today.day)
                                                .compareTo(DateTime.parse(
                                                   schedule.lastDate!)) ==
                                            1 &&
              schedule.trainingType == '1')
          .toList();
      setState(() {
        isDisposed = true;
      });
    }
  }

  Future<void> onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      //  _patientEnrollmentAll = widget._patientEnrollment;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    fillTrainingScheduleList = mainTrainingScheduleList
        .where((element) =>
            (element.trainingName!.toLowerCase().contains(text.toLowerCase())))
        .toList();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 300.w,
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  isDisposed = true;
                  await Navigator.popAndPushNamed(
                    context,
                    RouteConstants.dashboardScreen,
                  );
                },
              ),
              Text(
                LabelText.trainingHandHolding,
                style:
                    Styles.red164.copyWith(color: ColorConstants.defaultMaroon),
              )
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/rightButterflyTheme.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  CurvedTextField(
                    height: 38.h,
                    controller: controller,
                    onChanged: onSearchTextChanged,
                    preffixIcon: const Icon(
                      Icons.search,
                      size: 28,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearchTextChanged('');

                          fillTrainingScheduleList = mainTrainingScheduleList;
                          setState(() {});
                        },
                        icon: const Icon(Icons.cancel_outlined)),
                    hintText: 'Search',
                    hintStyle: Styles.grey164,
                  ),
                  SizedBox(height: 10.h),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      controller: scrcontroller,
                      physics: const ClampingScrollPhysics(),
                      itemCount: fillTrainingScheduleList.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        final _trainingSchedule =
                            fillTrainingScheduleList[index];

                        if (_trainingSchedule == null) return null;

                        return GestureDetector(
                          onTap: () async {
                            isDisposed = true;
                            await Navigator.popAndPushNamed(
                              context,
                              RouteConstants.handholdingreglist,
                              arguments: _trainingSchedule,
                            );
                          },
                          child: listCard(_trainingSchedule, index),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listCard(TblTrainingSchedule trainingSchedule, int index) {
    return Card(
        // color: (index + 1) % 2 == 1 ? Colors.white : Color(0xffFFF7F7),
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color(0xff707070),
              width: 1), // set the border color and width
          borderRadius: BorderRadius.circular(20),
        ), // add some shadow to the card
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(
        //       color: DateTime.parse(trainingSchedule.firstDate!).isAfter(today)
        //           ? ColorConstants.checkBoxOrangeColor
        //           : today.isAfter(DateTime.parse(trainingSchedule.lastDate!))
        //               ? Color(0xffBABABA)
        //               : Color(0xffBABABA),
        //       width: 1), // set the border color and width
        //   borderRadius:
        //       BorderRadius.circular(8), // set the border radius of the card
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TrainingTitle(
                title: 'Training Name',
                text: trainingSchedule.trainingName,
                icon: "assets/trainingName.png",
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                icon: "assets/topicCovered.png",
                title: LabelText.topicCovered,
                text: trainingSchedule.topicsCoveredName,
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: 'Theme',
                text: trainingSchedule.trainingTheme,
                icon: "assets/theme.png",
              ),
            ],
          ),
        ));
  }
}

class TrainingTitle extends StatelessWidget {
  const TrainingTitle({
    Key? key,
    this.icon,
    this.text,
    this.title,
  }) : super(key: key);
  final String? title;
  final String? text;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          '$icon',
          // height: 15.h,
          scale: 3.3,
        ),
        SizedBox(
          width: 4.w,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '$title :',
            style:
                Styles.greyp124.copyWith(color: ColorConstants.defaultMaroon),
          ),
        ),
        // Spacer(),
        Expanded(
          // flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AutoSizeText(
              ' $text',
              maxLines: 10,
              style: Styles.black124,
            ),
          ),
        ),
      ],
    );
  }
}
