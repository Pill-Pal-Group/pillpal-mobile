import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FreeTrialScreen extends StatelessWidget {
  const FreeTrialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('      Comming soon'),
        //automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          children: [
            Text("Tính Năng chưa được bổ xung"),
          ],
        ),
      )
    );
  }
}