import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/global_bloc.dart';
import 'package:pillpalmobile/model/medicine.dart';
import 'package:pillpalmobile/screens/home/medicine_details/medicine_details.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            SizedBox(
              height: 8.h,
            ),
            //chứa phần đầu
            const TopContainer(),
            SizedBox(
              height: 1.h,
            ),
            //the widget take space as per need
            const Flexible(
              //chứa phần dưới
              child: BottomContainer(),
            ),
          ],
        ),
      ),
      //cái nut add thuốc
      // floatingActionButton: InkResponse(
      //   onTap: () {
      //     // go to new entry page
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const NewEntryPage(),
      //       ),
      //     );
      //   },
      //   child: SizedBox(
      //     width: 18.w,
      //     height: 9.h,
      //     child: Card(
      //       color: kPrimaryColor,
      //       shape: BeveledRectangleBorder(
      //         borderRadius: BorderRadius.circular(3.h),
      //       ),
      //       child: Icon(
      //         Icons.add_outlined,
      //         color: kScaffoldColor,
      //         size: 50.sp,
      //       ),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

//phần đầu
class TopContainer extends StatelessWidget {
  const TopContainer({super.key});
  @override
  Widget build(BuildContext context) {
    Provider.of<GlobalBloc>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //này là câu nới đầu app
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text(
            'Yên Tâm Sống. \nLà Sống khỏe.',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            'PillPal đồng hành cùng bạn',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 1.h,
        ),

        //Đây là chổ đếm số lời nhắc hôm nay
        // StreamBuilder<List<Medicine>>(
        //     stream: globalBloc.medicineList$,
        //     builder: (context, snapshot) {
        //       return Container(
        //         alignment: Alignment.center,
        //         padding: EdgeInsets.only(bottom: 1.h),
        //         child: Text(
        //           !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
        //           style: Theme.of(context).textTheme.headlineMedium,
        //         ),
        //       );
        //     }),
      ],
    );
  }
}

//phần đáy
class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);

    return StreamBuilder(
      stream: globalBloc.medicineList$,
      builder: (context, snapshot) {
        //có something
        if (!snapshot.hasData) {
          //if no data is saved
          return Container();
        }
        //nếu không có data
        else if (snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'Chưa có đơn thuốc mới',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
          );
        }
        // có data
        else {
          return GridView.builder(
            padding: EdgeInsets.only(top: 1.h),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return MedicineCard(medicine: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}

//cái thẻ thuốc đã thêm.
class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key, required this.medicine});
  final Medicine medicine;
  //icon catalog
  Hero makeIcon(double size) {
    if (medicine.medicineType == 'Bottle') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/bottle.svg',
          // ignore: deprecated_member_use
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Pill') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/pill.svg',
          // ignore: deprecated_member_use
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Syringe') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/syringe.svg',
          // ignore: deprecated_member_use
          color: kOtherColor,
          height: 7.h,
        ),
      );
    } else if (medicine.medicineType == 'Tablet') {
      return Hero(
        tag: medicine.medicineName! + medicine.medicineType!,
        child: SvgPicture.asset(
          'assets/icons/tablet.svg',
          // ignore: deprecated_member_use
          color: kOtherColor,
          height: 7.h,
        ),
      );
    }
    //in ra cái này khi lỗi
    return Hero(
      tag: medicine.medicineName! + medicine.medicineType!,
      child: Icon(
        Icons.error,
        color: kOtherColor,
        size: size,
      ),
    );
  }

  //cái ô hiển thị lịch
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: const Color.fromARGB(255, 255, 255, 255),
      splashColor: const Color.fromARGB(255, 147, 135, 135),
      onTap: () {
        //điều hướng qua trang detail.
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, Widget? child) {
                    return Opacity(
                      opacity: animation.value,
                      child: 
                      MedicineDetails(medicine),
                    );
                  },
                );
              },
              //transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        });
      },
      child: 
      //cái ô bênh ngoài
      Container(
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(2.h),
        ),

        child: 
        //nội dung bênh trong
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //
            const Spacer(),
            makeIcon(7.h),
            const Spacer(),
            //2 cái chữ bên trong
            Hero(
              tag: medicine.medicineName!,
              child: Text(
                medicine.medicineName!,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.start,
                style: 
                Theme.of(context).textTheme.titleLarge,
              ),
            ),
            //cái ô ngăn giữ tên và thời gian
            SizedBox(
              height: 1.h,
            ),
            //Hiện cái vòng tuần hoàn nhắc nhở
            Text(
              medicine.interval == 1
                  ? "Mỗi ${medicine.interval} Giờ"
                  : "Mỗi ${medicine.interval} Giờ",
              overflow: TextOverflow.fade,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
