// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
// import 'package:intl/intl.dart';
// import 'package:pillpalmobile/constants.dart';
// import 'package:pillpalmobile/screens/freetrialscreens/cpntest/Model.dart';
// import 'package:pillpalmobile/services/auth/auth_service.dart';
// import 'package:pillpalmobile/services/auth/staylogin_check.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:http/http.dart' as http;

// // ignore: camel_case_types
// class alarmprovider extends ChangeNotifier {
//   late SharedPreferences preferences;

//   List<Model> modelist = [];

//   List<String> listofstring = [];

//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

//   late BuildContext context;

//   // ignore: non_constant_identifier_names
//   SetAlaram(String label, String dateTime, bool check, String repeat, int id,
//       int milliseconds) {
//     modelist.add(Model(
//         label: label,
//         dateTime: dateTime,
//         check: check,
//         when: repeat,
//         id: id,
//         milliseconds: 0));
//     notifyListeners();
//   }

//   // ignore: non_constant_identifier_names
//   EditSwitch(int index, bool check) {
//     modelist[index].check = check;
//     notifyListeners();
//   }

//   // ignore: non_constant_identifier_names
//   Future GetData() async {
//     log("Alarm check data Getdata");
//     preferences = await SharedPreferences.getInstance();

//     List<String>? cominglist = preferences.getStringList("data2");

//     if (cominglist == null) {
//       log("Alarm check data dang trong");
//     } else {
//       modelist = cominglist.map((e) => Model.fromJson(json.decode(e))).toList();
//       notifyListeners();
//     }
//   }

//   // ignore: non_constant_identifier_names
//   DeleteData() {
//     //log("test ne ${preferences.getStringList("data2")}");
//     preferences.setStringList("data2", []);
//     //notifyListeners();
//   }

//   // ignore: non_constant_identifier_names
//   SetData() {
//     listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
//     preferences.setStringList("data2", listofstring);
//     notifyListeners();
//   }

//   // ignore: non_constant_identifier_names
//   Inituilize(con) async {
//     log("Alarm check data Inituilize");
//     context = con;
//     var androidInitilize =
//         const AndroidInitializationSettings('@mipmap/launcher_icon');
//     var iOSinitilize = const DarwinInitializationSettings();
//     var initilizationsSettings =
//         InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
//         onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
//   }

//   void onDidReceiveNotificationResponse(
//       NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('notification payload: $payload');
//     }
//     await Navigator.push(context,
//         MaterialPageRoute<void>(builder: (context) => StayLoginCheck()));
//   }

//   // ignore: non_constant_identifier_names
//   ShowNotification() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin!.show(
//         0, 'plain title', 'plain body', notificationDetails,
//         payload: 'item x');
//   }

//   // ignore: non_constant_identifier_names
//   SecduleNotification(DateTime datetim, int _randomnumber) async {
//     int newtime =
//         datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
//     log("Alarm check datetim.millisecondsSinceEpoch : ${datetim.millisecondsSinceEpoch}");
//     log("Alarm check DateTime.now().millisecondsSinceEpoch : ${DateTime.now().millisecondsSinceEpoch}");
//     log("Alarm check newtime : $newtime");
//     await flutterLocalNotificationsPlugin!.zonedSchedule(
//         _randomnumber,
//         'Bạn có lịch uống thuốc',
//         "cười cái cc",
//         tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newtime)),
//         const NotificationDetails(
//             android: AndroidNotificationDetails(
//                 'your channel id', 'your channel name',
//                 channelDescription: 'your channel description',
//                 sound: RawResourceAndroidNotificationSound("alarm"),
//                 autoCancel: false,
//                 playSound: true,
//                 priority: Priority.max)),
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime);
//   }

//   // ignore: non_constant_identifier_names
//   CancelNotification(int notificationid) async {
//     await flutterLocalNotificationsPlugin!.cancel(notificationid);
//   }

//   // ignore: non_constant_identifier_names
//   ReloadNotification() {
//     preferences.setStringList("data2", []);
//     List<dynamic> tmpPrescript = [];
//     getPrescripts().then((value) => {
//           tmpPrescript = value,
//           log("Check ReloadNotification ${tmpPrescript.length}"),
//           for (var e in tmpPrescript)
//             {
//               log("Check ReloadNotification ${e['id']}"),
//               getMedicineIntake(e['id']).then((value) {
//                 try {
//                   for (var eachMed in value) {
//                     for (var medicationIntake in eachMed['medicationTakes']) {
//                       //setup data
//                       String timeTk = medicationIntake['timeTake'];
//                       var tmplist = timeTk.split(":");
//                       int hour = int.parse(tmplist[0]);
//                       int minute = int.parse(tmplist[1]);
//                       String dateStringWithTimeZone ='${medicationIntake['dateTake']}';
//                       DateFormat dateFormat = DateFormat("yyyy-MM-dd");
//                       DateTime dateTimeWithTimeZone = dateFormat.parse(dateStringWithTimeZone);
//                       DateTime dateTimeWithTimeZone2 = dateTimeWithTimeZone.add(Duration(hours: hour));
//                       DateTime dateTimeWithTimeZone3 = dateTimeWithTimeZone2.add(Duration(minutes: minute));
//                       DateTime check = DateTime.now();
//                       log("Alarm check: notificationtime $dateTimeWithTimeZone3");
//                       log("Alarm check: date now $check");
//                       if(!dateTimeWithTimeZone3.isBefore(check)){
//                       SetAlaram(eachMed['medicineName'],DateFormat().add_jms().format(dateTimeWithTimeZone3),true,"none",90,0);
//                       SetData();
//                       SecduleNotification(dateTimeWithTimeZone3, 90);
//                       }
//                     }
//                   }
//                 } catch (e) {
//                   log("Check ReloadNotification Bug $e");
//                 }
//               })
//             }
//         });
//     log("Check point home");
//   }
// }

// Future<List<dynamic>> getMedicineIntake(String idpr) async {
//   String url =
//       "https://pp-devtest2.azurewebsites.net/api/medication-intakes/prescripts/$idpr";
//   final uri = Uri.parse(url);
//   final respone = await http.get(
//     uri,
//     headers: <String, String>{
//       'accept': 'application/json',
//       'Authorization': 'Bearer ${UserInfomation.accessToken}',
//     },
//   );
//   final json = jsonDecode(respone.body);
//   if (respone.statusCode == 200 || respone.statusCode == 201) {
//     return json;
//   } else if (respone.statusCode == 401) {
//     refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
//         .whenComplete(() => getMedicineIntake(idpr));
//     return [];
//   } else {
//     log("fetchMedicineIntake 2 bug ${respone.statusCode}");
//     return [];
//   }
// }

// Future<List<dynamic>> getPrescripts() async {
//   final uri = Uri.parse(APILINK.homePagefetchPrescripts);
//   final respone = await http.get(
//     uri,
//     headers: <String, String>{
//       'Authorization': 'Bearer ${UserInfomation.accessToken}',
//     },
//   );
//   if (respone.statusCode == 200 || respone.statusCode == 201) {
//     final json = jsonDecode(respone.body);
//     log("HomePage fetchPrescripts success ${respone.statusCode}");
//     return json['data'];
//   } else if (respone.statusCode == 401) {
//     refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
//         .whenComplete(() => getPrescripts());
//     return [];
//   } else {
//     log("HomePage fetchPrescripts bug ${respone.statusCode}");
//     return [];
//   }
// }
