import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/packageandpayment/option_payment.dart';
import 'package:pillpalmobile/screens/userinformation/components/appbar_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/button_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/profile_widget.dart';
import 'package:pillpalmobile/screens/userinformation/edit_profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:pillpalmobile/services/auth/package_check.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var nowInformation;

  void fetchCustomerInfor() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/customers/info";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );

    if (respone.statusCode == 200 || respone.statusCode == 201) {
      log("fetchCustomerInfor success ${respone.statusCode}");
      final json = jsonDecode(respone.body);
      setState(() {
        nowInformation = json;
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchCustomerInfor());
    } else {
      log("fetchCustomerInfor bug ${respone.statusCode}");
    }
  }

  String takerightdateformat(String inputdate){
  if(inputdate == ' '){
    return "Chưa cập nhật";
  }
  final splitted = inputdate.split('T');
  return splitted[0];
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        //app bar
        appBar: buildAppBar(context),
        body: Center(
          child: nowInformation == null
              ? const CupertinoActivityIndicator()
              : ListView(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  //chuyển qua trang edit
                  children: [
                    ProfileWidget(
                      imagePath: UserInfomation.loginuser!.photoURL.toString(),
                      onClicked: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                    dob: takerightdateformat(nowInformation['dob'] ?? " "),
                                    phoneNumber: nowInformation['applicationUser']['phoneNumber'] ?? "",
                                    address: nowInformation['address'] ?? "",
                                    sTime: nowInformation['breakfastTime'] ?? "",
                                    trTime: nowInformation['lunchTime'] ?? "",
                                    cTime: nowInformation['afternoonTime'] ?? "",
                                    tTime: nowInformation['dinnerTime'] ?? "",
                                    offtime: nowInformation['mealTimeOffset'] ?? "",
                                  )),
                        );
                      },
                    ),
                    //tên thông tin cơ bản
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Text(
                          UserInfomation.loginuser!.displayName.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          UserInfomation.loginuser!.email.toString(),
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    //hiện trang thái đăng ký gói
                    Center(
                        child: !UserInfomation.paided
                            ? ButtonWidget(
                                text: 'Nâng cấp tài khoản?',
                                onClicked: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OptionPaymentScreen(),
                                    ),
                                  );
                                },
                              )
                            : ButtonWidget(
                                text:
                                    "đăng ký ${curentPackage[0]['duration'] ?? "...."} Ngày",
                                onClicked: () {
                                  log("đã đăng ký");
                                },
                              )),
                    //
                    const SizedBox(height: 24),
                    //thông tin
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          itemProfile('Email', nowInformation['applicationUser']['email'] ??'Chưa cập nhật', CupertinoIcons.mail),
                          const SizedBox(height: 10),
                          itemProfile('Ngày Sinh', takerightdateformat(nowInformation['dob'] ?? ' '), CupertinoIcons.calendar_circle),
                          const SizedBox(height: 10),
                          itemProfile('Số Điện Thoại', nowInformation['applicationUser']['phoneNumber'] ?? 'Chưa cập nhật', CupertinoIcons.phone),
                          const SizedBox(height: 10),
                          itemProfile('Địa Chỉ', nowInformation['address'] ?? 'Chưa cập nhật', CupertinoIcons.home),
                          const SizedBox(height: 10),
                          itemProfile('Giờ ăn sáng', nowInformation['breakfastTime'] ?? 'Chưa cập nhật', CupertinoIcons.sunrise_fill),
                          const SizedBox(height: 10),
                          itemProfile('Giờ ăn Trưa', nowInformation['lunchTime'] ?? 'Chưa cập nhật', CupertinoIcons.sun_max_fill),
                          const SizedBox(height: 10),
                          itemProfile('Giờ ăn Chiều', nowInformation['afternoonTime'] ?? 'Chưa cập nhật', CupertinoIcons.sunset_fill),
                          const SizedBox(height: 10),
                          itemProfile('Giờ ăn Tối', nowInformation['dinnerTime'] ?? 'Chưa cập nhật', CupertinoIcons.moon_stars_fill),
                          const SizedBox(height: 10),
                          itemProfile('Giờ nhắc trước', nowInformation['mealTimeOffset'] ?? 'Chưa cập nhật', CupertinoIcons.clock),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Colors.deepOrange.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10
            )
          ]
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        // leading: Icon(iconData),
        trailing: Icon(iconData,color: Colors.black),
        tileColor: Colors.white,
      ),
    );
  }
