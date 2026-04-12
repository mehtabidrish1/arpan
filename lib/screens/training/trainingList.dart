import 'package:arpan/constants/color_constants.dart';
import 'package:arpan/constants/image_constants.dart';
import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/models/training_registration.dart';
import 'package:arpan/table_model/tbl_training_schedule_model.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/widgets/registration_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/common.dart';
import '../../viewmodels/participant_training_registration_view_model.dart';
import '../../widgets/custom_check_box.dart';
import '../dashboard/dashboard_screen.dart';

class TrainingList extends ConsumerStatefulWidget {
  const TrainingList({Key? key}) : super(key: key);

  @override
  ConsumerState<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends ConsumerState<TrainingList> {
  String trainingName = '';
  bool chkbox = false;
  DateTime currentDateTime = DateTime.now();
  List<TblTrainingSchedule> trainingRegistrationScheduleList = [];

  final ScrollController controller = ScrollController();
  int filterIndex = 0;
  bool getStatesOfTraining({DateTime? dateTime}) {
    if (dateTime == null) {
      return false;
    }
    int daysDifference = DateTime(dateTime.year, dateTime.month, dateTime.day)
        .difference(DateTime(
            currentDateTime.year, currentDateTime.month, currentDateTime.day))
        .inDays;
    if (daysDifference == 0) {
      return true;
    } else if (daysDifference <= -1) {
      false;
    } else if (daysDifference >= 1) {
      return true;
    }
    return false;
  }

  List<TblTrainingSchedule> traingRegistrationList = [];
  List<TblTrainingSchedule> getFilteredTrainingRegistrationList(
      {required int filterIndex,
      required List<TblTrainingSchedule> trainingRegistrationList,
      String? trainingName}) {
    List<TblTrainingSchedule> trainingRegistrationListTemp = [];
    if (filterIndex == 0) {
      trainingRegistrationListTemp = trainingRegistrationList;
    } else if (filterIndex == 1) {
      trainingRegistrationListTemp = trainingRegistrationList.where((element) {
        return true;
      }).toList();
    } else if (filterIndex == 2) {
      trainingRegistrationListTemp = trainingRegistrationList.where((element) {
        return false;
      }).toList();
    }

    if (trainingName!.isEmpty) {
      trainingRegistrationListTemp = trainingRegistrationListTemp;
    } else {
      trainingRegistrationListTemp = trainingRegistrationListTemp
          .where((element) => element.trainerName!
              .toLowerCase()
              .contains(trainingName.toLowerCase()))
          .toList();
    }
    return trainingRegistrationListTemp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstants.defaultBackgroundColor,
        title: Text(LabelText.training, style: Styles.black145),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            FocusScope.of(context).unfocus();
            // Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DashboardScreen()));
          },
        ),
        elevation: 0,
      ),
      // floatingActionButton: FloatingActionButton(
      //     child: Icon(
      //       Icons.add,
      //       color: ColorConstants.defaultBlueColor,
      //     ),
      //     backgroundColor: ColorConstants.buttonColor,
      //     onPressed: () {
      //       Navigator.pushNamed(
      //         context,
      //         RouteConstants.trainingDetailScreen,
      //       );
      //     }),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.h),
        child: SingleChildScrollView(
          primary: true,
          child: Column(
            children: [
              RegistrationTextField(
                subTitle: LabelText.training,
                onChanged: (value) {
                  trainingName = value;
                  // ref.refresh(participantTrainingRegistrationFutureProvider);
                  trainingRegistrationScheduleList =
                      getFilteredTrainingRegistrationList(
                          trainingRegistrationList:
                              trainingRegistrationScheduleList,
                          filterIndex: filterIndex,
                          trainingName: trainingName);
                  setState(() {});
                },
                title: '',
                height: 48.h,
                preffixIcon: SizedBox(
                  width: 18.w,
                  height: 18.h,
                  child: Center(
                    child: Image.asset(
                      ImageConstants.searchIcon,
                      width: 18.w,
                      height: 18.h,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: CustomCheckBox(
              //     title: [
              //       LabelText.all,
              //       LabelText.upcoming,
              //       LabelText.completed,
              //     ],
              //     callback: (val) {
              //       filterIndex = (val);
              //       // ignore: unused_result
              //       ref.refresh(participantTrainingRegistrationFutureProvider);
              //     },
              //   ),
              // ),
              SizedBox(
                height: 10.h,
              ),
              Consumer(builder: (context, ref, child) {
                return ref
                    .watch(participantTrainingRegistrationFutureProvider)
                    .when(
                      data: (data1) {
                        trainingRegistrationScheduleList =
                            getFilteredTrainingRegistrationList(
                                trainingRegistrationList: data1,
                                filterIndex: filterIndex,
                                trainingName: trainingName);
                        if (trainingRegistrationScheduleList.isEmpty) {
                          return SizedBox(
                              height: 330.h,
                              child: Center(
                                  child: Text(LabelText.emptyListMessage)));
                        }
                        return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: ListView.separated(
                                controller: controller,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: ((context, index) => InkWell(
                                      child: Container(),
                                      onTap: () {
                                        // Navigator.pushNamed(
                                        //   context,
                                        //   RouteConstants.trainingDetailScreen,

                                        // );
                                        FocusScope.of(context).unfocus();
                                        trainingRegistrationScheduleList
                                                    .first.scheduleGuid !=
                                                null
                                            ? () {} /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        TrainingDetailScreen(
                                                          trainingRegistration:
                                                              trainingRegistrationScheduleList[
                                                                  index],
                                                        )))
                                                        */
                                            : () {};
                                      },
                                    )),
                                separatorBuilder: (context, index) => SizedBox(
                                      height: 9.h,
                                    ),
                                // shrinkWrap: true,
                                primary: false,
                                itemCount:
                                    trainingRegistrationScheduleList.length));
                      },
                      error: ((error, stackTrace) => SizedBox(
                          height: 330.h,
                          child: Center(
                              child: Text(LabelText.defaultErrorMessage)))),
                      loading: () => SizedBox(
                        height: 330.h,
                        child: const Center(
                            child: CircularProgressIndicator.adaptive()),
                      ),
                    );
              })
            ],
          ),
        ),
      )),
    );
  }
}

class TrainingContainer extends StatelessWidget {
  const TrainingContainer({
    Key? key,
    required this.name,
    required this.date,
    required this.theme,
    required this.status,
    required this.topic,
  }) : super(key: key);
  final String name;
  final String date;
  final String topic;
  final String theme;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 9.w),
      decoration: BoxDecoration(
        color: ColorConstants.defaultTextfieldColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          // BoxShadow(
          //     color: Colors.black12.withOpacity(0.03),
          //     offset: const Offset(2, 2),
          //     spreadRadius: 5,
          //     blurRadius: 5.0)
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 67.h,
            width: 4.w,
            decoration: BoxDecoration(
                color: status == 'All'
                    ? ColorConstants.checkBoxGreenColor
                    : status == 'Completed'
                        ? ColorConstants.checkBoxBlueColor
                        : ColorConstants.checkBoxOrangeColor,
                borderRadius: BorderRadius.circular(18.r)),
          ),
          SizedBox(
            width: 9.w,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TrainingTitle(
                  title: 'Training Name',
                  text: name,
                  icon: 'assets/person_icon.png',
                ),
                SizedBox(
                  height: 10.h,
                ),
                TrainingTitle(
                  title: 'Date',
                  text: date,
                  icon: 'assets/calendar_icon.png',
                ),
                SizedBox(
                  height: 10.h,
                ),
                TrainingTitle(
                  title: 'Topic',
                  text: topic,
                  icon: 'assets/topicIcon.png',
                ),
                SizedBox(
                  height: 10.h,
                ),
                TrainingTitle(
                  title: 'Theme',
                  text: theme,
                  icon: 'assets/themeIcon.png',
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Image.asset(
            '$icon',
            // height: 15.h,
            scale: 3.3,
          ),
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
          ),
        ),
        // Spacer(),
        Expanded(
          // flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              ' $text',
              style: Styles.black124,
              softWrap: true,
            ),
          ),
        ),
      ],
    );
  }
}
