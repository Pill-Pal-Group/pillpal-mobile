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
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/theme_services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pillpalmobile/services/ocr/Screen/recognization_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_cropper_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_picker_class.dart';
import 'package:pillpalmobile/services/ocr/Widgets/modal_dialog.dart';
import 'package:http/http.dart' as http;

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({super.key});

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  var notifyHelper;
  List<dynamic> medicinesInTake = [];
  List<dynamic> mInTake = [];
  String pid = "";
  List<dynamic> prescriptsList = [];
  var ui;
  DateTime today = DateTime.now();
  ScrollController controller = ScrollController();
  List<Widget> itemsData = [];
  bool closeTopContainer = false;
  double topContainer = 0;

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
    } else {
      log("fecthUserInfor bug");
    }

    //log(ui['customerCode']);
    //log(ui.toString());
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
      final json = jsonDecode(respone.body);

      prescriptsList = json;

      for (var e in prescriptsList) {
        fetchMedicineIntake(e['id'], today);
      }
    } else {
      log("fetchPrescripts bug");
    }

    //log(medicinesInTake.toString());
  }

  void fetchMedicineIntake(String idpr, DateTime todayy) async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate2 = outputFormat.format(todayy);
    log("fetchMedicineIntake bug ${outputDate2}");
    log("fetchMedicineIntake bug ${idpr}");
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medication-intakes/$idpr?dateTake=$outputDate2";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );
    //log("fetchMedicineIntake bug ${respone.statusCode}");
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      final json = jsonDecode(respone.body);
      //setState(() {
      medicinesInTake = json;
      //});
      takeJTD();
    } else {}
  }

  void takeJTD() {
    //mInTake = [];
    List<dynamic> tmp = [];
    for (var element in medicinesInTake) {
      tmp = element['medicationTakes'];
    }
    //setState(() {
    for (var element in tmp) {
      mInTake.add(element);
    }
    //});
    getPostsData();
    log(mInTake.toString());
  }

  void getPostsData() {
    List<dynamic> responseList = mInTake;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(
        InkWell(
          child: Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                            "Uống lúc ${post['timeTake']}",
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
                            "${post['dose']} Viên",
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Image.network(
                      "oke",
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
          onTap: () {},
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
    mInTake = [];
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    fecthUserInfor();
    getPostsData();
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
    mInTake = [];
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
          mInTake.isEmpty
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
        selectionColor: primaryClr,
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
            mInTake = [];
            today = date;
            fecthUserInfor();
            getPostsData();
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
          Container(
            //padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
          ),
          MsButton(
              lable: "Quét đơn",
              onTap: () => {
                    if (UserInfomation.paided)
                      {
                        imagePickerModal(context, onCameraTap: () {
                          pickImage(source: ImageSource.camera).then((value) {
                            if (value != '') {
                              imageCropperView(value, context).then((value) {
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
                              imageCropperView(value, context).then((value) {
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
                              title: Text('Chức năng nâng cao'),
                              content: Text('Hãy mua gói trả phí để sử dụng'),
                              backgroundColor: const Color(0xFFEFEFEF),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Đóng'),
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
              onTap: () =>
                  Get.to(() => const AddTaskScreen())),
                  //Get.to(() => const TermofService2())),
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
        // CircleAvatar(
        //   backgroundImage: AssetImage(LinkImages.tempAvatar),
        // ),
        // SizedBox(width: 20)
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
