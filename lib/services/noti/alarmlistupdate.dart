import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:pillpalmobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/services/auth/auth_service.dart';
import '../../screens/freetrialscreens/cpntest/Provier.dart';

List<dynamic> tmpPrescripts = [];
List<dynamic> tmpmedicinesInTake = [];
String tmpMedicineName = '';
Future reloadAlarmList() async {
  Random random = new Random();
                int randomNumber = random.nextInt(100);
  //alarmprovider().DeleteData();
  fecthUserInfor().whenComplete(() {
    for (var e in tmpPrescripts) {
      fetchMedicineIntake(e['id']).whenComplete(() {
        List<dynamic> tmp = [];
        for (var x in tmpmedicinesInTake) {
          tmp = x['medicationTakes'];
        }
        for (var y in tmp) {
            String timeTk = y['timeTake'];
            var tmplist = timeTk.split(":");
            int hour = int.parse(tmplist[0]);
            int minute = int.parse(tmplist[1]);
            String dateStringWithTimeZone = '${y['dateTake']}';
            DateTime dateTimeWithTimeZone = DateTime.parse(dateStringWithTimeZone);
            DateTime dateTimeWithTimeZone2 = dateTimeWithTimeZone.add(Duration(hours: hour));
            DateTime dateTimeWithTimeZone3 = dateTimeWithTimeZone2.add(Duration(minutes: minute));
          alarmprovider().SetAlaram("","${y['dateTake']} ${y['timeTake']}", true, 'none', randomNumber,0);
          alarmprovider().SetData();
          alarmprovider().SecduleNotification(dateTimeWithTimeZone3,randomNumber);

        }  
      });
    }
  });
  dev.log("done ne");
  alarmprovider().GetData();
}

void fetchPrescripts(String customerID) async {
  String url =
      "https://pp-devtest2.azurewebsites.net/api/prescripts?CustomerCode=$customerID&IncludePrescriptDetails=false";
  final uri = Uri.parse(url);
  final respone = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer ${UserInfomation.accessToken}',
    },
  );

  if (respone.statusCode == 200 || respone.statusCode == 201) {
    final json = jsonDecode(respone.body);
    tmpPrescripts = json;
    dev.log("fetchPrescripts success 2 ${respone.statusCode}");
  } else if (respone.statusCode == 401) {
    refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
        .whenComplete(() => fetchPrescripts(customerID));
  } else {
    dev.log("fetchPrescripts bug 2 ${respone.statusCode}");
  }
}

Future<void> fecthUserInfor() async {
  String url = "https://pp-devtest2.azurewebsites.net/api/customers/info";
  final uri = Uri.parse(url);
  final respone = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer ${UserInfomation.accessToken}',
    },
  );
  if (respone.statusCode == 200 || respone.statusCode == 201) {
    final json = jsonDecode(respone.body);
    var ui = json;
    fetchPrescripts(ui['customerCode']);
    dev.log("fecthUserInfor 2 success ${respone.statusCode}");
  } else if (respone.statusCode == 401) {
    refreshAccessToken(UserInfomation.accessToken, UserInfomation.refreshToken)
        .whenComplete(() => fecthUserInfor());
  } else {
    dev.log("fecthUserInfor 2 bug ${respone.statusCode}");
  }
}

Future<void> fetchMedicineIntake(String idpr) async {
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
      dev.log("fetchMedicineIntake 2 success ${respone.statusCode}");
      tmpmedicinesInTake = json;
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchMedicineIntake(idpr));
    }else {
      dev.log("fetchMedicineIntake 2 bug ${respone.statusCode}");
    }
  }
