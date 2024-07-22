import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TermofService2 extends StatefulWidget {
  const TermofService2({super.key});

  @override
  State<TermofService2> createState() => _TermofService2State();
}

class _TermofService2State extends State<TermofService2> {
  List<dynamic> tosList = [];
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;


  void fecthTOS() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/terms-of-services";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri
    );
    final json = jsonDecode(respone.body);

    setState(() {
      tosList = json;
    });

    log(tosList.toString());
  }

  @override
  void initState() {
    setState(() {
      fecthTOS();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: tosList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text(
                              "${index.toString()}) ${tosList[index]['title']}"),
                          Text("${tosList[index]['content']}")
                        ],
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
