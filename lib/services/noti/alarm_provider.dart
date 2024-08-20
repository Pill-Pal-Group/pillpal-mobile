import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';

import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:pillpalmobile/services/auth/staylogin_check.dart';
import 'package:pillpalmobile/services/noti/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:http/http.dart' as http;

class Alarmprovider extends ChangeNotifier {
  late SharedPreferences preferences;

  List<MedicineIntakeModel> modelist = [];

  List<String> listofstring = [];

  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  late BuildContext context;


  setAlaram(String medicineIntakeName, String dateTime, bool check, String repeat, int medicineIntakeId,
      int milliseconds) {
    modelist.add(MedicineIntakeModel(
        medicineIntakeName: medicineIntakeName,
        dateTime: dateTime,
        check: check,
        repeat: repeat,
        medicineIntakeId: medicineIntakeId,
        milliseconds: 0));
    notifyListeners();
  }


  editSwitch(int index, bool check) {
    modelist[index].check = check;
    notifyListeners();
  }


  Future getData() async {
    //log("Alarm check data Getdata");
    preferences = await SharedPreferences.getInstance();

    List<String>? cominglist = preferences.getStringList("data2");

    if (cominglist == null) {
      log("Alarm check data dang trong");
    } else {
      modelist = cominglist.map((e) => MedicineIntakeModel.fromJson(json.decode(e))).toList();
      notifyListeners();
    }
  }


  deleteData() {
    preferences.setStringList("data2", []);
  }

  setData() {
    listofstring = modelist.map((e) => json.encode(e.toJson())).toList();
    preferences.setStringList("data2", listofstring);
    notifyListeners();
  }

  inituilize(con) async {
    //log("Alarm check data Inituilize");
    context = con;
    var androidInitilize =
        const AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOSinitilize = const DarwinInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin!.initialize(initilizationsSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      log('notification payload: $payload');
    }
    await Navigator.push(context,
        MaterialPageRoute<void>(builder: (context) => const StayLoginCheck()));
  }

  // showNotification() async {
  //   const AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails(
  //     'your channel id',
  //     'your channel name',
  //     channelDescription: 'your channel description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidNotificationDetails);
  //   await flutterLocalNotificationsPlugin!.show(
  //       0, 'plain title', 'plain body', notificationDetails,
  //       payload: 'item x');
  // }

  secduleNotification(DateTime datetim, int randomnumber,String medName,int meddos) async {
    int newtime = datetim.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    // log("Alarm check datetim.millisecondsSinceEpoch : ${datetim.millisecondsSinceEpoch}");
    // log("Alarm check DateTime.now().millisecondsSinceEpoch : ${DateTime.now().millisecondsSinceEpoch}");
    // log("Alarm check newtime : $newtime");
    await flutterLocalNotificationsPlugin!.zonedSchedule(
        randomnumber,
        'Bạn có lịch uống thuốc',
        "Thuốc $medName, liều: $meddos",
        tz.TZDateTime.now(tz.local).add(Duration(milliseconds: newtime)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'MedintakeNoti Id', 'MedintakeNoti channel',
                channelDescription: 'MedintakeNoti channel description',
                sound: RawResourceAndroidNotificationSound("alarm"),
                autoCancel: false,
                playSound: true,
                priority: Priority.max)),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }


  cancelNotification(int notificationid) async {
    await flutterLocalNotificationsPlugin!.cancel(notificationid);
  }

  Future reloadNotification() async {
    //log("ReloadNotification Start ${modelist.toString()}");
    await flutterLocalNotificationsPlugin!.cancelAll();
    await preferences.setStringList("data2", []).then((value) {
    //log("ReloadNotification Clear ${modelist.toString()}");
    List<dynamic> tmpPrescript = [];
    getPrescripts().then((value) => {
          tmpPrescript = value,
          for (var e in tmpPrescript)
            {
              getMedicineIntake(e['id']).then((value) {
                try {
                  for (var eachMed in value) {
                    for (var medicationIntake in eachMed['medicationTakes']) {
                      //setup data
                      String timeTk = medicationIntake['timeTake'];
                      var tmplist = timeTk.split(":");
                      int hour = int.parse(tmplist[0]);
                      var tmplist2 = tmplist[1].split(" ");
                      int minute = int.parse(tmplist2[0]);
                      String dateStringWithTimeZone ='${medicationIntake['dateTake']}';
                      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                      DateTime dateTimeWithTimeZone = dateFormat.parse(dateStringWithTimeZone);
                      DateTime dateTimeWithTimeZone2 = dateTimeWithTimeZone.add(Duration(hours: hour));
                      DateTime dateTimeWithTimeZone3 = dateTimeWithTimeZone2.add(Duration(minutes: minute));
                      DateTime check = DateTime.now();
                      String tmpStringid = medicationIntake['id'];
                      int tmpid =  tmpStringid.runes.fold(0, (sum, rune) => sum + rune);

                      // log("Alarm check: medicationIntakeID String $tmpStringid");
                      // log("Alarm check: medicationIntakeID int $tmpid");
                      // log("Alarm check: notificationtime $dateTimeWithTimeZone3");
                      // log("Alarm check: date now $check");
                      // log("Alarm check: dose ${medicationIntake['dose']}");
                      if(!dateTimeWithTimeZone3.isBefore(check)){
                      setAlaram(eachMed['medicineName'],DateFormat().add_jms().format(dateTimeWithTimeZone3),true,"none",tmpid,0);
                      setData();
                      secduleNotification(dateTimeWithTimeZone3, tmpid,eachMed['medicineName'],medicationIntake['dose']);
                      }
                    }
                  }
                } catch (e) {
                  log("Check ReloadNotification Bug $e");
                }
              })
            },
        });
    }
    );
  }
}

Future<List<dynamic>> getMedicineIntake(String idpr) async {
  String url =
      "https://pp-devtest2.azurewebsites.net/api/medication-intakes/prescripts/$idpr";
  final uri = Uri.parse(url);
  final respone = await http.get(
    uri,
    headers: <String, String>{
      'accept': 'application/json',
      'Authorization': 'Bearer ${UserInfomation.accessToken}',
    },
  );
  final json = jsonDecode(respone.body);
  if (respone.statusCode == 200 || respone.statusCode == 201) {
    return json;
  } else if (respone.statusCode == 401) {
    refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
        .whenComplete(() => getMedicineIntake(idpr));
    return [];
  } else {
    //log("fetchMedicineIntake 2 bug ${respone.statusCode}");
    return [];
  }
}

Future<List<dynamic>> getPrescripts() async {
  final uri = Uri.parse(APILINK.homePagefetchPrescripts);
  final respone = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer ${UserInfomation.accessToken}',
    },
  );
  if (respone.statusCode == 200 || respone.statusCode == 201) {
    final json = jsonDecode(respone.body);
    //log("HomePage fetchPrescripts success ${respone.statusCode}");
    return json['data'];
  } else if (respone.statusCode == 401) {
    refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
        .whenComplete(() => getPrescripts());
    return [];
  } else {
    //log("HomePage fetchPrescripts bug ${respone.statusCode}");
    return [];
  }
}
