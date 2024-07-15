import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreateMethod(ReceivedNotification receivedNotification) async {}

  static Future<void> onNotificationDisplayMethod(ReceivedNotification receivedNotification) async {}

  static Future<void> onDismissAtionReciveMethod(ReceivedNotification receivedNotification) async {}


  @pragma("vm:entry-point")
  static Future<void> onActionReciveMethod(ReceivedNotification receivedNotification) async {}

}
