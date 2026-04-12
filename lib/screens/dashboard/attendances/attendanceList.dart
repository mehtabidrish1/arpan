import 'package:arpan/constants/style/style1.dart';
import 'package:arpan/screens/dashboard/attendances/widgets/attendance_container.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color_constants.dart';
import '../../../utils/common.dart';
import '../../../viewmodels/attendence_marksheet_view_model.dart';
import '../../../viewmodels/login_state_view_model.dart';
import '../../../widgets/custom_button.dart';
import '../survey/questionList.dart';

class AttendanceListScreen extends ConsumerStatefulWidget {
  const AttendanceListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendanceListScreen> createState() =>
      _AttendanceListScreenState();
}

class _AttendanceListScreenState extends ConsumerState<AttendanceListScreen> {
  UserInfo? userInfo;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsFlutterBinding.ensureInitialized();
    userInfo = ref.read(loginStateProvider);
    if (userInfo?.role!.toLowerCase() == 'participant') {
      info = [
        Info(ParticipantName: 'Amit Kumar', Age: 21, No: '', id: '100'),
        Info(ParticipantName: 'Aman Singh', Age: 34, No: '', id: '101'),
        Info(ParticipantName: 'Babita Kumari', Age: 21, No: '', id: '102'),
        Info(ParticipantName: 'Chandan Kumar', Age: 42, No: '', id: '103'),
        Info(ParticipantName: 'Eshan Kumar', Age: 17, No: '', id: '104'),
        Info(ParticipantName: 'Eshan Kumar', Age: 13, No: '', id: '105'),
        Info(ParticipantName: 'Aman Singh', Age: 34, No: '', id: '106'),
        Info(ParticipantName: 'Amit Kumar', Age: 21, No: '', id: '107'),
        Info(ParticipantName: 'Aman Singh', Age: 34, No: '', id: '108'),
        Info(ParticipantName: 'Babita Kumari', Age: 21, No: '', id: '109'),
        Info(ParticipantName: 'Chandan Kumar', Age: 42, No: '', id: '110'),
        Info(ParticipantName: 'Eshan Kumar', Age: 17, No: '', id: '112'),
        Info(ParticipantName: 'Eshan Kumar', Age: 13, No: '', id: '113'),
        Info(ParticipantName: 'Aman Singh', Age: 34, No: '', id: '114'),
      ];
    }
  }

  List<Info> info = [];
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(LabelText.developParagraph, style: Styles.greyp124),
              SizedBox(
                height: 17.h,
              ),
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: ColorConstants.defaultTextfieldColor),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 18.w, vertical: 18.h),
                        child: Row(
                          children: [
                            Text(
                              LabelText.participantName,
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.defaultRedColor),
                            ),
                            const Spacer(),
                            Text(
                              LabelText.age,
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstants.defaultRedColor),
                            ),
                            SizedBox(
                              width: 79.w,
                            ),
                          ],
                        ),
                      ),
                      ChildScrollWidget(
                        controller: controller,
                        child: SizedBox(
                          height: 360.h,
                          child: Consumer(builder: (context, ref, child) {
                            return ref
                                .watch(attendenceMarksheetFutureProvider(''))
                                .when(
                                    data: (data) {
                                      if (userInfo?.role?.toLowerCase() ==
                                          'trainer') {
                                        info = data
                                            .map((e) => Info(
                                                id: e.phoneNo.toString(),
                                                ParticipantName: e.fullName!,
                                                Age: 20,
                                                No: ' (${e.phoneNo})'))
                                            .toList();
                                      }

                                      return ListView.separated(
                                        separatorBuilder: ((context, index) =>
                                            Divider(
                                              thickness: 1.h,
                                              indent: 6.h,
                                              endIndent: 11.h,
                                              color: ColorConstants
                                                  .defaultGreyColor,
                                            )),
                                        itemCount: info.length,
                                        itemBuilder: (context, index) {
                                          return AttendanceContainer(
                                              info: info[index],
                                              age: info[index].Age.toString(),
                                              mobileNumber: '',
                                              participantName:
                                                  info[index].ParticipantName);
                                        },
                                      );
                                    },
                                    error: (error, stackTrace) {
                                      return Center(
                                          child: Text(
                                              LabelText.defaultErrorMessage));
                                    },
                                    loading: (() => const Center(
                                          child: CircularProgressIndicator(),
                                        )));
                          }),
                        ),
                      )
                    ],
                  )),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      textColor: ColorConstants.whiteColorText,
                      buttonTitle: LabelText.submit,
                      height: 43.h,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const QuestionListScreen()));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  CustomButton(
                    width: 134.w,
                    buttonColor: ColorConstants.buttonColor2,
                    textColor: ColorConstants.whiteColorText,
                    buttonTitle: LabelText.cancel,
                    height: 43.h,
                    onPressed: () {
                      // Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}

class ChildScrollWidget extends StatelessWidget {
  const ChildScrollWidget(
      {Key? key, required this.controller, required this.child})
      : super(key: key);
  final Widget child;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification value) {
        if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
          if (controller.offset != 0) controller.jumpTo(0);
          return true;
        }
        if (controller.offset + value.overscroll >=
            controller.position.maxScrollExtent) {
          if (controller.offset != controller.position.maxScrollExtent)
            controller.jumpTo(controller.position.maxScrollExtent);
          return true;
        }
        controller.jumpTo(controller.offset + value.overscroll);
        return true;
      },
      child: child,
    );
  }
}
