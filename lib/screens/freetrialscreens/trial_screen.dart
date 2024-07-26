import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';

class FreeTrialScreen extends StatefulWidget {
  const FreeTrialScreen({super.key});

  @override
  State<FreeTrialScreen> createState() => _FreeTrialScreenState();
}

class _FreeTrialScreenState extends State<FreeTrialScreen> {
  int numberOfPage = 10;
  int onPage = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('      Comming soon'),
          //automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              Text("Đây là trang số: $onPage"),
              NumberPaginator(
                numberPages: numberOfPage,
                onPageChange: (index) => {
                  setState(() {
                    onPage = index;
                  })
                },
              )
            ],
          ),
        ));
  }
}
