import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/constants.dart';

class TermofService extends StatefulWidget {
  const TermofService({super.key});

  @override
  State<TermofService> createState() => _TermofServiceState();
}

class _TermofServiceState extends State<TermofService> {
  List<dynamic> tosList = [];
  ScrollController controller = ScrollController();
  bool _customIcon = false;
  bool closeTopContainer = false;
  double topContainer = 0;

  void fecthTOS() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/terms-of-services";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
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
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Điều khoản và dịch vụ'),
      ),
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
                          ExpansionTile(
                            title: Text("${tosList[index]['title']}"),
                            trailing: Icon(_customIcon
                                ? Icons.arrow_drop_down_circle
                                : Icons.arrow_drop_down),
                            children: [
                              ListTile(
                                title: Text("${tosList[index]['content']}"),
                              )
                            ],
                            onExpansionChanged: (bool expanded) {
                              setState(() {
                                _customIcon = expanded;
                              });
                            },
                          )
                        ],
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
