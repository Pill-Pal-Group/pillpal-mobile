import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/constants.dart';

bool paided = false;
var curentPackage = [];
void fetchpackageCheck() async {
  paided = false;
  var package = [];
  String url = "https://pp-devtest2.azurewebsites.net/api/customers/packages";
  final uri = Uri.parse(url);
  final respone = await http.get(
    uri,
    headers: <String, String>{
      'Authorization': 'Bearer ${UserInfomation.accessToken}',
    },
  );
  if (respone.statusCode == 200 ||
      respone.statusCode == 201 ||
      respone.statusCode == 204) {
    final json = jsonDecode(respone.body);
    package = json;
    if (package.isEmpty) {
      UserInfomation.paided = false;
      log("fetchpackageCheck is Empty");
    } else {
      UserInfomation.paided = true;
      curentPackage = package;
      log("fetchpackageCheck has data");
    }
  } else {
    log("fetchpackageCheck Bug ${respone.statusCode}");
  }
}
