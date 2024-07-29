import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pillpalmobile/model/menu.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:sizer/sizer.dart';

class PrescriptDetails extends StatefulWidget {
  final List<dynamic> pdList;
  const PrescriptDetails({super.key, required this.pdList});

  @override
  State<PrescriptDetails> createState() => _PrescriptDetailsState();
}

class _PrescriptDetailsState extends State<PrescriptDetails> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<Widget> itemsData = [];

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void getPostsData() {
    log(widget.pdList.toString());
    List<dynamic> responseList = widget.pdList;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        InkWell(
            child: Container(
                height: 100,
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    color: const Color.fromARGB(255, 255, 255, 255),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Tên thuốc: ${post['medicineName']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            Text(
                              "Tổng ${post["totalDose"]} Viên",
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Sáng: ${post["morningDose"]}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                              height: 2,
                            ),
                                Text(
                                  "Trưa: ${post["noonDose"]}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                              height: 2,
                            ),
                                Text(
                                  "Chiều: ${post["afternoonDose"]}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                              height: 2,
                            ),
                                Text(
                                  "Tối: ${post["nightDose"]}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Image.network(
                        "${post['medicineImage']}",
                        fit: BoxFit.fitWidth, //url,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset("assets/picture/wsa.jpg");
                        },
                        height: 80,
                      ),
                    ],
                  ),
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryPoint(selectpage: bottomNavItems.last,medname: post['medicineName'],),
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
    getPostsData();
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
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 1,
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
