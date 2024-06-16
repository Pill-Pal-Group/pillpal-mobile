
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/global_bloc.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/medicationschedule/medicationschedule.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/theme_services.dart';
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';
import 'package:pillpalmobile/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:awesome_notifications/awesome_notifications.dart';


Future<void> main() async {
  await AwesomeNotifications().initialize(
    null,
     [
      NotificationChannel(
      channelGroupKey: "bassic_channel_group",
      channelKey: "NotiKey", 
      channelName: "testnoti", 
      channelDescription: "oke r ne",
      )
     ],
     channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "bassic_channel_group", 
        channelGroupName: "bassic group"
      )
     ]
  );
  bool isAllowedToSendNotification = await AwesomeNotifications().isNotificationAllowed();
  if(isAllowedToSendNotification){
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  GlobalBloc? globalBloc;

  @override
  void initState() {
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReciveMethod,
      onNotificationCreatedMethod: NotificationController.onNotificationCreateMethod,
      onDismissActionReceivedMethod: NotificationController.onDismissAtionReciveMethod,
      onNotificationDisplayedMethod: NotificationController.onNotificationDisplayMethod,

      
      );
    globalBloc = GlobalBloc();
    super.initState();
  }

 @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
        return 
        
      // MaterialApp(
      // debugShowCheckedModeBanner: false,
      // title: 'PILLPAL APP',
      // //Theme cua khung app
      // theme: ThemeData(
      //   scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
      //   primarySwatch: Colors.blue,
      //   fontFamily: "Intel",
      //   inputDecorationTheme: const InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.white,
      //     errorStyle: TextStyle(height: 0),
      //     border: defaultInputBorder,
      //     enabledBorder: defaultInputBorder,
      //     focusedBorder: defaultInputBorder,
      //     errorBorder: defaultInputBorder,
      //   ),
      // ),
      // home: const OnbodingScreen(),
      // );
      ///test
      GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const OnbodingScreen(),
    );
      //test
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