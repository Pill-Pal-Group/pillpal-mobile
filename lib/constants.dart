import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//màu cho khung app
const Color backgroundColor2 = Color(0xFF17203A);
const Color backgroundColorLight = Color(0xFFF2F6FF);
const Color backgroundColorDark = Color(0xFF25254B);
const Color shadowColorLight = Color(0xFF4A5367);
const Color shadowColorDark = Colors.black;
//màu cho home page
const Color kPrimaryColor = Color(0xFF399DB8);
const Color kScaffoldColor = Color(0xFFF3F4F8);
const Color kSecondaryColor = Color(0xFFF95C54);
const Color kOtherColor = Color(0xFF59C1BD);
const Color kErrorBorderColor = Color(0xFFE74C3C);
const Color kTextLightColor = Color(0xFFC5BDCD);
const Color kTextColor = Color(0xFF56485D);
//somthing
const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0x0fff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = const Color(0xFF424242);

//lignt and dark
class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primarySwatch: Colors.blue,
    primaryColor: primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: Colors.black,
    primarySwatch: Colors.red,
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle get subHeadingstyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode ? Colors.grey[400] : Colors.grey));
}

TextStyle get headingstyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
}

TextStyle get subtitlestyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode ? Colors.grey[100] : Colors.grey[600]));
}

//Link
class LinkImages {
  //login pich
  static const String emailVerify = "assets/picture/emailverify.png";

  static const String tempAvatar = "assets/picture/wsa.jpg";

  static const String rickroll =
      "https://crazydiscostu.wordpress.com/wp-content/uploads/2023/11/history-of-the-rickroll.jpg";
}

class APILINK {
  //static const String medicene = "https://pp-devtest2.azurewebsites.net/api/medicines?IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
}

class userInfomation {
  static User? loginuser;
  static String accessToken = "";
  static String refreshToken = "";
  static String tokenType = "";
  static int countTIme = 0;
  static bool paided = false;
}

//emun
enum ExerciseFilter { walking, running, cycling, hiking }
//sample
// AwesomeNotifications().createNotification(
//                             content: NotificationContent(
//                               id: 1,
//                               channelKey: "NotiKey",
//                               title: "testnotification",
//                               body: "The tear in the rain"

//                               )
//                             );
