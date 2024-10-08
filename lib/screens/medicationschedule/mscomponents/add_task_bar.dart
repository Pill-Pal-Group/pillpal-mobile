import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/model/menu.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/home/new_entry/new_entry_bloc.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/msbutton.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/notification_services.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_picker_class.dart';
import 'package:pillpalmobile/services/ocr/Widgets/modal_dialog.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var notifyHelper;
  late NewEntryBloc _newEntryBloc;
  final TextEditingController _titleCtrl = TextEditingController();
  //final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _sNumCtrl = TextEditingController();
  final TextEditingController _trNumCtrl = TextEditingController();
  final TextEditingController _cNumCtrl = TextEditingController();
  final TextEditingController _tNumCtrl = TextEditingController();
  final TextEditingController _totalNumCtrl = TextEditingController();
  String tokene = UserInfomation.accessToken;
  DateTime nowTime = DateTime.now();
  String _starTimes = DateFormat("hh:mm:a").format(DateTime.now()).toString();
  String _starTImetr = DateFormat("hh:mm:a").format(DateTime.now()).toString();
  String _starTImec = DateFormat("hh:mm:a").format(DateTime.now()).toString();
  String _starTImet = DateFormat("hh:mm:a").format(DateTime.now()).toString();

  List<String> repeatList = ["Trước khi ăn", "Sau khi ăn"];
  String _dropdownValue = "Trước khi ăn";
  String addtoapi = "";
  String imageprdLink = "";
  String prid = '';
  //hamf
  @override
  void dispose() {
    super.dispose();
    _newEntryBloc.dispose();
    _titleCtrl.dispose();
    _sNumCtrl.dispose();
    _trNumCtrl.dispose();
    _cNumCtrl.dispose();
    _tNumCtrl.dispose();
    _totalNumCtrl.dispose();
  }

  Future<void> pushMedicine(int day2) async {
    DateTime today = DateTime.now();
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 = outputFormat.format(today);
    var outputDate2 = outputFormat.format(nowTime);
    var outputDate3 = outputFormat.format(nowTime.add(Duration(days: (day2))));
    final response = await http.post(
      Uri.parse(APILINK.postPrescripts),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "prescriptImage": LinkImages.erroPicHandelLink,
        "receptionDate": outputDate1,
        "doctorName": "Không có",
        "hospitalName": "Không có",
        "prescriptDetails": [
          {
            "medicineName": _titleCtrl.text.toString(),
            "dateStart": outputDate2,
            "dateEnd": outputDate3,
            "totalDose": int.parse(_totalNumCtrl.text),
            "morningDose": double.parse(_sNumCtrl.text),
            "noonDose": double.parse(_trNumCtrl.text),
            "afternoonDose": double.parse(_cNumCtrl.text),
            "nightDose": double.parse(_tNumCtrl.text),
            "dosageInstruction": "Aftermeal"
          }
        ]
      }),
    );
    final json = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("pushMedicine Sussecc ${json['prescriptDetails'][0]['id']}");
      prid = json['prescriptDetails'][0]['id'];
      genMediceneIntake(day2, nowTime, json['prescriptDetails'][0]['id']);
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => pushMedicine(day2));
    } else {
      log("pushMedicine bug ${response.body}");
      log("pushMedicine bug ${response.statusCode}");
    }
  }

  void genMediceneIntake(int totalday, DateTime dateStarAdd, String id) {
    var outputFormat = DateFormat('yyyy-MM-dd');
    for (var i = 0; i < totalday; i++) {
      var dateTake = outputFormat.format(nowTime.add(Duration(days: i)));
      if (double.parse(_sNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTimes, double.parse(_sNumCtrl.text), id);
      }
      if (double.parse(_trNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTImetr, double.parse(_trNumCtrl.text), id);
      }
      if (double.parse(_cNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTImec, double.parse(_cNumCtrl.text), id);
      }
      if (double.parse(_tNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTImet, double.parse(_tNumCtrl.text), id);
      }
    }
  }

  void postMediceneIntake(
      String dateTake, String timeTake, double dose, String id) async {
    final response = await http.post(
      Uri.parse(APILINK.postMediceneIntake),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "dateTake": dateTake,
        "timeTake": timeTake,
        "dose": dose,
        "prescriptDetailId": id
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("postMediceneIntake Sussecc ${response.statusCode}");
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => postMediceneIntake(dateTake, timeTake, dose, id));
    } else {
      log("postMediceneIntake bug ${response.body}");
      log("postMediceneIntake bug ${response.statusCode}");
    }
  }

  void updateMedicineImage(String prescriptDetailId, String imageLink) async {
    String url = "${APILINK.putMedicineImage}$prescriptDetailId/image";
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
      log("updateMedicineImage success ${respone.statusCode}");
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(
              () => updateMedicineImage(prescriptDetailId, imageLink));
    } else {
      log("updateMedicineImage bug ${respone.statusCode}");
    }
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
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _newEntryBloc = NewEntryBloc();
  }

  //ham
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(),
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //tieu de
                Text(
                  "Điền thông tin thuốc",
                  style: headingstyle,
                ),
                //ten thuoc
                MsInputFeild(
                  type: TextInputType.text,
                  tittle: 'Tên Thuốc',
                  hint: 'Nhập tên thuốc',
                  controller: _titleCtrl,
                ),
                //note
                Container(
                  margin: EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Uống trước hay sau khi ăn",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 52,
                        margin: const EdgeInsets.only(top: 8.0),
                        padding: const EdgeInsets.only(left: 14.0),
                        //color: Colors.grey,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButton(
                                items: repeatList.map<DropdownMenuItem<String>>(
                                    (String mascot) {
                                  return DropdownMenuItem<String>(
                                      child: Text(mascot), value: mascot);
                                }).toList(),
                                value: _dropdownValue,
                                onChanged: (value) {
                                  setState(() {
                                    _dropdownValue = value.toString();
                                    if (_dropdownValue == "Sau khi ăn") {
                                      addtoapi = "Aftermeal";
                                    } else if (_dropdownValue ==
                                        "Trước khi ăn") {
                                      addtoapi = "Beforemeal";
                                    } else {
                                      addtoapi = "Aftermeal";
                                    }
                                  });
                                  log(addtoapi);
                                },
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                //time
                MsInputFeild(
                  type: TextInputType.datetime,
                  tittle: 'Ngày bắt đầu',
                  hint: DateFormat.yMd().format(nowTime),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                Text(
                  "Liều lượng",
                  style: headingstyle,
                ),
                Row(
                  children: [
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.number,
                        tittle: 'Số lượng thuốc',
                        hint: '0',
                        controller: _totalNumCtrl,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    Column(
                      children: [
                        Text(
                          "Ảnh Thuốc",
                          style: headingstyle,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            imagePickerModal(context, onCameraTap: () {
                              pickImage(source: ImageSource.camera)
                                  .then((value) {
                                if (value.$1 != '') {
                                  log("pick anh don thuoc ${value.$2}");
                                  uploads(value.$2, value.$1);
                                }
                              });
                            }, onGalleryTap: () {
                              pickImage(source: ImageSource.gallery)
                                  .then((value) {
                                if (value.$1 != '') {
                                  log("pick anh don thuoc ${value.$2}");
                                }
                              });
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.number,
                        tittle: 'Sáng',
                        hint: '0',
                        controller: _sNumCtrl,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.number,
                        tittle: 'Trưa',
                        hint: '0',
                        controller: _trNumCtrl,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.number,
                        tittle: 'Chiều',
                        hint: '0',
                        controller: _cNumCtrl,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.number,
                        tittle: 'Tối',
                        hint: '0',
                        controller: _tNumCtrl,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.datetime,
                        tittle: "Giờ Sáng",
                        hint: _starTimes,
                        widget: IconButton(
                          onPressed: () {
                            _getSTimeFromUser(1);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.datetime,
                        tittle: "Giờ Trưa",
                        hint: _starTImetr,
                        widget: IconButton(
                          onPressed: () {
                            _getSTimeFromUser(2);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.datetime,
                        tittle: "Giờ Chiều",
                        hint: _starTImec,
                        widget: IconButton(
                          onPressed: () {
                            _getSTimeFromUser(3);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: MsInputFeild(
                        type: TextInputType.datetime,
                        tittle: "Giờ tối",
                        hint: _starTImet,
                        widget: IconButton(
                          onPressed: () {
                            _getSTimeFromUser(4);
                          },
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //_colorChose(),
                    MsButton(
                      lable: 'Thêm',
                      onTap: () => {_validateDate()},
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleCtrl.text.isNotEmpty && _totalNumCtrl.text.isNotEmpty) {
      //add to data
      if (_sNumCtrl.text.isEmpty) {
        _sNumCtrl.text = "0";
      }
      if (_trNumCtrl.text.isEmpty) {
        _trNumCtrl.text = "0";
      }
      if (_cNumCtrl.text.isEmpty) {
        _cNumCtrl.text = "0";
      }
      if (_tNumCtrl.text.isEmpty) {
        _tNumCtrl.text = "0";
      }
      double tmpnum = (double.parse(_sNumCtrl.text) +
          double.parse(_trNumCtrl.text) +
          double.parse(_cNumCtrl.text) +
          double.parse(_tNumCtrl.text));
      if (tmpnum > 0) {
        try {
          int day2 = int.parse(_totalNumCtrl.text) ~/ tmpnum;
          if (day2 >= 1) {
            pushMedicine(day2).whenComplete(() {
              updateMedicineImage(prid, imageprdLink);
              Get.snackbar(
                "Thêm Thành Công",
                "Kiểm tra lại đơn thuốc",
                snackPosition: SnackPosition.TOP,
                colorText: const Color.fromARGB(255, 94,186,36),
                duration: const Duration(seconds: 5),
                backgroundColor: const Color.fromARGB(255, 227, 227, 227),
              );
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
          } else {
            Get.snackbar(
              "Đã có vấn đề xảy ra",
              "Kiểm tra lại thông tin đơn thuốc",
              snackPosition: SnackPosition.TOP,
              colorText: Color.fromARGB(255, 255, 0, 0),
              duration: const Duration(seconds: 5),
              backgroundColor: const Color.fromARGB(255, 227, 227, 227),
            );
          }
        } catch (e) {
          Get.snackbar(
            "Đã có vấn đề xảy ra",
            "Kiểm tra lại thông tin đơn thuốc",
            snackPosition: SnackPosition.TOP,
            colorText: Color.fromARGB(255, 255, 0, 0),
            duration: const Duration(seconds: 5),
            backgroundColor: const Color.fromARGB(255, 227, 227, 227),
          );
        }
      } else {
        Get.snackbar(
          "Đã có vấn đề xảy ra",
          "Kiểm tra lại thông tin đơn thuốc",
          snackPosition: SnackPosition.TOP,
          colorText: Color.fromARGB(255, 255, 0, 0),
          duration: const Duration(seconds: 5),
          backgroundColor: const Color.fromARGB(255, 227, 227, 227),
        );
      }
    } else if (_titleCtrl.text.isEmpty || _totalNumCtrl.text.isEmpty) {
      Get.snackbar(
        "Đã có vấn đề xảy ra",
        "Kiểm tra lại thông tin đơn thuốc",
        snackPosition: SnackPosition.TOP,
        colorText: Color.fromARGB(255, 255, 0, 0),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      );
    }
  }

  _getDateFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));

    if (_pickedDate != null) {
      setState(() {
        nowTime = _pickedDate;
        log(nowTime.toString());
      });
    } else {
      log("something not right at time picker");
    }
  }

  _getSTimeFromUser(int numb) async {
    try {
      var pickedTime = await _showTimepicker();
      // ignore: use_build_context_synchronously
      String formatedTime = pickedTime.format(context);
      if (pickedTime == null) {
        log("time cancel");
      } else {
        switch (numb) {
          case 1:
            setState(() {
              _starTimes = formatedTime;
            });

            log("Time pick s: $_starTimes");
            break;
          case 2:
            setState(() {
              _starTImetr = formatedTime;
            });

            log("Time pick tr: $_starTImetr");
            break;
          case 3:
            setState(() {
              _starTImec = formatedTime;
            });

            log("Time pick c: $_starTImec");

          case 4:
            setState(() {
              _starTImet = formatedTime;
            });

            log("Time pick t: $_starTImet");
            break;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Đã có vấn đề xảy ra",
        "Kiểm tra lại thời gian",
        snackPosition: SnackPosition.TOP,
        colorText: const Color.fromARGB(255, 255, 0, 0),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      );
    }
  }

  _showTimepicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime:
          TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
    );
  }
}
