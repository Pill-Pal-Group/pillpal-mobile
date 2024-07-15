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
        'Authorization': 'Bearer ${userInfomation.accessToken}',
      },
    );
    final json = jsonDecode(respone.body);
    setState(() {
      nowInformation = json;
      
    });
  }

  @override
  void initState() {
    super.initState();
    fetchpackageCheck();
    fetchCustomerInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        //app bar
        appBar: buildAppBar(context),
        body: Center(
          child: nowInformation == null ? const CupertinoActivityIndicator() : ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            //chuyển qua trang edit
            children: [
              ProfileWidget(
                imagePath: userInfomation.loginuser!.photoURL.toString(),
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          userName: nowInformation['applicationUser']['userName'] ?? "", 
                          dob: nowInformation['dob'] ?? "", 
                          phoneNumber: nowInformation['applicationUser']['phoneNumber']?? "", 
                          address: nowInformation['address']?? "", 
                          sTime: nowInformation['breakfastTime']?? "", 
                          lTime: nowInformation['lunchTime']?? "", 
                          nTime: nowInformation['dinnerTime']?? "",
                          )),
                  );
                },
              ),
              //tên thông tin cơ bản
              const SizedBox(height: 24),
              Column(
                children: [
                  Text(
                    userInfomation.loginuser!.displayName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userInfomation.loginuser!.email.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 24),
              //hiện trang thái đăng ký gói
              Center(
                  child: 
                !userInfomation.paided ?
                ButtonWidget(
                text: 'Nâng cấp tài khoản?',
                onClicked: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OptionPaymentScreen(),
                    ),
                  );
                },
              ) :ButtonWidget(
                text: "đăng ký ${curentPackage[0]['duration'] ?? "...."} Ngày",
                onClicked: () {
                  log("đã đăng ký");
                },
              )
              
              ),
              //
              const SizedBox(height: 24),
              //thông tin
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //tên
                    const Text(
                      'Họ và Tên:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['applicationUser']['userName'] ??
                          'Chưa cập nhật',
                      style:  TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const Text(
                      'Email:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['applicationUser']['email'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const Text(
                      'Ngày Sinh:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['dob'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    const Text(
                      'Số Điện Thoại:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['applicationUser']['phoneNumber'] ??
                          'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    const Text(
                      'Địa Chỉ:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['address'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const Text(
                      'Giờ ăn sáng mặc định:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['breakfastTime'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const Text(
                      'Giờ ăn Trưa mặc định:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['lunchTime'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    const Text(
                      'Giờ ăn Chiều mặc định:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      nowInformation['afternoonTime'] ?? 'Chưa cập nhật',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
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
