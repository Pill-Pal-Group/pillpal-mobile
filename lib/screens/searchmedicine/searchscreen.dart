import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/medicenedetail.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/product_widget.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/utils.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final String? medname;
  const SearchScreen({super.key, this.medname});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? searchText;
  List<dynamic> medicines = [];
  List<dynamic> categoryList = [];
  List<dynamic> medicineListFillted = [];

  var categoryChoiseList;
  bool pickCategory = false;
  final TextEditingController _titleCtrl2 = TextEditingController();
  bool isSelected = false;
  int numberOfPage = 0;
  int onPage = 1;
  ScrollController controllerList = ScrollController();
  String test = "2";
  //api call
  void fetchMedicine(String okene, int numBer) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?MedicineName=$okene&Page=$numBer&PageSize=10&IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );

    if (respone.statusCode == 200 || respone.statusCode == 201) {
      setState(() {
        final json = jsonDecode(respone.body);
        numberOfPage = json['totalPages'];
        medicines = json['data'];
      });
    } else {
      log("fetchMedicine bug ${respone.statusCode}");
    }
  }

  void fetchCategory() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/categories?Page=1";
    final uri = Uri.parse(url);
    final respone = await http.get(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer ${UserInfomation.accessToken}',
      },
    );

    if (respone.statusCode == 200 || respone.statusCode == 201) {
      setState(() {
        final json = jsonDecode(respone.body);
        categoryList = json['data'];
      });
      //log(categoryList.toString());
    } else {
      log("fetchCategory bug ${respone.statusCode}");
    }
  }

  void filterByCategoryName(String categoryName) {
    for (var e in medicines) {
      for (var x in e['categories']) {
        if (x['categoryName'] == categoryName) {
          medicineListFillted.add(e);
        }
      }
    }
    setState(() {
      medicines = medicineListFillted;
    });
    //log(medicines.toString());
  }

  @override
  void initState() {
    super.initState();
    _titleCtrl2.text = widget.medname ?? "";
    fetchCategory();
    fetchMedicine(_titleCtrl2.text, 1);
  }

  //api call
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          controller: controllerList,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // lời mở
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "     Hỗ trợ tìm Thuốc\n",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: "     Với ",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: " PillPal",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Thanh search
              Row(
                children: [
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.70,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: boxShadow,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => {
                            //log(_titleCtrl2.text),
                            fetchMedicine(_titleCtrl2.text, 1),
                          },
                          icon: const Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 25,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            autofocus: false,
                            cursorColor: Get.isDarkMode
                                ? Colors.grey[100]
                                : Colors.grey[700],
                            controller: _titleCtrl2,
                            style: subtitlestyle,
                            onChanged: (value) => {
                              //log(value),
                              fetchMedicine(value, 1)
                            },
                            decoration: InputDecoration(
                                hintText: "Nhập tên thuốc?",
                                hintStyle: subtitlestyle,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: context.theme.backgroundColor,
                                        width: 0)),
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: context.theme.backgroundColor,
                                        width: 0))),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  //nut fillter
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kPrimaryColor,
                    ),
                    child: IconButton(
                      onPressed: () => {log("something here add this button line")},
                      icon: const Icon(
                        FontAwesomeIcons.filter,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              medicines.isEmpty
                  ? const Text("khong tim thay")
                  : Column(
                      children: [
                        categoryList.isEmpty
                            ? const Center(child: CupertinoActivityIndicator())
                            : SizedBox(
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryList.length,
                                  padding: const EdgeInsets.only(top: 20.0),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: FilterChip(
                                          label: Text(categoryList[index]
                                              ['categoryName']),
                                          selected: categoryChoiseList ==
                                              (categoryList[index]),
                                          onSelected: (bool selected) {
                                            if (selected) {
                                              setState(() {
                                                categoryChoiseList =
                                                    categoryList[index];
                                                filterByCategoryName(
                                                    categoryList[index]
                                                        ['categoryName']);
                                              });
                                            } else {
                                              setState(() {
                                                categoryChoiseList = null;
                                                fetchMedicine("", 1);
                                                medicineListFillted = [];
                                              });
                                            }
                                          },
                                        ));
                                  },
                                ),
                              ),
                        // product grid view

                        _makeList(),

                        NumberPaginator(
                          numberPages: numberOfPage == 0 ? 1 : numberOfPage,
                          onPageChange: (index) => {
                            setState(() {
                              controllerList.position.moveTo(0);
                              fetchMedicine(_titleCtrl2.text, index + 1);
                            })
                          },
                        )
                      ],
                    )
              //list fillter
            ],
          ),
        ),
      ),
    );
  }

  _makeList() {
    //log(test);
    return medicines.isEmpty
        ? const Center(child: CupertinoActivityIndicator())
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 40,
            ),
            shrinkWrap: true,
            primary: false,
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineDetailScreen(
                          medicineName: medicines[index]['medicineName'],
                          rqr: medicines[index]["requirePrescript"],
                          image: medicines[index]['image'],
                          specifName: medicines[index]['specification']
                              ['typeName'],
                          //specifDetail: medicines[index]['specification']['detail'],
                          activeIngredients: medicines[index]
                              ['activeIngredients'],
                          pharmaceuticalCompanies: medicines[index]
                              ['pharmaceuticalCompanies'],
                          medInbrand: medicines[index]['medicineInBrands'],
                        ),
                      ));
                },
                child: ProductWidget(
                  image: medicines[index]['image'],
                  medicineName: medicines[index]['medicineName'],
                  rqr: medicines[index]["requirePrescript"],
                ),
              );
            },
          );
  }
}
