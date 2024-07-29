import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/onboding/onboding_screen.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class StayLoginCheck extends StatelessWidget {
  const StayLoginCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            log("StayLoginCheck Bug at services/auth/staylogin_check.dart");
            return const Center(
              child: Text("Lỗi kết nối hãy khởi động lại Ứng Dụng"),
            );
          } else {
            if (snapshot.data == null) {
              return const OnbodingScreen();
            } else {
              checklogin();
              return const Center(
              child: CircularProgressIndicator(),
            );
            }
          }
        },
      ),
    );
  }
}
