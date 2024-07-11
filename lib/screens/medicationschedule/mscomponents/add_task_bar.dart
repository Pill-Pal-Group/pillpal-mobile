// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
//import 'package:pillpalmobile/model/medicine_type.dart';
import 'package:pillpalmobile/screens/home/new_entry/new_entry_bloc.dart';
//import 'package:pillpalmobile/screens/home/new_entry/new_entry_page.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/msbutton.dart';
import 'package:provider/provider.dart';
//import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late NewEntryBloc _newEntryBloc;
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  final TextEditingController _sNumCtrl = TextEditingController();
  final TextEditingController _trNumCtrl = TextEditingController();
  final TextEditingController _cNumCtrl = TextEditingController();
  final TextEditingController _tNumCtrl = TextEditingController();
  final TextEditingController _totalNumCtrl = TextEditingController();
  String tokene = userInfomation.accessToken;
  DateTime nowTime = DateTime.now();
  String _starTIme = DateFormat("hh:mm:a").format(DateTime.now()).toString();
  //int _selectedRemider = 10;
  List<int> remindList = [10, 15, 20, 30];

  //String _selectedRepeat = "Không nhắc lại";
  List<String> repeatList = ["Aftermeal", "Mỗi ngày"];

  int _seletedColor = 0;
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

  void pushMedicine() async {
    int day2 = int.parse(_totalNumCtrl.text) ~/
        (int.parse(_sNumCtrl.text) +
            int.parse(_trNumCtrl.text) +
            int.parse(_cNumCtrl.text) +
            int.parse(_tNumCtrl.text));
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 =
        outputFormat.format(nowTime.subtract(const Duration(days: 10)));
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
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    genMediceneIntake(json['id']);
    log(json.toString());
  }

  void genMediceneIntake(String pID) async {
    final response = await http.post(
      Uri.parse(
          "https://pp-devtest2.azurewebsites.net/api/medication-intakes/$pID"),
      headers: <String, String>{
        'Authorization': 'Bearer $tokene',
      },
    );
    final json = jsonDecode(response.body);
    log(json.toString());
  }


  void pushMedicine2() async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 =
        outputFormat.format(nowTime.subtract(const Duration(days: 1)));
    var outputDate2 = outputFormat.format(nowTime);
    var outputDate3 = outputFormat.format(nowTime.add(Duration(days: 1)));
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
            "totalDose": int.parse(_sNumCtrl.text)+int.parse(_trNumCtrl.text)+int.parse(_cNumCtrl.text)+int.parse(_tNumCtrl.text),
            "morningDose": int.parse(_sNumCtrl.text),
            "noonDose": int.parse(_trNumCtrl.text),
            "afternoonDose": int.parse(_cNumCtrl.text),
            "nightDose": int.parse(_tNumCtrl.text),
            "dosageInstruction": "Aftermeal"
          }
        ]
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    //genMediceneIntake2(outputDate2,_starTIme,);
    log(json.toString());
  }

  void genMediceneIntake2(
      String dateTake, String timeTake, int dose, String id) async {
    final response = await http.post(
      Uri.parse(""),
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
    final json = jsonDecode(response.body);
    log(json.toString());
  }

  @override
  void initState() {
    super.initState();
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
                    icon: Icon(
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
                      width: MediaQuery.of(context).size.width / 2,
                    )
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
                    SizedBox(
                      width: 12,
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
                      width: 12,
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
                      width: 12,
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
                MsInputFeild(
                  type: TextInputType.datetime,
                  tittle: "Giờ uống thuốc",
                  hint: _starTIme,
                  widget: IconButton(
                    onPressed: () {
                      _getSTimeFromUser(isStarTime: true);
                    },
                    icon: Icon(
                      Icons.access_time_rounded,
                      color: Colors.grey,
                    ),
                  ),
                ),
                //gio
                // Row(
                //   children: [
                //     //time bat dau
                //     Expanded(
                //         child: MsInputFeild(
                //       tittle: "Giờ uống thuốc",
                //       hint: _starTIme,
                //       widget: IconButton(
                //         onPressed: () {
                //           _getSTimeFromUser(isStarTime: true);
                //         },
                //         icon: Icon(
                //           Icons.access_time_rounded,
                //           color: Colors.grey,
                //         ),
                //       ),
                //     )
                //     ),
                //     // SizedBox(
                //     //   width: 12,
                //     // ),
                //     //time end
                //     // Expanded(
                //     //     child: MsInputFeild(
                //     //   tittle: "End time",
                //     //   hint: _endtime,
                //     //   widget: IconButton(
                //     //     onPressed: () {
                //     //       _getSTimeFromUser(isStarTime: false);
                //     //     },
                //     //     icon: Icon(
                //     //       Icons.access_time_rounded,
                //     //       color: Colors.grey,
                //     //     ),
                //     //   ),
                //     // )),
                //   ],
                // ),
                // bao truoc bao nhieu phut
                // MsInputFeild(
                //   tittle: 'Nhắc trước:',
                //   hint: "Nhắc trước $_selectedRemider phút",
                //   widget: DropdownButton(
                //     icon: Icon(
                //       Icons.keyboard_arrow_down,
                //       color: Colors.grey,
                //     ),
                //     iconSize: 32,
                //     elevation: 4,
                //     style: subtitlestyle,
                //     underline: Container(
                //       height: 0,
                //     ),
                //     items: remindList.map<DropdownMenuItem<String>>((int value) {
                //       return DropdownMenuItem<String>(
                //         value: value.toString(),
                //         child: Text(value.toString()),
                //       );
                //     }).toList(),
                //     onChanged: (String? newValue) {
                //       setState(() {
                //         _selectedRemider = int.parse(newValue!);
                //       });
                //     },
                //   ),
                // ),
                //lap laij ra sao
                ///test
                SizedBox(
                  height: 20,
                ),
                //
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //_colorChose(),
                    MsButton(
                      lable: 'Chốt đơn',
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

      log(_titleCtrl.text.toString());
      log(_noteCtrl.text.toString());
      log(_sNumCtrl.text.toString());
      log(_trNumCtrl.text.toString());
      log(_cNumCtrl.text.toString());
      log(_tNumCtrl.text.toString());
      log(_totalNumCtrl.text.toString());
      log("${nowTime.year}-0${nowTime.month - 1}-0${nowTime.day}");
      log("${nowTime.year}-0${nowTime.month}-0${nowTime.day}");
      log("${nowTime.year}-0${nowTime.month}-0${nowTime.day + 2}");
      pushMedicine();
      Get.back();
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
        //log(nowTime.toString());
      });
    } else {
      log("something not right at time picker");
    }
  }

  _getSTimeFromUser({required bool isStarTime}) async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else if (isStarTime == true) {
      setState(() {
        _starTIme = _formatedTime;
      });
    } else if (isStarTime == false) {
      setState(() {});
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

  _colorChose() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Some Shit",
          style: headingstyle,
        ),
        SizedBox(
          height: 8,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _seletedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.grey,
                  child: _seletedColor == index
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}
