import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pillpalmobile/constants.dart';

class SameMediceneScreen extends StatefulWidget {
  final String iName;
  const SameMediceneScreen({super.key, required this.iName});

  @override
  State<SameMediceneScreen> createState() => _SameMediceneScreenState();
}

class _SameMediceneScreenState extends State<SameMediceneScreen> {
  List<dynamic> medicines = [];
  List<dynamic> medicineListFillted = [];
  int checkbreak = 0;
  bool stop = true;
  void fetchMedicine(String okene, int numBer) async {
    String url =
        "https://pp-devtest2.azurewebsites.net/api/medicines?MedicineName=$okene&Page=$numBer&&IncludeCategories=true&IncludeSpecifications=true&IncludePharmaceuticalCompanies=true&IncludeDosageForms=true&IncludeActiveIngredients=true&IncludeBrands=true";
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
        checkbreak = json['page'];
        medicines = json['data'];
        log("danh sach ${json['page'].toString()}");
      });
    } else {
      log("fetchMedicine bug ${respone.statusCode}");
    }
  }

  void filterByCategoryName() {
    log("truyen qua r ne ${widget.iName}");
    int i = 1;
    while (stop) {
      fetchMedicine("", i);
      for (var e in medicines) {
        for (var x in e['activeIngredients']) {
          log("ten ne ${x['ingredientName']}");
          if (x['ingredientName'] == widget.iName) {
            medicineListFillted.add(e);
          }
        }
      }
      log("fillter xong 1 ${checkbreak}");
      log("fillter xong 2 ${i}");
      if (checkbreak < i) {
        setState(() {
          log("fillter xong ${widget.iName}");
          stop = false;
        });
      }
      i++;
    }

    setState(() {
      medicines = medicineListFillted;
    });
    log(medicines.toString());
  }

  @override
  void initState() {
    super.initState();
    filterByCategoryName();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
