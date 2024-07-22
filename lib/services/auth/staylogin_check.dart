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
            log("Lỗi nè");
            return const Center(
              child: Text("Lỗi nè"),
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
