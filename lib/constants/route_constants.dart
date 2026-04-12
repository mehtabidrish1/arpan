import 'package:arpan/screens/dashboard/attendances/attendanceMob_no.dart';
import 'package:arpan/screens/dashboard/attendances/attendanceScreen.dart';

import 'package:arpan/screens/dashboard/dashboard_screen.dart';

import 'package:arpan/screens/login/loginScreen.dart';
import 'package:arpan/screens/splash/splashScreen.dart';
import 'package:arpan/screens/training/trainingList.dart';
import 'package:arpan/screens/training/training_batch_session_creation.dart';
import 'package:arpan/screens/training/training_batch_session_list.dart';
import 'package:arpan/screens/training/trainingdetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../screens/dashboard/attendances/attendanceList.dart';
import '../screens/dashboard/attendances/new_mark_attendance.dart';
import '../screens/dashboard/survey/indirect_trainning_patricepent_list.dart';
import '../screens/dashboard/survey/indirect_trainning_reg.dart';
import '../screens/dashboard/survey/indirect_trainning_reg_list.dart';
import '../screens/dashboard/survey/particepent_certificate.dart';
import '../screens/dashboard/survey/particepent_dashboard.dart';
import '../screens/dashboard/survey/participent_syncronization.dart';
import '../screens/dashboard/survey/questionList.dart';
import '../screens/dashboard/survey/registration_particepent.dart';
import '../screens/dashboard/survey/training_cerificate_list.dart';
import '../screens/dashboard/sync/syncronization.dart';
import '../screens/splash/advance_webview.dart';
import '../screens/training/hand_holding_attendance.dart';
import '../screens/training/hand_holding_reg.dart';
import '../screens/training/hand_holding_reg_list.dart';
import '../screens/training/hand_holding_schedule_list_page.dart';
import '../screens/training/traing_batch_list.dart';
import '../screens/training/training_batch_attendance.dart';
import '../screens/training/training_batch_creation.dart';
import '../screens/training/training_schedule_list_page.dart';

class RouteConstants {
  static String splashScreen = '/routes_splash';
  static String loginScreen = '/routes_login';
  static String registrationScreen = '/routes_registration';
  static String dashboardScreen = '/routes_dashboard';
  static String trainingListScreen = '/routes_trainging_list';
  static String markAttendanceScreen = '/routes_mark_attendence';
  static String attendenceScreen = '/routes_attendence';
  static String trainingDetailScreen = '/routes_training_details';
  static String attendenceMobileNumberScreen =
      '/routes_attendence_mobile_number';
  static String attendenceListScreen = '/routes_attendence_list_screen';
  static String syncronizationPage = '/routes_syncronization_page';
  static String questionListScreen = '/routes_question_list_screen';
  static String trainingBatchList = '/routes_trainingBatchList';
  static String trainingBatchCreation = '/routes_trainingBatchCreation';
  static String trainingBatchSessionList = '/routes_trainingBatchSessionList';
  static String trainingBatchSessionCreation =
      '/routes_trainingBatchSessionCreation';
  static String newReg = '/routes_newReg';
  static String indirecttrainninglist = '/indirecttrainninglist';
  static String particepentCertificate = '/particepentCertificate';
  static String trainingcertificatelist = '/trainingcertificatelist';
  static String trainingbatchAttendance = '/trainingbatchAttendance';

  static String indirecttrainningReg = '/indirecttrainningReg';
  static String indirecttrainningRegList = '/indirecttrainningRegList';

  static String participentdashboardScreen = '/participentdashboardScreen';
  static String participentsyncronizationPage =
      '/participentsyncronizationPage';
  static String handholdingscheduleListScreen =
      '/handholdingscheduleListScreen';
  static String handholdingreglist = '/handholdingreglist';
  static String handholdingreg = '/handholdingreg';
  static String handholdingAttendance = '/handholdingAttendance';
  static String shareapk = '/shareapk';
  static String webviewpage = '/webviewpage';

  static Map<String, WidgetBuilder> routes = {
    trainingbatchAttendance: (context) => TraingBatchAttendance(),
    trainingcertificatelist: (context) => TrainingCertificateList(),
    particepentCertificate: (context) => ParticepentCertificate(),
    splashScreen: (context) => const SplashScreen(),

    newReg: (context) => RegistraionParticipantModule(),

    loginScreen: (context) => const LoginScreen(),
   // registrationScreen: (context) => const RegistrationScreen(),
    trainingListScreen: (context) => const TrainingScheduleListPage(),
    //markAttendanceScreen: (context) => const MarkAttendance(),
    markAttendanceScreen: (context) => const MarkAttendanceModule(),
    attendenceScreen: (context) => const AttendanceScreen(),
    trainingDetailScreen: (context) => const TrainingDetailScreen(),
    attendenceMobileNumberScreen: (context) => const AttendanceMobileNo(),
    attendenceListScreen: (context) => const AttendanceListScreen(),
    syncronizationPage: (context) => const SyncronizationPage(),
    dashboardScreen: (context) => const DashboardScreen(),
    questionListScreen: (context) => const QuestionListScreen(),
    trainingBatchList: (context) => const TrainingBatchList(),
    trainingBatchCreation: (context) => const TrainingBatchCreation(),
    trainingBatchSessionList: (context) => const TrainingBatchSessionListPage(),
    trainingBatchSessionCreation: (context) =>
        const TrainingBatchSessionCreation(),
    indirecttrainninglist: (context) => const IndirectTrainningListPage(),
    indirecttrainningReg: (context) => const IndirectTrainingRegistration(),
    indirecttrainningRegList: (context) => IndirectRegList(),
    participentdashboardScreen: (context) => const ParticepentDashboardScreen(),
    participentsyncronizationPage: (context) =>
        const ParticepentSyncronizationPage(),
    handholdingscheduleListScreen: (context) =>
        const HandHoldingScheduleListPage(),
    handholdingreglist: (context) => const HandHoldingRegList(),
    handholdingreg: (context) => const HandHoldingRegistration(),
    handholdingAttendance: (context) => const HandHoldingAttendance(),
  };
}
