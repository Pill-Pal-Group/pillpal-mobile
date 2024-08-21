import 'dart:convert';
import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/medicenedetail.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/product_widget.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class SameMediceneScreen extends StatefulWidget {
  final List<dynamic> iName;
  final int totalmedicineatsm;
  const SameMediceneScreen(
      {super.key, required this.iName, required this.totalmedicineatsm});

  @override
  State<SameMediceneScreen> createState() => _SameMediceneScreenState();
}

class _SameMediceneScreenState extends State<SameMediceneScreen> {
  ScrollController controllerList = ScrollController();
  List<dynamic> sameMedicinesList = [];
  List<dynamic> printList = [];
  List<dynamic> medicineListFillted = [];
  int tottalPage = 0;
  int totalmedicine = 0;

  Future<void> fetchMedicinetotal() async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?Page=1&PageSize=5&IncludeCategories=false&IncludeSpecifications=false&IncludePharmaceuticalCompanies=false&IncludeDosageForms=false&IncludeActiveIngredients=false&IncludeBrands=false";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      log("filterByCategoryName Sussecc ${respone.statusCode}");
      setState(() {
        final json = jsonDecode(respone.body);
        totalmedicine = json['totalCount'];
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchMedicinetotal());
    } else {
      log("fetchMedicinetotal bug ${respone.statusCode}");
      log("fetchMedicinetotal bug ${respone.body}");
    }
  }

  Future<void> fetchMedicinetotalPage(int total) async {
    int tmp = total ~/ 2;
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?Page=1&PageSize=$tmp&IncludeCategories=false&IncludeSpecifications=false&IncludePharmaceuticalCompanies=false&IncludeDosageForms=false&IncludeActiveIngredients=false&IncludeBrands=false";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      log("filterByCategoryName Sussecc ${respone.statusCode}");
      setState(() {
        final json = jsonDecode(respone.body);
        tottalPage = json['totalPages'];
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => fetchMedicinetotalPage(total));
    } else {
      log("fetchMedicinetotalPage bug ${respone.statusCode}");
      log("fetchMedicinetotalPage bug ${respone.body}");
    }
  }

  Future<void> fetchMedicineForFillter(
      int pageNumBer, int totalmedicineFF) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?Page=$pageNumBer&PageSize=$totalmedicineFF&IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    if (respone.statusCode == 200 || respone.statusCode == 201) {
      log("filterByCategoryName Sussecc ${respone.statusCode}");
      setState(() {
        final json = jsonDecode(respone.body);
        sameMedicinesList = json['data'];
      });
    } else if (respone.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(
              () => fetchMedicineForFillter(pageNumBer, totalmedicineFF));
    } else {
      log("filterByCategoryName bug ${respone.statusCode}");
      log("filterByCategoryName bug ${respone.body}");
    }
  }

  void filterByCategoryName() async {
    bool check = false;
    log("filterByCategoryName input iName ${widget.iName}");
    log("filterByCategoryName input tottalPage  $tottalPage");
    log("filterByCategoryName input totalmedicine  $totalmedicine");
    log("filterByCategoryName input sameMedicinesList.length ${sameMedicinesList.length}");
    int tmpNum = tottalPage;
    for (var i = 1; i < tmpNum + 1; i++) {
      fetchMedicineForFillter(i, totalmedicine).whenComplete(() async {
        for (var e in sameMedicinesList) {
          List<dynamic> tmpcount = e['activeIngredients'];
          if (tmpcount.length == widget.iName.length) {
            for (var x in tmpcount) {
              for (var eIName in widget.iName) {
                if (x['ingredientName'] == eIName['ingredientName']) {
                  check = true;
                  break;
                } else {
                  check = false;
                  break;
                }
              }
            }
            if (check) {
              setState(() {
                medicineListFillted.add(e);
              });
            }
          }
        }
      });
    }
  }

  String name() {
    String tmp = "";
    for (var element in widget.iName) {
      tmp += element['ingredientName'];
      tmp += ", ";
    }
    return tmp;
  }

  @override
  void initState() {
    super.initState();
    fetchMedicinetotal().whenComplete(() {
      fetchMedicinetotalPage(totalmedicine).whenComplete(() {
        filterByCategoryName();
      });
    });
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
                      child: Text(
                          'Có ${medicineListFillted.length} Thuốc có \nChung hoạt chất ${name()}',
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
                                    totalmedicine: widget.totalmedicineatsm,
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
