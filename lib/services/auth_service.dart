import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillpalmobile/screens/conformemail/verify_email.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';


Future<void> signInWithGoogle() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  final googleAuth2 = await googleUser?.authentication;
  log(googleAuth2!.idToken.toString());
  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    
  

  AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  UserCredential userNow =
      await FirebaseAuth.instance.signInWithCredential(credential);

  if (!userNow.additionalUserInfo!.isNewUser) {
      Get.to(() =>const EntryPoint());
    } else {
      await userNow.user!.sendEmailVerification();
      Get.to(() =>const VerifyEmailScreen());
    }
}
