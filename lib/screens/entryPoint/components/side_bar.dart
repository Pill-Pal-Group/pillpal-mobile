import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/freetrialscreens/trial_screen.dart';
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';
import 'package:pillpalmobile/screens/tos/termofservice.dart';
import 'package:pillpalmobile/screens/userinformation/profile_page.dart';
import 'package:rive/rive.dart';

import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Menu selectedSideMenu = sidebarMenus.first;

  Future<void> sidebarNavigator() async {
    switch (selectedSideMenu.title) {
      case "Hồ Sơ":
      
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfilePage(),
          ),
        );
        break;
      case "Đơn Thuốc":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FreeTrialScreen(),
          ),
        );
        break;
      case "Nâng Cấp":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FreeTrialScreen(),
          ),
        );
        break;
      case "Điều khoảng":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TermofService(),
          ),
        );
        break;
      case "Đăng xuất":
        await GoogleSignIn().signOut();
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OnbodingScreen(),
          ),
        );
        break;
      default:
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                linkne: user.photoURL.toString(),
                name: user.displayName ?? 'no name',
                bio: user.email ?? 'no email',
              ),
              // const InfoCard(
              //   linkne: "",
              //   name: 'no name',
              //   bio: 'no email',
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "DANH MỤC".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                            sidebarNavigator();
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  // .toList()
                  ,
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "CÀI ĐẶT".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2
                  .map((menu) => SideMenu(
                        menu: menu,
                        selectedMenu: selectedSideMenu,
                        press: () {
                          RiveUtils.chnageSMIBoolState(menu.rive.status!);
                          setState(() {
                            selectedSideMenu = menu;
                            sidebarNavigator();
                          });
                        },
                        riveOnInit: (artboard) {
                          menu.rive.status = RiveUtils.getRiveInput(artboard,
                              stateMachineName: menu.rive.stateMachineName);
                        },
                      ))
                  // .toList()
                  ,
            ],
          ),
        ),
      ),
    );
  }
}
