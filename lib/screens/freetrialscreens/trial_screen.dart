import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FreeTrialScreen extends StatelessWidget {
  const FreeTrialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On Going funtion'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: 
        Text('Tính năng chưa bổ sung')
      ),
    );
  }
}