import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompareMedicine extends StatefulWidget {
  final List<dynamic> medInbrand2;
  const CompareMedicine({super.key, required this.medInbrand2});

  @override
  State<CompareMedicine> createState() => _CompareMedicineState();
}

class _CompareMedicineState extends State<CompareMedicine> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<Widget> itemsData = [];
  //search
  Future<void> launchMap(String address) async {
    String query = Uri.encodeComponent(address);
    Uri googleUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');
    if (await canLaunchUrl(googleUrl)) {
      log("oke123");
      await launchUrl(googleUrl);
    }
  }
  
  //funtion
  void getPostsData() {
    List<dynamic> responseList = widget.medInbrand2;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        InkWell(
          child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(100), blurRadius: 10.0),
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            post['brand']['brandName'] ??
                                "Chưa cập nhật thông tin",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "${post["price"]}",
                            style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Image.network(
                      "${post['brand']['brandLogo']}",
                      fit: BoxFit.fitWidth, //url,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset("assets/picture/wsa.jpg");
                      },
                      width: 70,
                    ),
                  ],
                ),
              )),
          onTap: () {
            launchMap(post['brand']['brandName']);
            log(post['brand']['brandName'] ?? "Chưa cập nhật thông tin");
          },
        ),
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
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }
  //fintion

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    "Danh Sách Thương hiệu",
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: BouncingScrollPhysics(),
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
                                heightFactor: 1,
                                alignment: Alignment.topCenter,
                                child: itemsData[index]),
                          ),
                        );
                      })
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
