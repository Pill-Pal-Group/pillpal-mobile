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
import 'package:pillpalmobile/services/noti/alarmlistupdate.dart';
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
  final TextEditingController _noteCtrl = TextEditingController();
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
  List<int> remindList = [10, 15, 20, 30];
  List<String> repeatList = ["Aftermeal", "Mỗi ngày"];
  String imageprdLink = "";
  String prid = '';
  //hamf
  @override
  void dispose() {
    super.dispose();
    _newEntryBloc.dispose();
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    _sNumCtrl.dispose();
    _trNumCtrl.dispose();
    _cNumCtrl.dispose();
    _tNumCtrl.dispose();
    _totalNumCtrl.dispose();
  }

  Future<void> pushMedicine() async {
    int day2 = int.parse(_totalNumCtrl.text) ~/
        (int.parse(_sNumCtrl.text) +
            int.parse(_trNumCtrl.text) +
            int.parse(_cNumCtrl.text) +
            int.parse(_tNumCtrl.text));
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 =
        outputFormat.format(nowTime.subtract(const Duration(days: 1)));
    var outputDate2 = outputFormat.format(nowTime);
    var outputDate3 = outputFormat.format(nowTime.add(Duration(days: day2)));
    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/prescripts"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "prescriptImage":
            "https://crazydiscostu.wordpress.com/wp-content/uploads/2023/11/history-of-the-rickroll.jpg",
        "receptionDate": outputDate1,
        "doctorName": "No",
        "hospitalName": "No",
        "prescriptDetails": [
          {
            "medicineName": _titleCtrl.text.toString(),
            "dateStart": outputDate2,
            "dateEnd": outputDate3,
            "totalDose": int.parse(_totalNumCtrl.text),
            "morningDose": int.parse(_sNumCtrl.text),
            "noonDose": int.parse(_trNumCtrl.text),
            "afternoonDose": int.parse(_cNumCtrl.text),
            "nightDose": int.parse(_tNumCtrl.text),
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
          .whenComplete(() => pushMedicine());
    } else {
      log("pushMedicine bug ${response.statusCode}");
    }
  }

  void genMediceneIntake(int totalday, DateTime dateStarAdd, String id) {
    var outputFormat = DateFormat('yyyy-MM-dd');
    for (var i = 0; i < totalday; i++) {
      var dateTake = outputFormat.format(nowTime.add(Duration(days: i)));
      if (int.parse(_sNumCtrl.text) > 0) {
        postMediceneIntake(dateTake, _starTimes, int.parse(_sNumCtrl.text), id);
      }
      if (int.parse(_trNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTImetr, int.parse(_trNumCtrl.text), id);
      }
      if (int.parse(_cNumCtrl.text) > 0) {
        postMediceneIntake(dateTake, _starTImec, int.parse(_cNumCtrl.text), id);
      }
      if (int.parse(_tNumCtrl.text) > 0) {
        postMediceneIntake(
            dateTake, _starTImetr, int.parse(_tNumCtrl.text), id);
      }
    }
  }

  void postMediceneIntake(
      String dateTake, String timeTake, int dose, String id) async {
    log("postMediceneIntake debug $dateTake");
    log("postMediceneIntake debug $timeTake");
    log("postMediceneIntake debug $dose");
    log("postMediceneIntake debug $id");
    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/medication-intakes"),
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
    log("postMediceneIntake debug ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      log("postMediceneIntake Sussecc ${response.statusCode}");
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => postMediceneIntake(dateTake, timeTake, dose, id));
    } else {
      log("postMediceneIntake bug ${response.statusCode}");
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
                MsInputFeild(
                  type: TextInputType.text,
                  tittle: 'Ghi chú',
                  hint: 'VD: uống trước khi ăn 30 phút',
                  controller: _noteCtrl,
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
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                          icon: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
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
                          icon: Icon(
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
    if (_titleCtrl.text.isNotEmpty && _noteCtrl.text.isNotEmpty) {
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
      pushMedicine()
          .whenComplete(() => updateMedicineImage(prid, imageprdLink));

      notifyHelper.displayNotification(
          title: 'Thêm thành công', body: 'Chúc một ngày tốt lành');
//       reloadAlarmList().whenComplete(() {
// Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => EntryPoint(
//             selectpage: bottomNavItems[1],
//           ),
//         ),
//       );
//       });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntryPoint(
            selectpage: bottomNavItems[1],
          ),
        ),
      );
    } else if (_titleCtrl.text.isEmpty || _noteCtrl.text.isEmpty) {
      Get.snackbar("Hãy điền thông tin", "Vui lòng nhập đầy đủ thông tin",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.redAccent,
          backgroundColor: Colors.white,
          icon: Icon(Icons.warning_sharp));
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
    var pickedTime = await _showTimepicker();
    // ignore: use_build_context_synchronously
    String formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      switch (numb) {
        case 1:
          _starTimes = formatedTime;
          log("Time pick s: $_starTimes");
          break;
        case 2:
          _starTImetr = formatedTime;
          log("Time pick tr: $_starTImetr");
          break;
        case 3:
          _starTImec = formatedTime;
          log("Time pick c: $_starTImec");

        case 4:
          _starTImet = formatedTime;
          log("Time pick t: $_starTImet");
          break;
      }
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
