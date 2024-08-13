import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/global_bloc.dart';
import 'package:pillpalmobile/screens/freetrialscreens/cpntest/Provier.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/theme_services.dart';
import 'package:pillpalmobile/services/auth/staylogin_check.dart';
import 'package:pillpalmobile/services/noti/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  //setup localnotification
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "bassic_channel_group",
      channelKey: "NotiKey",
      channelName: "testnoti",
      channelDescription: "oke r ne",
    )
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "bassic_channel_group",
        channelGroupName: "bassic group")
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  WidgetsFlutterBinding.ensureInitialized();
  //setupthongbao
  tz.initializeTimeZones();
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .requestPermission();

  await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc? globalBloc;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReciveMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreateMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissAtionReciveMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayMethod,
    );
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (contex) => alarmprovider(),
      child: Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: Themes.light,
          darkTheme: Themes.dark,
          themeMode: ThemeServices().theme,
          home: const StayLoginCheck(),
          //home: const FreeTrialScreen(),
        );
      }),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
