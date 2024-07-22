import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
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
    log(json['accessToken']);
    UserInfomation.refreshToken = json['refreshToken'];
    //log(json['refreshToken']);
    UserInfomation.tokenType = json['tokenType'];
    //log(json['tokenType']);
    UserInfomation.countTIme = json['expiresIn'];
    //log(json['expiresIn'].toString());
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


Future<void>  checklogin() async{
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
    //log(json['accessToken']);
    UserInfomation.refreshToken = json['refreshToken'];
    //log(json['refreshToken']);
    UserInfomation.tokenType = json['tokenType'];
    //log(json['tokenType']);
    UserInfomation.countTIme = json['expiresIn'];
    Get.to(() => const EntryPoint());
}
