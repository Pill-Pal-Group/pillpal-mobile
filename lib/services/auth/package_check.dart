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
        'Authorization': 'Bearer ${userInfomation.accessToken}',
      },
    );
    final json = jsonDecode(respone.body);
    package = json;
    if(package.length == 0){
      userInfomation.paided = false;
      log("nghèo");
    }else{
      userInfomation.paided = true;
      curentPackage = package;
      log("khong nghèo");
    }

  }