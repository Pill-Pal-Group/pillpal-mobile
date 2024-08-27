import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get_core/src/get_main.dart';

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

class ThemeServices {
  final _box = GetStorage();
  final _key = 'isDarkMode';
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;
  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
//text theme
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
  //OnbodingScreen
  static const String underMovingShape = "assets/Backgrounds/Spline.png";
  static const String movingShape = "assets/RiveAssets/shapes.riv";
  static const String pillLogo = "assets/picture/loginpic.png";
  static const String googleButtonForm = "assets/RiveAssets/button.riv";
  //VerifyEmailScreen
  static const String emailVerify = "assets/picture/emailverify.png";
  //EntryPoint
  static const String openMenuButton = "assets/RiveAssets/menu_button.riv";
  //ZalopayLogo
  static const String zalopayLogo = "https://haitrieu.com/wp-content/uploads/2022/10/Logo-ZaloPay-Square.png";
  
  static const String erroPicHandelLocal = "assets/picture/ehp.png";

  static const String erroPicHandelLink = "https://www.shutterstock.com/image-vector/chibi-cute-vector-male-doctor-600nw-2401192065.jpg";


}

class APILINK {
  //Home
  static const String homePagefetchPrescripts = "https://pp-devtest2.azurewebsites.net/api/prescripts?IncludePrescriptDetails=true";
  //PrescriptDetails
  static const String deletePrescriptsHeader = "https://pp-devtest2.azurewebsites.net/api/prescripts/";
  //MedicationSchedule
  static const String fetchMedicineIntakeHeader = "https://pp-devtest2.azurewebsites.net/api/medication-intakes/prescripts/";
  //AddTaskScreen
  static const String postPrescripts = "https://pp-devtest2.azurewebsites.net/api/prescripts/";
  static const String postMediceneIntake = "https://pp-devtest2.azurewebsites.net/api/medication-intakes";
  static const String putMedicineImage = "https://pp-devtest2.azurewebsites.net/api/prescripts/prescript-details/";
  //OptionPaymentScreen
  static const String fetchPackageList = "https://pp-devtest2.azurewebsites.net/api/package-categories";
  //MethodPaymentScreen
  static const String postCustomerPackage = "https://pp-devtest2.azurewebsites.net/api/customer-packages/packages";
  static const String postPaymentToVNpay = "https://pp-devtest2.azurewebsites.net/api/payments/packages?PackageCategoryId=";
  static const String getcomfompayment = "https://pp-devtest2.azurewebsites.net/api/payments/packages/payment?customerPackageId=";
}

class UserInfomation {
  static User? loginuser;
  static String accessToken = "";
  static String refreshToken = "";
  static String tokenType = "";
  static int countTIme = 0;
  static bool paided = false;
}

//emun
//enum ExerciseFilter { walking, running, cycling, hiking }
//sample
// AwesomeNotifications().createNotification(
//                             content: NotificationContent(
//                               id: 1,
//                               channelKey: "NotiKey",
//                               title: "testnotification",
//                               body: "The tear in the rain"

//                               )
//                             );
