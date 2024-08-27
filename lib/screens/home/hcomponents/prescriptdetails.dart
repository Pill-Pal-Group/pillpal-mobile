import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/model/menu.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_picker_class.dart';
import 'package:pillpalmobile/services/ocr/Widgets/modal_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class PrescriptDetails extends StatefulWidget {
  final String prescriptID;
  final List<dynamic> pdList;
  final double mediaQuery;
  const PrescriptDetails(
      {super.key,
      required this.pdList,
      required this.prescriptID,
      required this.mediaQuery});

  @override
  State<PrescriptDetails> createState() => _PrescriptDetailsState();
}

class _PrescriptDetailsState extends State<PrescriptDetails> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  List<Widget> itemsData = [];
  String imageprdLink = "";

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Future<void> deletePrescripts(String prID) async {
    //log("Home DeletePrescripts $prID");
    String url = APILINK.deletePrescriptsHeader + prID;
    final uri = Uri.parse(url);
    final respone = await http.delete(
      uri,
      headers: <String, String>{
        'accept': '*/*',
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
        'Content-Type': 'application/json'
      },
    );
    if (respone.statusCode == 200 ||
        respone.statusCode == 201 ||
        respone.statusCode == 204) {
      log("Home DeletePrescripts Success ${respone.statusCode}");
      Get.snackbar(
        "Đã xóa đơn thuốc",
        "Kiểm tra lại đơn thuốc",
        snackPosition: SnackPosition.TOP,
        colorText: const Color.fromARGB(255, 94, 186, 36),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      );
    } else if (respone.statusCode == 404) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => deletePrescripts(prID));
    } else {
      log("Home DeletePrescripts bug ${respone.statusCode}");
    }
  }

  void updateMedicineImage(String prescriptDetailId, String imageLink) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/prescripts/prescript-details/$prescriptDetailId/image";
    final uri = Uri.parse(url);
    final respone = await http.put(uri,
        headers: <String, String>{
          'accept': '*/*',
          'Authorization': 'Bearer ${UserInfomation.accessToken}',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, dynamic>{'medicineImage': imageLink}));
    if (respone.statusCode == 200 ||
        respone.statusCode == 201 ||
        respone.statusCode == 204) {
      log("Home updateMedicineImage success ${respone.statusCode}");
      Get.snackbar(
        "Cập nhật thành công",
        "Kiểm tra lại đơn thuốc",
        snackPosition: SnackPosition.TOP,
        colorText: const Color.fromARGB(255, 94, 186, 36),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const EntryPoint(),
          ),
          (route) => false);
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(
              () => updateMedicineImage(prescriptDetailId, imageLink));
    } else {
      log("Home updateMedicineImage bug ${respone.statusCode}");
    }
  }

  void getPostsData(double md) {
    List<dynamic> responseList = widget.pdList;
    List<Widget> listItems = [];
    for (var post in responseList) {
      listItems.add(
        InkWell(
            child: Container(
                height: 120,
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
                                fontSize: 17,
                              ),
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              softWrap: true,
                            ),
                            Text(
                              "Tổng ${post["totalDose"]} Viên",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              verticalDirection: VerticalDirection.down,
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
                          return Image.asset(LinkImages.erroPicHandelLocal);
                        },
                        width: md,
                      ),
                    ],
                  ),
                )),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Bạn cần hỗ trợ gì?'),
                    //content: const Text('Hãy mua gói trả phí để sử dụng'),
                    backgroundColor: const Color(0xFFEFEFEF),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Tìm thuốc ${post['medicineName']}'),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EntryPoint(
                                  selectpage: bottomNavItems.last,
                                  medname: post['medicineName'],
                                ),
                              ),
                              (route) => false);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EntryPoint(
                          //       selectpage: bottomNavItems.last,
                          //       medname: post['medicineName'],
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      TextButton(
                        child: const Text('Cập nhật ảnh cho thuốc'),
                        onPressed: () {
                          imagePickerModal(context, onCameraTap: () {
                            pickImage(source: ImageSource.camera).then((value) {
                              if (value.$1 != '') {
                                log("pick anh don thuoc ${value.$2}");
                                uploads(value.$2, value.$1).whenComplete(() =>
                                    updateMedicineImage(
                                        post['id'], imageprdLink));
                              }
                            });
                          }, onGalleryTap: () {
                            pickImage(source: ImageSource.gallery)
                                .then((value) {
                              if (value.$1 != '') {
                                log("pick anh don thuoc ${value.$2}");
                                uploads(value.$2, value.$1).whenComplete(() =>
                                    updateMedicineImage(
                                        post['id'], imageprdLink));
                              }
                            });
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            }),
      );
    }
    setState(() {
      itemsData = listItems;
    });
  }

  Future<void> uploads(String? imageName, String pathinput) async {
    final tmppath = 'Medicines/$imageName';
    final file = File(pathinput);
    final ref = FirebaseStorage.instance.ref().child(tmppath);
    UploadTask? ult = ref.putFile(file);

    final sanpshot = await ult.whenComplete(() {});
    final url = await sanpshot.ref.getDownloadURL();
    setState(() {
      log("uploads success $url");
      imageprdLink = url;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData(widget.mediaQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.backgroundColor,
          actions: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Bạn có chắc muốn xóa đơn thuốc này'),
                      content: const Text(
                          'Đơn thuốc đã xóa sẽ không phục hồi được nữa'),
                      backgroundColor: const Color(0xFFEFEFEF),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.red, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Xóa'),
                          onPressed: () {
                            deletePrescripts(widget.prescriptID)
                                .whenComplete(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EntryPoint(
                                      selectpage: bottomNavItems[0],
                                      medname: "",
                                    ),
                                  ),
                                  (route) => false);
                            });
                          },
                        ),
                        TextButton(
                          child: const Text('Hủy'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Icon(Icons.delete_forever,
                  size: 40,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
            ),
          ]),
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
