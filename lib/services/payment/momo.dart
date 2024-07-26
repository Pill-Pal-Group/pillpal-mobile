import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

class MomoTest extends StatefulWidget {
  const MomoTest({super.key});

  @override
  State<MomoTest> createState() => _MomoTestState();
}

class _MomoTestState extends State<MomoTest> {
  get http => null;


  void post() async {
    final response = await http.post(
      Uri.parse(
          "https://test-payment.momo.vn/v2/gateway/api/create"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    log(json.toString());
  }

  @override
  void initState() {
    super.initState();
    post();
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
