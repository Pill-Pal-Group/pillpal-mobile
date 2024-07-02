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
import 'package:pillpalmobile/screens/paidhome/scanscreen.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({super.key});

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  var notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
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
              onTap:
                  //() => Get.to(()=> const AddTaskScreen())
                  () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ScanScreen(),
                          ),
                        )
                      }
          ),
          MsButton(
              lable: "Tạo Lịch",
              onTap:
                  () => Get.to(()=> const AddTaskScreen())
                  // () => {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const NewEntryPage(),
                  //         ),
                  //       )
                  //     }
          ),
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
