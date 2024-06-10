
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/userinformation/components/appbar_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/button_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/profile_widget.dart';
import 'package:pillpalmobile/screens/userinformation/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //final user = UserPreferences.myUser;
    final user = FirebaseAuth.instance.currentUser!;
    return Builder(
        builder: (context) => Scaffold(
          //app bar
          appBar: buildAppBar(context),
          body: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            //chuyển qua trang edit
            children: [
              ProfileWidget(
                imagePath: user.photoURL.toString(),
                onClicked: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
              ),
              //tên thông tin cơ bản
              const SizedBox(height: 24),
              Column(
                children: [
                  Text(
                    user.displayName.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email.toString(),
                    style: const TextStyle(color: Colors.grey),
                  )
                ],
              ),
              const SizedBox(height: 24),
              //hiện trang thái đăng ký gói
              Center(
                  child: ButtonWidget(
                text: 'Nâng cấp tài khoản?',
                onClicked: () {},
              )),
              //
              const SizedBox(height: 24),
              //thông tin
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //tên
                    Text(
                      'Họ và Tên:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Nguyễn Hoàng Chiến',
                      style: TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    Text(
                      'Giới Tính:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Nam',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    Text(
                      'Ngày Sinh:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '1/1/1999',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    Text(
                      'Số Điện Thoại:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '0909080908',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    //NTMS
                    Text(
                      'Địa Chỉ:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'TP.Hồ Chí Minh',
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                    

                  ],
                ),
              ),

            ],
          ),
        ),
      );
  }
}
