import 'package:arpan/utils/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../utils/log_files.dart';

final loginStateProvider =
    StateNotifierProvider<LoginStateController, UserInfo>((ref) {
  return LoginStateController();
});

// ignore: prefer_function_declarations_over_variables
final loginStateFutureProvider = FutureProvider((ref) async {
  final provider = ref.watch(loginStateProvider.notifier);
  await provider.fetchState();
  return ref.read(loginStateProvider);
});

class LoginStateController extends StateNotifier<UserInfo> {
  LoginStateController() : super(UserInfo());

  Future fetchState() async {
    try {
      Map<String, dynamic> userInfo = await UserInfo().getUserCredentials();
      UserInfo user = UserInfo();

      user = UserInfo(
          email: userInfo.containsKey('email') ? userInfo['email'] : null,
          password:
              userInfo.containsKey('password') ? userInfo['password'] : null,
          role: userInfo.containsKey('role') ? userInfo['role'] : null);

      state = user;
    } catch (error, stackTrace) {
      logError(error, stackTrace);
      // log(e.toString(), name: 'LoginStateController');
    }
  }
}
