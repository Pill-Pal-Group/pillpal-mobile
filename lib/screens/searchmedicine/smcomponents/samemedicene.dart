import 'dart:convert';
import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/medicenedetail.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/product_widget.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class SameMediceneScreen extends StatefulWidget {
  final List<dynamic> iName;
  const SameMediceneScreen({super.key, required this.iName});

  @override
  State<SameMediceneScreen> createState() => _SameMediceneScreenState();
}

class _SameMediceneScreenState extends State<SameMediceneScreen> {
  ScrollController controllerList = ScrollController();
  List<dynamic> sameMedicinesList = [];
  List<dynamic> printList = [];
  List<dynamic> medicineListFillted = [];
  int tottalPage = 0;

  Future<void> fetchMedicineForFillter(
      String medicineName, int pageNumBer, String categoryName) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?MedicineName=$medicineName&Category=$categoryName&Page=$pageNumBer&PageSize=50&IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );

    if (respone.statusCode == 200 || respone.statusCode == 201) {
      log("fetchMedicine Sussecc ${respone.statusCode}");
      setState(() {
        final json = jsonDecode(respone.body);
        tottalPage = json['totalPages'];
        sameMedicinesList = json['data'];
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchMedicineForFillter(medicineName,pageNumBer,categoryName));
    }else {
      log("fetchMedicine bug ${respone.statusCode}");
    }
  }

  Future<void> filterByCategoryName() async {
    fetchMedicineForFillter("", 1, "").whenComplete(() async {
      log("filterByCategoryName input check ${widget.iName}");
      log("filterByCategoryName input check  $tottalPage");
      int tmpNum = tottalPage;
      for (var eIName in widget.iName) {
        for (var i = 1; i < tmpNum + 1; i++) {
          fetchMedicineForFillter("", i, "").whenComplete(() async {
            for (var e in sameMedicinesList) {
              for (var x in e['activeIngredients']) {
                if (x['ingredientName'] == eIName['ingredientName']) {
                  medicineListFillted.add(e);
                }
              }
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    filterByCategoryName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controllerList,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Text('Có ${medicineListFillted.length} Thuốc có \nChung hoạt chất',
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(97, 90, 90, 1))),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: Image.asset('assets/picture/wsa.jpg')),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              medicineListFillted.isEmpty
                  ? const Center(child: Text("Không tìm được kết quả"))
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 40,
                      ),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: medicineListFillted.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineDetailScreen(
                                    medicineName: medicineListFillted[index]
                                        ['medicineName'],
                                    rqr: medicineListFillted[index]
                                        ["requirePrescript"],
                                    image: medicineListFillted[index]['image'],
                                    specifName: medicineListFillted[index]
                                        ['specification']['typeName'],
                                    activeIngredients:
                                        medicineListFillted[index]
                                            ['activeIngredients'],
                                    pharmaceuticalCompanies:
                                        medicineListFillted[index]
                                            ['pharmaceuticalCompanies'],
                                    medInbrand: medicineListFillted[index]
                                        ['medicineInBrands'],
                                  ),
                                ));
                          },
                          child: ProductWidget(
                            image: medicineListFillted[index]['image'],
                            medicineName: medicineListFillted[index]
                                ['medicineName'],
                            rqr: medicineListFillted[index]["requirePrescript"],
                          ),
                        );
                      },
                    )
              //list fillter
            ],
          ),
        ),
      ),
    );
  }
}
