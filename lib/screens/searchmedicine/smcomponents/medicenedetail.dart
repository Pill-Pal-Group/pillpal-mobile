import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/comparemed.dart';
import 'utils.dart';

class MedicineDetailScreen extends StatelessWidget {
  final String medicineName;
  final bool rqr;
  final String image;
  final String specifName;
  final String specifDetail;
  final List<dynamic> activeIngredients;
  final List<dynamic> pharmaceuticalCompanies;
  final List<dynamic> medInbrand;

  const MedicineDetailScreen(
      {super.key,
      required this.medicineName,
      required this.rqr,
      required this.image,
      required this.specifName,
      required this.specifDetail,
      required this.activeIngredients,
      required this.pharmaceuticalCompanies,
      required this.medInbrand});
  final String oke = "Thuốc đại trà";
  final String notoke = "Thuốc kê đơn";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.network(
              image,
              fit: BoxFit.fitHeight, //url,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return Image.asset("assets/picture/wsa.jpg");
              },
            ),
          ),
          scroll(),
        ],
      ),
    ));
  }

  scroll() {
    String? textne;
    void okenene() {
      if (rqr) {
        textne = oke;
      } else {
        textne = notoke;
      }
    }

    okenene();
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  //ten thuoc
                  Text(
                    medicineName,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //co can don hay khong
                  Text(
                    textne ?? "không có thông tin",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: SecondaryText),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Kiểu đống gói:",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Kiểu ${specifName} ${specifDetail}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: SecondaryText),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Thành Phần Hoạt Tính",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: activeIngredients.length,
                    itemBuilder: (context, index) => ingredients(
                        activeIngredients[index]['ingredientName'] ??
                            "Chưa có thông tin"),
                  ),
                  //cong ty
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Công ty phân phối",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: activeIngredients.length,
                    itemBuilder: (context, index) => ingredients(
                        pharmaceuticalCompanies[index]['companyName'] ??
                            "Chưa có thông tin"),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompareMedicine(medInbrand2: medInbrand,),
                            ),
                          );
                      },
                      child: const Text('Tìm nơi bán'),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //thanh phan
  ingredients(String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE3FFF8),
            child: Icon(
              Icons.done,
              size: 15,
              color: primary,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            name,
          ),
        ],
      ),
    );
  }
}
