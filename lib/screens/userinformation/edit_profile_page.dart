import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/screens/userinformation/components/appbar_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/profile_widget.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/services/auth/auth_service.dart';

class EditProfilePage extends StatefulWidget {
  final String dob;
  final String phoneNumber;
  final String address;
  final String sTime;
  final String trTime;
  final String cTime;
  final String tTime;
  final String offtime;
  const EditProfilePage(
      {super.key,
      required this.dob,
      required this.phoneNumber,
      required this.address,
      required this.sTime,
      required this.cTime,
      required this.tTime,
      required this.trTime, 
      required this.offtime});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _sTimeCtrl = TextEditingController();
  final TextEditingController _trTimeCtrl = TextEditingController();
  final TextEditingController _cTimeCtrl = TextEditingController();
  final TextEditingController _tTimeCtrl = TextEditingController();
  final TextEditingController _offSetTimeCtrl = TextEditingController();
  DateTime dobTime = DateTime.now();

  void putCutomerprofilr(DateTime pickdate) async {
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate2 = outputFormat.format(pickdate);
    log("putCutomerprofilr Inputdata $outputDate2");
    log("putCutomerprofilr Inputdata ${_addressCtrl.text}");
    log("putCutomerprofilr Inputdata ${_phoneCtrl.text}");
    final response = await http.put(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/customers"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "dob": outputDate2,
        "address": _addressCtrl.text,
        "phoneNumber": _phoneCtrl.text
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("putCutomerprofilr success ${response.statusCode}");
      final json = jsonDecode(response.body);
      log("putCutomerprofilr success ${json.toString()}");
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => putCutomerprofilr(pickdate));
    } else {
      log("putCutomerprofilr bug ${response.statusCode}");
    }
  }

  void putdefaultTime() async {
    log("putdefaultTime Inputdata ${_sTimeCtrl.text}");
    log("putdefaultTime Inputdata ${_trTimeCtrl.text}");
    log("putdefaultTime Inputdata ${_cTimeCtrl.text}");
    log("putdefaultTime Inputdata ${_tTimeCtrl.text}");
    log("putdefaultTime Inputdata ${_offSetTimeCtrl.text}");
    
    final response = await http.put(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/customers/meal-time"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "breakfastTime": _sTimeCtrl.text,
        "lunchTime": _trTimeCtrl.text,
        "afternoonTime": _cTimeCtrl.text,
        "dinnerTime": _tTimeCtrl.text,
        "mealTimeOffset": _offSetTimeCtrl.text
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      log("putdefaultTime success ${response.statusCode}");
      final json = jsonDecode(response.body);
      log("putdefaultTime success ${json.toString()}");
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => putdefaultTime());
    } else {
      log("putdefaultTime bug ${response.statusCode}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneCtrl.text = widget.phoneNumber;
    _addressCtrl.text = widget.address;
    _sTimeCtrl.text = widget.sTime;
    _trTimeCtrl.text = widget.trTime;
    _cTimeCtrl.text = widget.cTime;
    _tTimeCtrl.text = widget.tTime;
    _offSetTimeCtrl.text = widget.offtime;
    dobTime = DateTime.parse(widget.dob);
  }
  @override
  Widget build(BuildContext context) => Builder(
    
        builder: (context) => Scaffold(
          appBar: buildAppBar(context),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            physics: const BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: UserInfomation.loginuser!.photoURL.toString(),
                onClicked: () async {
                  Get.back();
                },
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: 'Ngày Sinh',
                hint: DateFormat.yMd().format(dobTime),
                widget: IconButton(
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _getDobFromUser();
                  },
                ),
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.text,
                tittle: 'Số Điện Thoại',
                hint: widget.phoneNumber,
                controller: _phoneCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.text,
                tittle: 'Địa Chỉ',
                hint: widget.address,
                controller: _addressCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Sáng",
                hint: widget.sTime,
                widget: IconButton(
                  onPressed: () {
                    _getSTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
                controller: _sTimeCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Trưa",
                hint: widget.trTime,
                widget: IconButton(
                  onPressed: () {
                    _gettrTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
                controller: _trTimeCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Chiều",
                hint: widget.cTime,
                widget: IconButton(
                  onPressed: () {
                    _getcTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
                controller: _cTimeCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Tối",
                hint: widget.tTime,
                widget: IconButton(
                  onPressed: () {
                    _getTTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
                controller: _tTimeCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ nhắc trước",
                hint: widget.offtime,
                widget: IconButton(
                  onPressed: () {
                    _getOffsetTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
                controller: _offSetTimeCtrl,
              ),
              TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.focused)) {
                      return Colors.red;
                    }
                    return null; // Defer to the widget's default.
                  }),
                ),
                onPressed: () {
                  putCutomerprofilr(dobTime);
                  putdefaultTime();
                },
                child: const Text('Cập nhật hồ sơ'),
              )
            ],
          ),
        ),
      );

  _getSTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _sTimeCtrl.text = _formatedTime;
    }
  }

  _gettrTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _trTimeCtrl.text = _formatedTime;
    }
  }

  _getcTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _cTimeCtrl.text = _formatedTime;
    }
  }

  _getTTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _tTimeCtrl.text = _formatedTime;
    }
  }

  _getOffsetTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _offSetTimeCtrl.text = _formatedTime;
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

  _getDobFromUser() async {
    DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.utc(1989, 11, 9),
        lastDate: DateTime.now());

    if (_pickedDate != null) {
      setState(() {
        dobTime = _pickedDate;
      });
    } else {
      log("something not right at time picker");
    }
  }
}
