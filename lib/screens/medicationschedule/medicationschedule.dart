import 'dart:convert';
import 'dart:developer';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/add_task_bar.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/msbutton.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/notification_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:pillpalmobile/services/auth/package_check.dart';
import 'package:pillpalmobile/services/noti/alarm_provider.dart';
import 'package:pillpalmobile/services/ocr/Screen/recognization_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_cropper_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_picker_class.dart';
import 'package:pillpalmobile/services/ocr/Widgets/modal_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({super.key});

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  var notifyHelper;
  List<dynamic> medicinesInTake = [];
  //List<dynamic> mInTake = [];
  //List<String> mIntakeName = [];
  String pid = "";
  List<dynamic> prescriptsList = [];
  DateTime today = DateTime.now();
  ScrollController controller = ScrollController();
  List<Widget> itemsData = [];
  bool closeTopContainer = false;
  double topContainer = 0;

  void fetchPrescripts() async {
    String url = APILINK.homePagefetchPrescripts;
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      final json = jsonDecode(respone.body);
      log("MedicationSchedule fetchPrescripts Success ${respone.statusCode}");
      prescriptsList = json['data'];
      thefor();
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchPrescripts());
    } else {
      log("MedicationSchedule fetchPrescripts bug ${respone.statusCode}");
    }
  }

  Future<void> thefor() async {
    for (var e in prescriptsList) {
      log("fetchPrescripts success idPr: ${e['id']}");
      fetchMedicineIntake(e['id'], today).whenComplete(() {
        log("Data: 1 $medicinesInTake");
        try {
          for (var eachMed in medicinesInTake) {
            getPostsData(eachMed['medicineName'],
                eachMed['medicineImage'] ?? "", eachMed['medicationTakes']);
          }
        } catch (e) {
          log("Data: 3 $e");
        }
      });
    }
  }

  Future<void> fetchMedicineIntake(String idpr, DateTime todayy) async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate2 = outputFormat.format(todayy);
    String url =
        "${APILINK.fetchMedicineIntakeHeader}$idpr?dateTake=$outputDate2";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );
    final json = jsonDecode(respone.body);
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      //log("MedicationSchedule fetchMedicineIntake success ${json.toString()}");
      medicinesInTake = json;
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchMedicineIntake(idpr, todayy));
    } else {
      log("MedicationSchedule fetchMedicineIntake bug ${respone.statusCode}");
    }
  }

  void getPostsData(String name, String pickLink, List<dynamic> tmplist) {
    //log("Data: 2 $tmplist");
    List<dynamic> responseList = tmplist;
    List<Widget> listItems = [];
    for (var post in responseList) {
      listItems.add(
        InkWell(
          child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            softWrap: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${post['dose']} Viên || ${post['timeTake']}",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Image.network(
                      pickLink,
                      fit: BoxFit.fitWidth, //url,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(LinkImages.erroPicHandelLocal);
                      },
                      height: 80,
                    ),
                  ],
                ),
              )),
          onTap: () {
            log("Delete this Id: ${post['id']}");
          },
        ),
      );
    }
    for (var item in listItems) {
      setState(() {
        itemsData.add(item);
      });
    }
  }

  @override
  void initState() {
    context.read<Alarmprovider>().getData().whenComplete(() {
      log("Check point medicineSchedule");
      //context.read<alarmprovider>().ReloadNotification();
    });
    fetchpackageCheck();
    super.initState();
    itemsData = [];
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    fetchPrescripts();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
    itemsData = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          // cái này là phần đầu
          _addMediceneBar(),
          //hang ngay thang
          _addDatePickerBar(),
          //lich
          const SizedBox(
            height: 10,
          ),
          itemsData.isEmpty
              ? Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Hôm nay không có lời nhắc nào",
                      style: headingstyle,
                    ),
                  ],
                )
              : Expanded(
                  child: ListView.builder(
                      controller: controller,
                      itemCount: itemsData.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        double scale = 1.0;
                        // if (topContainer > 0.5) {
                        //   scale = index + 0.5 - topContainer;
                        //   if (scale < 0) {
                        //     scale = 0;
                        //   } else if (scale > 1) {
                        //     scale = 1;
                        //   }
                        // }
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
    );
  }

  _addDatePickerBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 120,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectedTextColor: Colors.white,
        selectionColor: Colors.cyan.shade200,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey)),
        //cai config chọn ngày
        onDateChange: (date) {
          setState(() {
            itemsData = [];
            itemsData.clear();
            today = date;
            fetchPrescripts();
            log(today.toString());
          });
        },
      ),
      //
    );
  }

  _addMediceneBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMd().format(DateTime.now()),
                style: subHeadingstyle,
              ),
              Text(
                "Hôm Nay",
                style: headingstyle,
              )
            ],
          ),
          MsButton(
              lable: "Quét đơn",
              onTap: () => {
                    if (UserInfomation.paided)
                      {
                        imagePickerModal(context, onCameraTap: () {
                          pickImage(source: ImageSource.camera).then((value) {
                            if (value != '') {
                              imageCropperView(value.$1, context).then((value) {
                                if (value != '') {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => RecognizePage(
                                        path: value,
                                      ),
                                    ),
                                  );
                                }
                              });
                            }
                          });
                        }, onGalleryTap: () {
                          pickImage(source: ImageSource.gallery).then((value) {
                            if (value != '') {
                              imageCropperView(value.$1, context).then((value) {
                                if (value != '') {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => RecognizePage(
                                        path: value,
                                      ),
                                    ),
                                  );
                                }
                              });
                            }
                          });
                        })
                      }
                    else
                      {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Chức năng nâng cao'),
                              content:
                                  const Text('Hãy mua gói trả phí để sử dụng'),
                              backgroundColor: const Color(0xFFEFEFEF),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Đóng'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        )
                      }
                  }),
          MsButton(
              lable: "Tạo Lịch",
              onTap: () => Get.to(() => const AddTaskScreen())),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      //leading: ,

      actions: [
        GestureDetector(
          onTap: () {
            log("oke");
            ThemeServices().switchTheme();
            notifyHelper.displayNotification(
                title: 'You change your theme',
                body: Get.isDarkMode
                    ? 'You changed your theme to dark !'
                    : 'You changed your theme to light !');
          },
          child: Icon(
              Get.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny_outlined,
              size: 40,
              color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
