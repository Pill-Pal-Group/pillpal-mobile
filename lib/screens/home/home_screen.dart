import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser!;
    return const Center(
      child: Scaffold(
        body: Center(child: Text(
          'user.email.toString()'
        )),
      ),
    );
  }
}
