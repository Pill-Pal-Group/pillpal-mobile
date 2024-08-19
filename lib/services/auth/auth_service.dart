import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/conformemail/verify_email.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';

Future<void> signInWithGoogle() async {
  try {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userNow =
        await FirebaseAuth.instance.signInWithCredential(credential);

    log("email check: 1 ${googleUser}");
    log("email check: 2 ${googleAuth}");
    log("email check: 3 ${credential}");
    log("email check: 4 ${userNow}");

    final tokenResult = FirebaseAuth.instance.currentUser;
    final idToken = await tokenResult!.getIdToken();
    final token = idToken.toString();

    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/auths/token-login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'token': token,
      }),
    );
    final json = jsonDecode(response.body);

    UserInfomation.loginuser = tokenResult;
    UserInfomation.accessToken = json['accessToken'];
    log("accessToken ${UserInfomation.accessToken}");
    UserInfomation.refreshToken = json['refreshToken'];
    log("refreshToken ${UserInfomation.refreshToken}");
    UserInfomation.tokenType = json['tokenType'];
    UserInfomation.countTIme = json['expiresIn'];

    //post divicetoken
    FirebaseMessaging firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    firebaseMessaging.getToken().then((token) {
      diviceTokenPut(token, UserInfomation.accessToken);
    });

    if (!userNow.additionalUserInfo!.isNewUser) {
      Get.to(() => const EntryPoint());
    } else {
      await userNow.user!.sendEmailVerification();
      Get.to(() => const VerifyEmailScreen());
    }
  } catch (e) {
    Get.to(() => const OnbodingScreen());
    log("BugLogin ${e.toString()}");
  }
}

Future<void> diviceTokenPut(String? token, String accessToken) async {
  final response = await http.put(
    Uri.parse(
        "https://pp-devtest2.azurewebsites.net/api/customers/device-token"),
    headers: <String, String>{
      'accept': '*/*',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, dynamic>{
      'deviceToken': '$token',
    }),
  );
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 204) {
    log("diviceTokenPost success ${response.statusCode}");
  } else {
    log("diviceTokenPost bug ${response.statusCode}");
  }
}

Future<void> checklogin() async {
  final tokenResult = FirebaseAuth.instance.currentUser;
  final idToken = await tokenResult!.getIdToken();
  final token = idToken.toString();

  final response = await http.post(
    Uri.parse("https://pp-devtest2.azurewebsites.net/api/auths/token-login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'token': token,
    }),
  );

  final json = jsonDecode(response.body);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 204) {
    UserInfomation.loginuser = tokenResult;
    UserInfomation.accessToken = json['accessToken'];
    UserInfomation.refreshToken = json['refreshToken'];
    UserInfomation.tokenType = json['tokenType'];
    UserInfomation.countTIme = json['expiresIn'];
    log("checklogin success ${response.statusCode}");
    Get.to(() => const EntryPoint());
  } else {
    log("checklogin bug ${response.statusCode}");
    Get.to(() => const OnbodingScreen());
  }
}

Future<void> refreshAccessToken(String expiredToken,String refreshToken) async {
  final response = await http.post(
    Uri.parse("https://pp-devtest2.azurewebsites.net/api/auths/token-login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'expiredToken': expiredToken,
      'refreshToken': refreshToken,
    }),
  );
  final json = jsonDecode(response.body);
  if (response.statusCode == 200 ||
      response.statusCode == 201 ||
      response.statusCode == 204) {
    UserInfomation.accessToken = json['accessToken'];
    UserInfomation.refreshToken = json['refreshToken'];
    UserInfomation.tokenType = json['tokenType'];
    UserInfomation.countTIme = json['expiresIn'];
    log("refreshAccessToken success ${response.statusCode}");
  } else {
    log("refreshAccessToken bug ${response.statusCode}");
  }
}
