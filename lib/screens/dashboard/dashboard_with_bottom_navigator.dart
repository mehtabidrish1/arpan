// import 'package:arpan/constants/color_constants.dart';
// import 'package:arpan/constants/image_constants.dart';

// import 'package:flutter/material.dart';

// import '../../constants/route_constants.dart';
// import '../../widgets/custom_navigation_bar.dart';
// import '../training/trainingList.dart';
// import 'attendances/attendanceList.dart';
// import 'attendances/attendanceMob_no.dart';
// import 'attendances/attendanceScreen.dart';
// import 'attendances/markAttendance.dart';
// import 'home_page.dart';

// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);

//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   int _currentIndex = 0;
//   final pages = [
//     const AttendanceScreen(),
//     const TrainingList(),
//     const MarkAttendance(),
//     const AttendanceListScreen(),
//     // const TempPage(
//     //   color: Colors.orange,
//     //   title: "Profile Page",
//     // ),
//     const AttendanceMobileNo(),
//   ];
//   PageController controller = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: CustomBottomNavigationBar(
//           iconList: [
//             ImageConstants.home,
//             ImageConstants.wallet,
//             ImageConstants.ticketStar,
//             ImageConstants.location,
//             ImageConstants.profile
//           ],
//           onChange: (val) {
//             setState(() {
//               _currentIndex = val;
//               controller.animateToPage(val,
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut);
//             });
//           },
//           defaultSelectedIndex: _currentIndex,
//         ),
//         body: PageView.builder(
//           controller: controller,
//           physics: const NeverScrollableScrollPhysics(),
//           // scrollDirection: ,
//           itemBuilder: ((context, index) => pages[index]),
//           itemCount: pages.length,
//         ));
//   }
// }

// class TempPage extends StatelessWidget {
//   final String title;
//   final Color color;
//   const TempPage({Key? key, required this.title, required this.color})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: ColorConstants.defaultBackgroundColor,
//         body: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 45,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pushNamedAndRemoveUntil(
//                         RouteConstants.loginScreen,
//                         (Route<dynamic> route) => false);
//                   },
//                   child: Text("Logout"))
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
