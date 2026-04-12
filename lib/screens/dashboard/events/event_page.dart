import 'package:arpan/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants/image_constants.dart';
import '../../../constants/style/style1.dart';
import '../../../widgets/registration_text_field.dart';
import '../../training/trainingdetailScreen.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.5.h,
                ),
                Center(
                  child: Text("Events", style: Styles.black145),
                ),
                SizedBox(
                  height: 21.h,
                ),
                RegistrationTextField(
                  subTitle: 'Events',
                  onChanged: (value) {},
                  title: '',
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
                EventContainer(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TrainingDetailScreen()));
                  },
                  children: [
                    InfoText(
                      icon: ImageConstants.nameIcon,
                      iconHeight: 13.82.h,
                      iconWidth: 12.w,
                      title: "Name",
                      subTitle: 'Amit Sighn',
                    ),
                    InfoText(
                      icon: ImageConstants.calenderIcon,
                      iconHeight: 12.h,
                      iconWidth: 12.w,
                      title: "Date",
                      subTitle: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    ),
                    InfoText(
                      icon: ImageConstants.uidIcon,
                      iconHeight: 10.67.h,
                      iconWidth: 12.w,
                      title: "Training Type",
                      subTitle:
                          'Lorem Ipsum is simply dummy text of the printing.',
                    ),
                  ],
                ),
                SizedBox(
                  height: 9.h,
                ),
                EventContainer(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TrainingDetailScreen()));
                  },
                  children: [
                    InfoText(
                      icon: ImageConstants.nameIcon,
                      iconHeight: 13.82.h,
                      iconWidth: 12.w,
                      title: "Name",
                      subTitle: 'Amit Sighn',
                    ),
                    InfoText(
                      icon: ImageConstants.calenderIcon,
                      iconHeight: 12.h,
                      iconWidth: 12.w,
                      title: "Date",
                      subTitle: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                    ),
                    InfoText(
                      icon: ImageConstants.uidIcon,
                      iconHeight: 10.67.h,
                      iconWidth: 12.w,
                      title: "Training Type",
                      subTitle:
                          'Lorem Ipsum is simply dummy text of the printing.',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EventContainer extends StatelessWidget {
  const EventContainer({Key? key, this.children, required this.onTap})
      : super(key: key);
  final List<Widget>? children;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.r),
      clipBehavior: Clip.hardEdge,
      color: ColorConstants.defaultWhiteColor,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.r)),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 17.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children ??
                [
                  InfoText(
                    icon: ImageConstants.nameIcon,
                    iconHeight: 13.82.h,
                    iconWidth: 12.w,
                    title: "Name",
                    subTitle: 'Amit Sighn',
                  ),
                  InfoText(
                    icon: ImageConstants.calenderIcon,
                    iconHeight: 12.h,
                    iconWidth: 12.w,
                    title: "Date",
                    subTitle: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  ),
                  InfoText(
                    icon: ImageConstants.uidIcon,
                    iconHeight: 10.67.h,
                    iconWidth: 12.w,
                    title: "Training Type",
                    subTitle:
                        'Lorem Ipsum is simply dummy text of the printing.',
                  ),
                ],
          ),
        ),
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final String subTitle;
  final String? icon;
  final double? iconHeight;
  final double? iconWidth;
  const InfoText({
    Key? key,
    required this.subTitle,
    required this.title,
    this.icon,
    this.iconHeight = 0,
    this.iconWidth = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              SizedBox(
                  width: iconWidth,
                  height: iconHeight,
                  child: Image.asset(
                    icon!,
                    width: iconWidth,
                    height: iconHeight,
                  )),
              SizedBox(
                width: 8.w,
              ),
            ],
            Text(title,
                style: Styles.defaultFont.copyWith(
                    fontSize: 10.sp,
                    color: ColorConstants.textFieldTitleColor)),
            const Text(
              ': ',
            ),
          ],
        ),
        Flexible(
          child: Text(
            subTitle,
            style: Styles.defaultFont,
          ),
        )
      ],
    );
  }
}
