// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:pillpalmobile/constants.dart';
// import 'package:pillpalmobile/global_bloc.dart';
// import 'package:pillpalmobile/model/medicine.dart';
// import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';

// class PrescriptDetails extends StatefulWidget {
//   const PrescriptDetails(this.medicine, {super.key, required prescriptDetailslist});
//   final Medicine medicine;

//   @override
//   State<PrescriptDetails> createState() => _PrescriptDetailsState();
// }

// class _PrescriptDetailsState extends State<PrescriptDetails> {
//   @override
//   Widget build(BuildContext context) {
//     final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
//     return Scaffold(
//       //thanh tên tap
//       appBar: AppBar(
//         title: const Text('Thông tin chi tiết'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(2.h),
//         child: Column(
//           children: [
//             MainSection(medicine: widget.medicine),
//             ExtendedSection(medicine: widget.medicine),
//             const Spacer(),
//             SizedBox(
//               width: 100.w,
//               height: 7.h,
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: kSecondaryColor,
//                   shape: const StadiumBorder(),
//                 ),
//                 onPressed: () {
//                   openAlertBox(context, _globalBloc);
//                 },
//                 child: Text(
//                   'Xóa lịch thuốc',
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleMedium!
//                       .copyWith(color: kScaffoldColor),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 2.h,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //Nút Xóa thuốc
//   openAlertBox(BuildContext context, GlobalBloc _globalBloc) {
//     return showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: kScaffoldColor,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20.0),
//               bottomRight: Radius.circular(20.0),
//             ),
//           ),
//           contentPadding: EdgeInsets.only(top: 1.h),
//           title: Text(
//             'Bạn có thực muốn xóa không',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text(
//                 'Hủy',
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 //global block to delete medicine,later
//                 _globalBloc.removeMedicine(widget.medicine);

//                 //chuyen trang ơ day
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const EntryPoint(),
//                   ),
//                 );
//               },
//               child: Text(
//                 'Đồng ý',
//                 style: Theme.of(context)
//                     .textTheme
//                     .caption!
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class MainSection extends StatelessWidget {
//   const MainSection({Key? key, this.medicine}) : super(key: key);
//   final Medicine? medicine;
//   //thuốc calatog
//   Hero makeIcon(double size) {
//     if (medicine!.medicineType == 'Bottle') {
//       return Hero(
//         tag: medicine!.medicineName! + medicine!.medicineType!,
//         child: SvgPicture.asset(
//           'assets/icons/bottle.svg',
//           color: kOtherColor,
//           height: 7.h,
//         ),
//       );
//     } else if (medicine!.medicineType == 'Pill') {
//       return Hero(
//         tag: medicine!.medicineName! + medicine!.medicineType!,
//         child: SvgPicture.asset(
//           'assets/icons/pill.svg',
//           color: kOtherColor,
//           height: 7.h,
//         ),
//       );
//     } else if (medicine!.medicineType == 'Syringe') {
//       return Hero(
//         tag: medicine!.medicineName! + medicine!.medicineType!,
//         child: SvgPicture.asset(
//           'assets/icons/syringe.svg',
//           color: kOtherColor,
//           height: 7.h,
//         ),
//       );
//     } else if (medicine!.medicineType == 'Tablet') {
//       return Hero(
//         tag: medicine!.medicineName! + medicine!.medicineType!,
//         child: SvgPicture.asset(
//           'assets/icons/tablet.svg',
//           color: kOtherColor,
//           height: 7.h,
//         ),
//       );
//     }
//     //in case of no medicine type icon selection
//     return Hero(
//       tag: medicine!.medicineName! + medicine!.medicineType!,
//       child: Icon(
//         Icons.error,
//         color: kOtherColor,
//         size: size,
//       ),
//     );
//   }

//   //thông tin thuốc cơ bản
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         makeIcon(7.h),
//         SizedBox(
//           width: 2.w,
//         ),
//         Column(
//           children: [
//             Hero(
//               tag: medicine!.medicineName!,
//               child: Material(
//                 color: Colors.transparent,
//                 child: MainInfoTab(
//                     fieldTitle: 'Tên thuốc:',
//                     fieldInfo: medicine!.medicineName!),
//               ),
//             ),
//             MainInfoTab(
//                 fieldTitle: 'Liều dùng',
//                 fieldInfo: medicine!.dosage == 0
//                     ? 'chưa xác định'
//                     : "${medicine!.dosage} mg"),
//           ],
//         )
//       ],
//     );
//   }
// }

// //custome thông tin thuốc cơ bản
// class MainInfoTab extends StatelessWidget {
//   const MainInfoTab(
//       {super.key, required this.fieldTitle, required this.fieldInfo});
//   final String fieldTitle;
//   final String fieldInfo;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 40.w,
//       height: 10.h,
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               fieldTitle,
//               style: Theme.of(context).textTheme.titleSmall,
//             ),
//             SizedBox(
//               height: 0.3.h,
//             ),
//             Text(
//               fieldInfo,
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // thông tin chi tiết về liều thuốc
// class ExtendedSection extends StatelessWidget {
//   const ExtendedSection({super.key, this.medicine});
//   final Medicine? medicine;
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         ExtendedInfoTab(
//           fieldTitle: 'Dạng bào chế',
//           fieldInfo: medicine!.medicineType! == 'Chưa có thông tin'
//               ? 'Chưa xác định'
//               : medicine!.medicineType!,
//         ),
//         ExtendedInfoTab(
//           fieldTitle: 'Liều dùng:',
//           fieldInfo: 'Uống mỗi ${medicine!.interval} Tiếng',
//         ),
//         ExtendedInfoTab(
//           fieldTitle: 'Thời gian bắt đầu',
//           fieldInfo:
//               '${medicine!.startTime![0]}${medicine!.startTime![1]}:${medicine!.startTime![2]}${medicine!.startTime![3]}',
//         ),
//       ],
//     );
//   }
// }

// //custom cho phần chi tiết liều dùng
// class ExtendedInfoTab extends StatelessWidget {
//   const ExtendedInfoTab(
//       {Key? key, required this.fieldTitle, required this.fieldInfo})
//       : super(key: key);
//   final String fieldTitle;
//   final String fieldInfo;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 2.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(bottom: 1.h),
//             child: Text(
//               fieldTitle,
//               style: Theme.of(context).textTheme.titleSmall!.copyWith(
//                     color: kTextColor,
//                   ),
//             ),
//           ),
//           Text(
//             fieldInfo,
//             style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                   color: kSecondaryColor,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }
