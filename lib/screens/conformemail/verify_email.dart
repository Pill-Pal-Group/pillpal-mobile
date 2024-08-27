import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';
import 'package:pillpalmobile/screens/tos/tosaccept.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) => const OnbodingScreen(),
          ), (route) => false);
              },
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0.5),
          child: Column(
            children: [
              //cái ảnhh
              const Image(
                image: AssetImage(LinkImages.emailVerify),
                width: BouncingScrollSimulation.maxSpringTransferVelocity,
                color: Colors.blue,
              ),
              //cái câu gì đó

              Text(
                'Vui lòng kiểm tra hộp thư của bạn',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    Get.to(() => const TermofService2());
                  },
                  child: const Text(
                    'Đến trang điều khoảng và dịch vụ',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ),
              ),
              //dieu khoang
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Tôi đã đọc và đồng ý với điều khoảng',
                    style: TextStyle(fontSize: 17.0),
                  ), //Text
                  const SizedBox(width: 5), //SizedBox
                  /** Checkbox Widget **/
                  Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      setState(() {
                        isSelected = value!;
                      });
                    },
                  ),
                ],
              ),

              //cái nút reload
              !isSelected
                  ? const SizedBox()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (UserInfomation.loginuser!.emailVerified) {
                            signInWithGoogle();
                          } else {
                            AwesomeNotifications().createNotification(
                                content: NotificationContent(
                                    id: 1,
                                    channelKey: "NotiKey",
                                    title: "PillPal",
                                    body:
                                        "email của bạn chưa được xác nhận hãy thử lại"));
                          }
                        },
                        child: const Text('Tôi đã xác nhân email'),
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    await UserInfomation.loginuser!.sendEmailVerification();
                  },
                  child:
                      const Text('nhấn vào đây nếu không nhận được email nào'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
