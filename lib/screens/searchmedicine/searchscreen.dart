import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/medicenedetail.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/product_widget.dart';
import 'package:pillpalmobile/screens/searchmedicine/smcomponents/utils.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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

  //api call
  void fetchMedicine(String okene) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?MedicineName=$okene&IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    final body = respone.body;
    final json = jsonDecode(body);
    log(medicines.toString());
    medicines = json;
  }

  void fetchCategory() async {
    String url = "https://pp-devtest2.azurewebsites.net/api/categories";
    final uri = Uri.parse(url);
    final respone = await http.get(uri);
    final body = respone.body;
    final json = jsonDecode(body);
    setState(() {
      categoryList = json;
    });
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
  }

  @override
  void initState() {
    super.initState();
    fetchCategory();
    fetchMedicine(_titleCtrl2.text);
  }

  //api call
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                            log(_titleCtrl2.text),
                            fetchMedicine(_titleCtrl2.text),
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
                            onChanged: (value) =>
                                {log(value), fetchMedicine(value)},
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
                      onPressed: () => {
                        // showModalBottomSheet<void>(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     return const FilterChipExample();
                        //   },
                        // )
                      },
                      icon: const Icon(
                        FontAwesomeIcons.filter,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              //list fillter
              SizedBox(
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
                          label: Text(categoryList[index]['categoryName']),
                          selected: categoryChoiseList == (categoryList[index]),
                          onSelected: (bool selected) {
                            if (selected) {
                              setState(() {
                                categoryChoiseList = categoryList[index];
                                filterByCategoryName(
                                    categoryList[index]['categoryName']);
                              });
                            } else {
                              setState(() {
                                categoryChoiseList = null;
                                fetchMedicine("");
                                medicineListFillted = [];
                              });
                            }
                          },
                        ));
                  },
                ),
              ),
              // product grid view
              _makeList()
            ],
          ),
        ),
      ),
    );
  }

  _makeList() {
    return GridView.builder(
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
                    specifName: medicines[index]['specification']['typeName'],
                    specifDetail: medicines[index]['specification']['detail'],
                    activeIngredients: medicines[index]['activeIngredients'],
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
