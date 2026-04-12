import 'package:in_app_update/in_app_update.dart';

class AppUpdateService {
  static Future<void> checkForImmediateUpdate() async {
    try {
      // Check for update availability
      final updateInfo = await InAppUpdate.checkForUpdate();

      print('Update availability: ${updateInfo.updateAvailability}');
      print('Immediate update allowed: ${updateInfo.immediateUpdateAllowed}');
      print('Flexible update allowed: ${updateInfo.flexibleUpdateAllowed}');

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Start immediate update - this shows full-screen update UI
          final result = await InAppUpdate.performImmediateUpdate();

          print('Immediate update result: $result');

          switch (result) {
            case AppUpdateResult.success:
              print('Update completed successfully');
              break;
            case AppUpdateResult.userDeniedUpdate:
              print('Update was canceled by user');
              break;
            case AppUpdateResult.inAppUpdateFailed:
              print('In-app update failed');
              break;
          }
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Fallback to flexible update if immediate is not allowed
          await _startFlexibleUpdate();
        }
      } else {
        print('No update available');
      }
    } catch (e) {
      print('In-app update check failed: $e');
    }
  }

  static Future<void> _startFlexibleUpdate() async {
    try {
      final result = await InAppUpdate.startFlexibleUpdate();

      if (result == AppUpdateResult.success) {
        // Complete the flexible update
        await InAppUpdate.completeFlexibleUpdate();
        print('Flexible update completed successfully');
      }
    } catch (e) {
      print('Flexible update failed: $e');
    }
  }
}
