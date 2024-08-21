import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:get/get.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/notification_services.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class MethodPaymentScreen extends StatefulWidget {
  final dynamic thePackagePick;
  const MethodPaymentScreen({super.key, required this.thePackagePick});

  @override
  State<MethodPaymentScreen> createState() => _MethodPaymentScreenState();
}

class _MethodPaymentScreenState extends State<MethodPaymentScreen> {
  String tokene = UserInfomation.accessToken;
  var notifyHelper;
  //int _type = 1;
  List<dynamic> paymentList = [];
  bool pickyet = false;
  String packageId = "";
  String paymentID = "";
  String payResult = "ko co gi";

  void postCustomerPackage(String packageID, String paymentID) async {
    final response = await http.post(
      Uri.parse(APILINK.postCustomerPackage),
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
      log("Thanh Toán Thành Công");
    } else {
      log("đã có vấn đề thanh toán");
    }
  }

  void postPaymentToVNpay(String pcId) async {
    log(pcId);
    final response = await http.get(
        Uri.parse("${APILINK.postPaymentToVNpay}$pcId&PaymentType=ZALOPAY"),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $tokene',
          'Content-Type': 'application/json'
        });

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      log("fetchCategory Sussecc ${response.statusCode}");
      final json = jsonDecode(response.body);
      log("payment test ${json['paymentUrl']}");
      log("payment test ${json['zpTransToken']}");
      appcheck(json['zpTransToken'], json['customerPackageId']);
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => postPaymentToVNpay(pcId));
    } else {
      Get.snackbar(
        "Thanh toán thất bại",
        "Vui lòng thử lại",
        snackPosition: SnackPosition.TOP,
        colorText: const Color.fromARGB(255, 255, 0, 0),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      );
      log("fetchCategory bug ${response.statusCode}");
    }
  }

  void getcomfompayment(String pcId) async {
    log(pcId);
    final respone = await http.get(
        Uri.parse("${APILINK.getcomfompayment}$pcId"),
        headers: <String, String>{
          'accept': 'application/json',
          'Authorization': 'Bearer $tokene',
          'Content-Type': 'application/json'
        });
    log(respone.statusCode.toString());
    if (respone.statusCode == 200 ||
        respone.statusCode == 201 ||
        respone.statusCode == 204) {
      Get.snackbar(
          "Thanh toán thành công",
          "Chúc một ngày tốt lành",
          snackPosition: SnackPosition.TOP,
          colorText: const Color.fromARGB(255, 0, 255, 0),
          duration: const Duration(seconds: 5),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EntryPoint(),
        ),
      );
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => getcomfompayment(pcId));
    } else {
      log("fetchCategory bug ${respone.statusCode}");
    }
  }

  Future<void> appcheck(String zpToken, String cpId) async {
    await FlutterZaloPaySdk.payOrder(zpToken: zpToken).then((event) {
      setState(() {
        switch (event) {
          case FlutterZaloPayStatus.cancelled:
            payResult = "User Huỷ Thanh Toán";
            log("payment test ${payResult}");
            Get.snackbar(
              "Bạn đã hũy thanh toán",
              "Vui lòng thử lại",
              snackPosition: SnackPosition.TOP,
              colorText: const Color.fromARGB(255, 255, 0, 0),
              duration: const Duration(seconds: 5),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            );
            break;
          case FlutterZaloPayStatus.success:
            payResult = "Thanh toán thành công";
            getcomfompayment(cpId);
            log("payment test ${payResult}");
            break;
          case FlutterZaloPayStatus.failed:
            payResult = "Thanh toán thất bại";
            Get.snackbar(
              "Thanh toán thất bại",
              "Vui lòng thử lại",
              snackPosition: SnackPosition.TOP,
              colorText: const Color.fromARGB(255, 255, 0, 0),
              duration: const Duration(seconds: 5),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            );
            log("payment test ${payResult}");
            break;
          default:
            payResult = "Thanh toán thất bại";
            Get.snackbar(
              "Thanh toán thất bại",
              "Vui lòng thử lại",
              snackPosition: SnackPosition.TOP,
              colorText: const Color.fromARGB(255, 255, 0, 0),
              duration: const Duration(seconds: 5),
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            );
            log("payment test 2 ${payResult}");
            break;
        }
      });
    });
  }

  @override
  void initState() {
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    log(widget.thePackagePick['id']);
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      //selectedPackageIndex = index;
                      pickyet = !pickyet;
                    });
                  },
                  child: Container(
                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                      border: pickyet
                          ? Border.all(width: 1, color: const Color(0xFFDB3022))
                          : Border.all(width: 0.3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Radio(
                                //   value: 1,
                                //   groupValue: _type,
                                //   onChanged: pickyet,
                                //   activeColor: const Color(0xFFDB3022),
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('ZaloPay',
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
                              LinkImages.zalopayLogo,
                              fit: BoxFit.fitHeight, //url,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                    LinkImages.erroPicHandelLocal);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                                        child: Text(
                                            paymentList[index]['paymentName'],
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
                                          LinkImages.erroPicHandelLocal);
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
                      postPaymentToVNpay(widget.thePackagePick['id']);
                      //paymentConform(true, packageId, paymentID);
                    },
                    child: const Text('Thanh Toán'),
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
