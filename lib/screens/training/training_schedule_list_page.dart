import 'package:arpan/database/dataProvider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constants/color_constants.dart';
import '../../constants/route_constants.dart';
import '../../constants/style/style1.dart';
import '../../table_model/tbl_training_schedule_model.dart';
import '../../utils/common.dart';
import '../../utils/lableText.dart';
import '../../widgets/custom_check_box.dart';
import '../../widgets/custom_curvedTextfield.dart';
import '../dashboard/dashboard_screen.dart';

class TrainingScheduleListPage extends StatefulWidget {
  const TrainingScheduleListPage({Key? key}) : super(key: key);

  @override
  State<TrainingScheduleListPage> createState() =>
      _TrainingScheduleListPageState();
}

class _TrainingScheduleListPageState extends State<TrainingScheduleListPage> {
  int selectedTextIndex = 0;
  int selectedIndex = -1;
  int index = 0;
  TextEditingController controller = TextEditingController();
  var mainTrainingScheduleList = <TblTrainingSchedule>[];
  var fillTrainingScheduleList = <TblTrainingSchedule>[];
  var upcomingTrainingScheduleList = <TblTrainingSchedule>[];
  var completeTrainingScheduleList = <TblTrainingSchedule>[];
  final ScrollController scrcontroller = ScrollController();
  final today = DateTime.now();
  var isDisposed = false;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isDisposed) {
      DateTime currentDate = DateTime.now().toLocal();

      var userInfo = await UserInfo().getUserCredentials();
      String userid = userInfo['email'];
      mainTrainingScheduleList =
          await DataProvider().getTrainingSchedule(userid);

      fillTrainingScheduleList = mainTrainingScheduleList
          .where((e) =>
              DateTime(today.year, today.month, today.day)
                      .compareTo(DateTime.parse(e.firstDate!)) >
                  -1 &&
              DateTime(today.year, today.month, today.day)
                      .compareTo(DateTime.parse(e.lastDate!)) <
                  1)
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
    if (selectedTextIndex == 1) {
      fillTrainingScheduleList = upcomingTrainingScheduleList
          .where((element) => (element.trainingName!
              .toLowerCase()
              .contains(text.toLowerCase())))
          .toList();
    } else if (selectedTextIndex == 2) {
      fillTrainingScheduleList = completeTrainingScheduleList
          .where((element) => (element.trainingName!
              .toLowerCase()
              .contains(text.toLowerCase())))
          .toList();
    } else {
      fillTrainingScheduleList = mainTrainingScheduleList
          .where((e) =>
              e.trainingName!.toLowerCase().contains(text.toLowerCase()) &&
              DateTime(today.year, today.month, today.day)
                      .compareTo(DateTime.parse(e.firstDate!)) >
                  -1 &&
              DateTime(today.year, today.month, today.day)
                      .compareTo(DateTime.parse(e.lastDate!)) <
                  1)
          .toList();
    }

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DashboardScreen()));
                },
              ),
              Text(
                "Training",
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

                          if (selectedTextIndex == 0) {
                            fillTrainingScheduleList = mainTrainingScheduleList
                                .where((e) =>
                                    DateTime(today.year, today.month, today.day)
                                            .compareTo(
                                                DateTime.parse(e.firstDate!)) >
                                        -1 &&
                                    DateTime(today.year, today.month, today.day)
                                            .compareTo(
                                                DateTime.parse(e.lastDate!)) <
                                        1)
                                .toList();
                          } else if (selectedTextIndex == 1) {
                            fillTrainingScheduleList =
                                upcomingTrainingScheduleList;
                          } else if (selectedTextIndex == 2) {
                            fillTrainingScheduleList =
                                completeTrainingScheduleList;
                          } else {
                            fillTrainingScheduleList = mainTrainingScheduleList;
                          }

                          setState(() {});
                        },
                        icon: const Icon(Icons.cancel_outlined)),
                    hintText: 'Search',
                    hintStyle: Styles.grey164,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 30.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.clear();
                              onSearchTextChanged('');
                              setState(() {
                                selectedTextIndex = 0;
                                fillTrainingScheduleList =
                                    mainTrainingScheduleList
                                        .where((e) =>
                                            DateTime(today.year, today.month,
                                                        today.day)
                                                    .compareTo(DateTime.parse(
                                                        e.firstDate!)) >
                                                -1 &&
                                            DateTime(today.year, today.month,
                                                        today.day)
                                                    .compareTo(DateTime.parse(
                                                        e.lastDate!)) <
                                                1)
                                        .toList();
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedTextIndex == 0
                                    ? const Color(0xff006476)
                                    : const Color(0xff14A49B),
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Text('Inprogress', style: Styles.white146),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.clear();
                              onSearchTextChanged('');
                              setState(() {
                                selectedTextIndex = 1;
                                fillTrainingScheduleList =
                                    mainTrainingScheduleList
                                        .where((schedule) =>
                                            DateTime.parse(schedule.firstDate!)
                                                .isAfter(today))
                                        .toList();
                                upcomingTrainingScheduleList =
                                    fillTrainingScheduleList;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedTextIndex == 1
                                    ? const Color(0xff006476)
                                    : const Color(0xff14A49B),
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                'Upcoming',
                                style: Styles.white146,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              controller.clear();
                              onSearchTextChanged('');
                              setState(() {
                                selectedTextIndex = 2;
                                /* fillTrainingScheduleList =
                                    mainTrainingScheduleList
                                        .where((schedule) => today.isAfter(
                                            DateTime.parse(schedule.lastDate!)))
                                        .toList();*/
                                var aa = DateTime(
                                        today.year, today.month, today.day)
                                    .compareTo(DateTime.parse('2024-01-12'));
                                print(aa);
                                fillTrainingScheduleList =
                                    mainTrainingScheduleList
                                        .where((e) =>
                                            DateTime(today.year, today.month,
                                                    today.day)
                                                .compareTo(DateTime.parse(
                                                    e.lastDate!)) ==
                                            1)
                                        .toList();

                                completeTrainingScheduleList =
                                    fillTrainingScheduleList;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedTextIndex == 2
                                    ? const Color(0xff006476)
                                    : const Color(0xff14A49B),
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Text(
                                'Completed',
                                style: Styles.white146,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
                              RouteConstants.trainingBatchList,
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

  Widget buildText(int index, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: const Color(0xffEFEFEF),
        ),
        width: 300,
        height: 36,
        child: Container(
          width: 300,
          height: 36,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? const Color(0xff80C785)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "poppins",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: selectedIndex == index
                    ? Colors.white
                    : const Color(0xffA5A5A580),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget listCard(TblTrainingSchedule trainingSchedule, int index) {
    String firstDate = '';
    if (trainingSchedule.firstDate!.isNotEmpty) {
      DateTime inputDate =
          DateFormat("yyyy-MM-dd").parse(trainingSchedule.firstDate!);
      firstDate = DateFormat("dd/MM/yyyy").format(inputDate);
    }
    String lastDate = '';
    if (trainingSchedule.lastDate!.isNotEmpty) {
      DateTime inputDate =
          DateFormat("yyyy-MM-dd").parse(trainingSchedule.lastDate!);
      lastDate = DateFormat("dd/MM/yyyy").format(inputDate);
    }
    return Card(
        // color: (index + 1) % 2 == 1 ? Colors.white : const Color(0xffFFF7F7),
        elevation: 2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
              color: Color(0xff707070),
              width: 1), // set the border color and width
          borderRadius: BorderRadius.circular(20),
        ), // add some shadow to the card
        // shape: RoundedRectangleBorder(
        //   side: BorderSide(
        //       color: DateTime.parse(trainingSchedule.firstDate!)
        //               .isAfter(today)
        //           ? ColorConstants.checkBoxOrangeColor
        //           : today.isAfter(DateTime.parse(trainingSchedule.lastDate!))
        //               ? const Color(0xffBABABA)
        //               : const Color(0xffBABABA),
        //       width: 1), // set the border color and width
        //   borderRadius:
        //       BorderRadius.circular(8), // set the border radius of the card
        // ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                title: 'Training Type',
                text: trainingSchedule.trainingTheme,
                icon: "assets/theme.png",
              ),
              const Divider(color: Color(0xff707070)),
              TrainingTitle(
                title: 'Date Between',
                text: '${firstDate} to ${lastDate}',
                icon: "assets/dateBetween.png",
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
              '$title : ',
              style:
                  Styles.greyp124.copyWith(color: ColorConstants.defaultMaroon),
            )),
        // const Spacer(),
        Expanded(
          // flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: AutoSizeText(
              '$text',
              maxLines: 10,
              style: Styles.black124,
            ),
          ),
        ),
      ],
    );
  }
}
