import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/home/home_screen.dart';
import 'package:pillpalmobile/screens/onboding/components/sign_in_dialog.dart';
import 'package:pillpalmobile/services/auth_service.dart';
import 'package:rive/rive.dart';

import 'components/animated_btn.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          //wellcome Text
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    const SizedBox(
                      width: 260,
                      child: Column(
                        children: [
                          Text(
                            "Pill Pal Xin Chào",
                            style: TextStyle(
                              color: Color.fromARGB(255, 14, 196, 168),
                              fontSize: 60,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 16),
                          // Text(
                          // "Chào mừng bạn mới",
                          // ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    //day la cai nut
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      //bo cai login vo day ne
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              //isShowSignInDialog = true;
                            });
                            //cho nay de hien cai popup
                            // showCustomDialog(
                            //   context,
                            //   onValue: (_) {},
                            // );
                            // showCustomDialog(
                            //   context,
                            //   onValue: (_) {
                            //     setState(() {
                            //       isShowSignInDialog = false;
                            //     });
                            //   },
                            // );
                            //gắn cái gg vào đây và chuyên hướng

                            //signInWithGoogle();
                            //dang nhap thanh cong thi chuyen toi cai nay
                            
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EntryPoint(),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Chúc bạn một ngày tốt lành",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Poppins",
                          height: 1.2,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
