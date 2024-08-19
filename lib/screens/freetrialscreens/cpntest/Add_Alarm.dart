
// import 'dart:developer' as dev;
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// import 'Provier.dart';

// class AddAlarm extends StatefulWidget {
//   const AddAlarm({super.key});
//   @override
//   State<AddAlarm> createState() => _AddAlaramState();
// }

// class _AddAlaramState extends State<AddAlarm> {
//   late TextEditingController controller;

//   String? dateTime;
//   bool repeat = false;

//   DateTime? notificationtime;

//   String? name = "none";
//   int ? _milliseconds;

//   @override
//   void initState() {
//     controller = TextEditingController();
//     context.read<alarmprovider>().GetData();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: const [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(Icons.check),
//           )
//         ],
//         automaticallyImplyLeading: true,
//         title: const Text(
//           'Add Alarm',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height * 0.3,
//             width: MediaQuery.of(context).size.width,
//             child: Center(
//                 child: CupertinoDatePicker(
//               showDayOfWeek: true,
//               minimumDate: DateTime.now(),
//               dateOrder: DatePickerDateOrder.dmy,
//               onDateTimeChanged: (va) {
//                 dev.log("Alarm check: va $va");
//                 dateTime = DateFormat().add_jms().format(va);

//                 _milliseconds = va.microsecondsSinceEpoch;

//                 notificationtime = va;

//                 dev.log("check vaule ${dateTime.toString()}");
//               },
//             )),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: CupertinoTextField(
//                   placeholder: "Add Label",
//                   controller: controller,
//                 )),
//           ),
//           Row(
//             children: [
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(" Repeat daily"),
//               ),
//               CupertinoSwitch(
//                 value: repeat,
//                 onChanged: (bool value) {
//                   repeat = value;

//                   if (repeat == false) {
//                     name = "none";
//                   } else {
//                     name = "Everyday";
//                   }

//                   setState(() {});
//                 },
//               ),
//             ],
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 Random random = new Random();
//                 int randomNumber = random.nextInt(100);

//                 dev.log("Alarm check: lable ${controller.text}");
//                 dev.log("Alarm check: dateTime $dateTime");
//                 dev.log("Alarm check: when $name");
//                 dev.log("Alarm check: id $randomNumber");
//                 dev.log("Alarm check: milliseconds $_milliseconds");
//                 dev.log("Alarm check: notificationtime $notificationtime");
//                 dev.log("Alarm check: randomNumber $randomNumber");

//                 context.read<alarmprovider>().SetAlaram(
//                     controller.text, dateTime!, true, name!, randomNumber,_milliseconds!);
//                 context.read<alarmprovider>().SetData();

//                 context
//                     .read<alarmprovider>()
//                     .SecduleNotification(notificationtime!, randomNumber);

//                 Navigator.pop(context);
//               },
//               child: const Text("Set Alaram")),
//         ],
//       ),
//     );
//   }
// }
