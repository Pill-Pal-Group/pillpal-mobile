import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/screens/userinformation/components/appbar_widget.dart';
import 'package:pillpalmobile/screens/userinformation/components/profile_widget.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/screens/userinformation/profile_page.dart';

class EditProfilePage extends StatefulWidget {
  final userName;
  final dob;
  final phoneNumber;
  final address;
  final sTime;
  final lTime;
  final nTime;
  const EditProfilePage(
      {super.key,
      required this.userName,
      required this.dob,
      required this.phoneNumber,
      required this.address,
      required this.sTime,
      required this.lTime,
      required this.nTime});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _dobCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _addressCtrl = TextEditingController();
  final TextEditingController _sTimeCtrl = TextEditingController();
  final TextEditingController _lTimeCtrl = TextEditingController();
  final TextEditingController _nTimeCtrl = TextEditingController();

  void pushMedicine() async {
    final response = await http.put(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/customers"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "dob": _dobCtrl.text,
        "address": _addressCtrl.text,
        "phoneNumber": _phoneCtrl.text
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    log(json.toString());
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
                isEdit: true,
                onClicked: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.text,
                tittle: 'Ngày Sinh',
                hint: widget.dob ?? "Chưa cập nhật",
                controller: _dobCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.text,
                tittle: 'Số Điện Thoại',
                hint: widget.phoneNumber ?? "Chưa cập nhật",
                controller: _phoneCtrl,
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.text,
                tittle: 'Địa Chỉ',
                hint: widget.address ?? "Chưa cập nhật",
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
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Trưa",
                hint: widget.lTime,
                widget: IconButton(
                  onPressed: () {
                    _gettrTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              MsInputFeild(
                type: TextInputType.datetime,
                tittle: "Giờ uống thuốc Chiều",
                hint: widget.nTime,
                widget: IconButton(
                  onPressed: () {
                    _getcTimeFromUser();
                  },
                  icon: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.grey,
                  ),
                ),
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
                  log(_dobCtrl.text);
                  log(_phoneCtrl.text);
                  log(_addressCtrl.text);
                  pushMedicine();
                },
                child: const Text('Lưu'),
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
      _lTimeCtrl.text = _formatedTime;
    }
  }

  _getcTimeFromUser() async {
    var pickedTime = await _showTimepicker();
    String _formatedTime = pickedTime.format(context);
    if (pickedTime == null) {
      log("time cancel");
    } else {
      _nTimeCtrl.text = _formatedTime;
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
