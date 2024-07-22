import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/services/payment/momo.dart';

class MethodPaymentScreen extends StatefulWidget {
  final dynamic thePackagePick;
  const MethodPaymentScreen({super.key,required this.thePackagePick});

  @override
  State<MethodPaymentScreen> createState() => _MethodPaymentScreenState();
}

class _MethodPaymentScreenState extends State<MethodPaymentScreen> {
  String tokene = UserInfomation.accessToken;
  //int _type = 1;
  List<dynamic> paymentList = [];
  bool pickyet = false;
  String packageId = "";
  String paymentID = "";

  void fetchPaymentList() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/payments";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    final body = respone.body;
    final json = jsonDecode(body);

    setState(() {
      paymentList = json;
    });
    log(paymentList.toString());
  }

  void postCustomerPackage(String packageID, String paymentID) async {
    final response = await http.post(
      Uri.parse(
          "https://pp-devtest2.azurewebsites.net/api/customer-packages/packages"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "packageCategoryId": packageID,
        "paymentId": paymentID
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    log(json.toString());
  }

  

  void paymentConform(bool check, String packageID, String paymentID) {
    if (check) {
      //Get.to(() => const MomoTest());
      postCustomerPackage(packageID, paymentID);
      Get.to(() => const EntryPoint());
    } else {
      log("đã có vấn đề thanh toán");
    }
  }

  @override
  void initState() {
    fetchPaymentList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Phương thức thanh toán'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                // const SizedBox(
                //   height: 40,
                // ),
                Expanded(
                  child: ListView.builder(
                    //itemCount: packages.length,
                    itemCount: paymentList.length,
                    itemBuilder: (context, index) {
                      //bool isSelected = index == selectedPackageIndex;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            //selectedPackageIndex = index;
                            pickyet = !pickyet;
                            if (pickyet) {
                              packageId = widget.thePackagePick['id'];
                              paymentID = paymentList[index]['id'];
                            } else {
                              packageId = "";
                              paymentID = "";
                            }
                          });
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 55,
                          decoration: BoxDecoration(
                            border: pickyet
                                ? Border.all(
                                    width: 1, color: const Color(0xFFDB3022))
                                : Border.all(width: 0.3, color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Radio(
                                      //   value: 1,
                                      //   groupValue: _type,
                                      //   onChanged: pickyet,
                                      //   activeColor: const Color(0xFFDB3022),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(paymentList[index]['paymentName'],
                                            style: pickyet
                                                ? const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFFDB3022))
                                                : const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey)),
                                      ),
                                    ],
                                  ),
                                  Image.network(
                                    paymentList[index]['paymentLogo'],
                                    fit: BoxFit.fitHeight, //url,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Image.asset(
                                          "assets/picture/wsa.jpg");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //log("oke ${packageId} + ${paymentID}");
                      paymentConform(true, packageId, paymentID);
                    },
                    child: const Text('Chốt đơn'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
