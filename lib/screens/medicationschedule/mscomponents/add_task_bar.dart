// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/model/medicine_type.dart';
import 'package:pillpalmobile/screens/home/new_entry/new_entry_bloc.dart';
import 'package:pillpalmobile/screens/home/new_entry/new_entry_page.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/msbutton.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late NewEntryBloc _newEntryBloc;
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  DateTime nowTime = DateTime.now();
  String _starTIme = DateFormat("hh:mm:a").format(DateTime.now()).toString();
  int _selectedRemider = 10;
  List<int> remindList = [10,15,20,30];

  String _selectedRepeat = "Không nhắc lại";
  List<String> repeatList = ["Không nhắc lại", "Mỗi ngày"];

  int _seletedColor = 0;
  //hamf
  @override
  void dispose() {
    super.dispose();
    _newEntryBloc.dispose();
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
      body: 
      Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //tieu de
                Text(
                  "Điền thông tin đơn thuốc",
                  style: headingstyle,
                ),
                //ten thuoc
                MsInputFeild(
                  tittle: 'Tên Thuốc',
                  hint: 'Nhập tên thuốc',
                  controller: _titleCtrl,
                ),
                //note
                MsInputFeild(
                  tittle: 'Ghi chú',
                  hint: 'VD: uống trước khi ăn 30 phút',
                  controller: _noteCtrl,
                ),
                //time
                MsInputFeild(
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
                //gio
                Row(
                  children: [
                    //time bat dau
                    Expanded(
                        child: MsInputFeild(
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
                    )),
                    // SizedBox(
                    //   width: 12,
                    // ),
                    //time end
                    // Expanded(
                    //     child: MsInputFeild(
                    //   tittle: "End time",
                    //   hint: _endtime,
                    //   widget: IconButton(
                    //     onPressed: () {
                    //       _getSTimeFromUser(isStarTime: false);
                    //     },
                    //     icon: Icon(
                    //       Icons.access_time_rounded,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // )),
                  ],
                ),
                //bao truoc bao nhieu phut
                MsInputFeild(
                  tittle: 'Nhắc trước:',
                  hint: "Nhắc trước $_selectedRemider phút",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitlestyle,
                    underline: Container(
                      height: 0,
                    ),
                    items: remindList.map<DropdownMenuItem<String>>((int value) {
                      return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemider = int.parse(newValue!);
                      });
                    },
                  ),
                ),
                //lap laij ra sao
                MsInputFeild(
                  tittle: 'Nhắc lại mỗi:',
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey,
                    ),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitlestyle,
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    },
                    items:
                        repeatList.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value!,
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                //dang bao che
                Padding(
                  padding: EdgeInsets.only(top: 1.h),
                  child: StreamBuilder<MedicineType>(
                    //new entry block
                    stream: _newEntryBloc.selectedMedicineType,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //not yet clickable?
                          MedicineTypeColumn(
                              medicineType: MedicineType.Bottle,
                              name: 'Chai',
                              iconValue: 'assets/icons/bottle.svg',
                              isSelected: snapshot.data == MedicineType.Bottle
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Pill,
                              name: 'Viên nhộng',
                              iconValue: 'assets/icons/pill.svg',
                              isSelected: snapshot.data == MedicineType.Pill
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Syringe,
                              name: 'Tiêm',
                              iconValue: 'assets/icons/syringe.svg',
                              isSelected: snapshot.data == MedicineType.Syringe
                                  ? true
                                  : false),
                          MedicineTypeColumn(
                              medicineType: MedicineType.Tablet,
                              name: 'Vĩ',
                              iconValue: 'assets/icons/tablet.svg',
                              isSelected: snapshot.data == MedicineType.Tablet
                                  ? true
                                  : false),
                        ],
                      );
                    },
                  ),
                ),
                ///test
                SizedBox(
                  height: 5,
                ),
                //
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //_colorChose(),
                    MsButton(
                      lable: 'Chốt đơn',
                      onTap: () => _validateDate(),
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
      Get.back();
    } else if (_titleCtrl.text.isEmpty || _noteCtrl.text.isEmpty) {
      Get.snackbar("Hay dien thong tin", "Hay nhap day du thong tin",
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
      setState(() {
      });
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
