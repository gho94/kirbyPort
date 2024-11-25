import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../service/local_notification_manager.dart';

class NotificationPermission {
  static Future<void> handleNotificationPermission() async {
    var permissionStatus = await Permission.notification.status;

    if (permissionStatus.isGranted) {
      await LocalNotificationManager.init();
      return;
    }

    if (permissionStatus.isDenied) {
      bool isGranted = await Permission.notification.request().isGranted;
      if (isGranted) {
        await LocalNotificationManager.init();
      } else {
        await openAppSettings();
      }
      return;
    }

    if (permissionStatus.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }

    if (permissionStatus.isRestricted) {
      await openAppSettings();
      return;
    }
  }

  static void startListening() {
    WidgetsBinding.instance.addObserver(AppLifecycleObserver());
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      NotificationPermission.handleNotificationPermission();
    }
  }
}
