import 'dart:async';
import 'package:arpan/constants/route_constants.dart';
import 'package:arpan/utils/common.dart';
import 'package:arpan/utils/lableText.dart';
import 'package:arpan/viewmodels/login_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../database/dataProvider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Future.delayed(const Duration(seconds: 3), () async {
      Map<String, dynamic> userInfoList = {};
      userInfoList = await UserInfo().getUserCredentials();
      String email, password, role = '';
      if (userInfoList.containsKey('email') &&
          userInfoList.containsKey('password') &&
          userInfoList.containsKey('role')) {
        email = userInfoList['email'] ?? '';
        password = userInfoList['password'] ?? '';
        role = userInfoList['role'] ?? '';
      }
      // userInfoList = await ref.read(loginStateProvider.notifier).fetchState();
      if (role.isNotEmpty) {
        if (role == 'trainer') {
          return Navigator.pushReplacementNamed(
            context,
            RouteConstants.dashboardScreen,
          );
        } else if (role == 'participant') {
          var mobileNo = userInfoList['phone'];
          var trainingList = await DataProvider()
              .getTrainingParticipantWithMobile(mobileNo: mobileNo);
          if (trainingList != null && trainingList.isNotEmpty) {
            return Navigator.pushReplacementNamed(
              context,
              RouteConstants.participentdashboardScreen,
            );
          } else {
            return Navigator.pushReplacementNamed(
              context,
              RouteConstants.loginScreen,
            );
          }
        }
      } else {
        return Navigator.pushReplacementNamed(
          context,
          RouteConstants.loginScreen,
          // RouteConstants.questionListScreen,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return ref.watch(loginStateFutureProvider).when(data: (data) {
          return const SplashScreenBody();
        }, error: (Object error, StackTrace stackTrace) {
          return const SplashScreenBody();
        }, loading: () {
          return const SplashScreenBody();
        });
      }),
    );
  }
}

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({Key? key}) : super(key: key);

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody> {
  var appVersionInfo = LabelText.version;
  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final packageInfo = await PackageInfo.fromPlatform();
    appVersionInfo = '${packageInfo.version}-${packageInfo.buildNumber}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.png'), // Replace with your image path
          fit: BoxFit.cover,
        ),
      ),
      child: const SizedBox(),
    );
  }
}
