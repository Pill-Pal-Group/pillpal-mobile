import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/packageandpayment/method_payment.dart';
import 'package:http/http.dart' as http;

class OptionPaymentScreen extends StatefulWidget {
  const OptionPaymentScreen({super.key});

  @override
  State<OptionPaymentScreen> createState() => _OptionPaymentScreenState();
}

class _OptionPaymentScreenState extends State<OptionPaymentScreen> {
  List<dynamic> packageList = [];
  var selectPackage = null;
  int? selectedPackageIndex;
  bool pickyet = false;

  void fetchPackageList() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/package-categories";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    final body = respone.body;
    final json = jsonDecode(body);
    setState(() {
          packageList = json;
    });

    log(packageList.toString());
  }

  @override
  void initState() {
    fetchPackageList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            // Add border radius to all Cards globally
            borderRadius:
                BorderRadius.circular(10), // Adjust radius to your preference
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
            // title: const Center(
            //   child: Text('Đăng ký gói'),
            // ),
            ),
        body: Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     colors: [
          //       Color(0xFF85FFBD), // Start color
          //       Color(0xFFFFFB7D) // End color
          //     ],
          //   ),
          // ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset(LinkImages.tempAvatar, width: 100, height: 100),
              const SizedBox(height: 16),
              const Text('Mở khóa tất cả các tính năng của ứng dụng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),

              const SizedBox(height: 16), // Space between image and texts
              const Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Aligns the icon with the first line of text
                children: [
                  SizedBox(width: 8), // Space between icon and texts
                  Expanded(
                    // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align texts to the start
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Quét Đơn thuốc nhanh chóng',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Gợi ý thuốc theo thành phần',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Tra cứu thông tin thuốc nhanh chóng',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        // Repeat for each text item, changing the icon as needed
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16), // Space between texts and ListView
              Expanded(
                child: ListView.builder(
                  //itemCount: packages.length,
                  itemCount: packageList.length,
                  itemBuilder: (context, index) {
                    //bool isSelected = index == selectedPackageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          log(index.toString());
                          //selectedPackageIndex = index;
                          pickyet = !pickyet;
                          if (pickyet) {
                            selectPackage = packageList[index];
                          } else {
                            selectPackage = null;
                          }
                        });
                      },
                      child: Card(
                        //color: isSelected ? Colors.blue : Colors.white,
                        color: pickyet ? Colors.blue : Colors.white,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            packageList[index]["packageName"],
                            style: TextStyle(
                                //color: isSelected ? Colors.white : Colors.black,
                                color: pickyet ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${packageList[index]["packageDescription"]} - ${packageList[index]["price"]} VND",
                            style: TextStyle(
                              //color: isSelected ? Colors.white70 : Colors.black54,
                              color: pickyet ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: pickyet
                              ? const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    log("${selectPackage.toString()}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MethodPaymentScreen(
                                thePackagePick: selectPackage,
                              )),
                    );
                  },
                  child: const Text('Đăng ký'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
