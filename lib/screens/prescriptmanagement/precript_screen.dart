
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/home/hcomponents/prescriptdetails.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PrecriptManagement extends StatefulWidget {
  const PrecriptManagement({super.key});

  @override
  State<PrecriptManagement> createState() => _PrecriptManagementState();
}

class _PrecriptManagementState extends State<PrecriptManagement> {
  List<dynamic> thePrescriptsList = [];
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<Widget> itemsData = [];
  var ui;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void fetchPrescripts(String customerID) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/prescripts?CustomerCode=$customerID&IncludePrescriptDetails=true";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );

    if (respone.statusCode == 200 || respone.statusCode == 201) {
      setState(() {
        final json = jsonDecode(respone.body);
        thePrescriptsList = json;
        getPostsData();
        log("fetchPrescripts success ${respone.statusCode}");
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchPrescripts(customerID));
    } else {
      log("fetchPrescripts bug ${respone.statusCode}");
    }
  }
  
  void fecthUserInfor() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/customers/info";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      final json = jsonDecode(respone.body);
      ui = json;
      fetchPrescripts(ui['customerCode']);
      log("fecthUserInfor success ${respone.statusCode}");
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fecthUserInfor());
    }else {
      log("fecthUserInfor bug ${respone.statusCode}");
    }
  }
  
   void getPostsData() {
    List<dynamic> responseList = thePrescriptsList;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        InkWell(
            child: Container(
                height: 150,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Đơn Thuốc ngày ${DateFormat("yyyy-MM-dd").parse(post["receptionDate"])}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Bác sĩ: ${post["doctorName"]}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "BV: ${post["hospitalName"]}",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Image.network(
                        "${post['prescriptImage']}",
                        fit: BoxFit.fitWidth, //url,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset("assets/picture/wsa.jpg");
                        },
                        //height: 80,
                        width: 50,
                      ),
                    ],
                  ),
                )),
            onTap: () {
              log("click");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrescriptDetails(
                    pdList: post['prescriptDetails'],
                    prescriptID: post['id'],
                  ),
                ),
              );
            }),
      );
    });
    setState(() {
      itemsData = listItems;
    });
  }
@override
  void initState() {
    super.initState();
    fecthUserInfor();
    // controller.addListener(() {
    //   double value = controller.offset / 119;

    //   setState(() {
    //     topContainer = value;
    //     closeTopContainer = controller.offset > 50;
    //   });
    // });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            //the widget take space as per need
            Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}