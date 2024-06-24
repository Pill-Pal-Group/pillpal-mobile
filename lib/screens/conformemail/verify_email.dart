import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';
import 'package:pillpalmobile/services/auth_service.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnbodingScreen(),
                  ),
                );
              },
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(1),
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
                height: 20,
              ),
              //cái nút reload
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (user.emailVerified) {
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
                    await user.sendEmailVerification();
                  },
                  child:
                      const Text('nhấn vào đây nếu không nhận được email nào'),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Nếu gặp vấn đề hãy nhờ người thân kiểm tra giúp nhé',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
