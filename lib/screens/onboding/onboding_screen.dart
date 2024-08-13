import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:rive/rive.dart';
import 'components/animated_btn.dart';
import 'package:flutter/src/widgets/image.dart' as imagePacke;

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});
  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;
  bool isShowSignInDialog = false;
  
  @override
  void dispose() {
    super.dispose();
  }


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
          //cái hình dưới cái hình động
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            left: 100,
            bottom: 100,
            child: imagePacke.Image.asset(
              "assets/Backgrounds/Spline.png",
            ),
          ),
          //cái hình động
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/shapes.riv",
          ),
          //cái màng mờ mờ ảo ảo
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          //khu để câu chào và nút đăng nhập
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
                          //câu chào mừng
                          Text(
                            "PillPal Xin Chào",
                            style: TextStyle(
                              color: Color.fromARGB(255, 14, 196, 168),
                              fontSize: 55,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    const imagePacke.Image(
                      image: AssetImage('assets/picture/loginpic.png'),
                      opacity: AlwaysStoppedAnimation(0.7),
                    ),
                    const Spacer(flex: 1),
                    //đây là cái nút đăng nhập
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      //bo cai login vo day ne
                      press: () {
                        
                        _btnAnimationController.isActive = true;
                        Future.delayed(const Duration(milliseconds: 700),
                            () async {
                          setState(() {
                            isShowSignInDialog = true;
                          });
                          signInWithGoogle();
                          
                        });
                      },
                    ),
                    //câu chào cuối trang
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        "Chúc bạn một ngày tốt lành",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
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
