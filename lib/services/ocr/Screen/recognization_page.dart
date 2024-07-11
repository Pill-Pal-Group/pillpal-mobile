import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  final List<int> _medicineDoseS = [];
  final List<int> _medicineDoseT = [];
  final List<int> _medicineDoseC = [];
  final List<int> _medicineDoseTT = [];
  final List<String> _medicineName = [];
  final List<int> _medicineTotal = [];
  String tokene = userInfomation.accessToken;
  TextEditingController controller = TextEditingController();
  DateTime nowTime = DateTime.now();
  List<Map<String, dynamic>> tesrne = [];



  void pushMedicine(String medName, int sang, int trua, int chieu, int toi,
      int totalmed) async {
    int day2 = totalmed ~/ (sang + trua + chieu + toi);
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 =
        outputFormat.format(nowTime.subtract(const Duration(days: 10)));
    var outputDate2 = outputFormat.format(nowTime);
    var outputDate3 = outputFormat.format(nowTime.add(Duration(days: day2)));
    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/prescripts"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "prescriptImage":
            "https://crazydiscostu.wordpress.com/wp-content/uploads/2023/11/history-of-the-rickroll.jpg",
        "receptionDate": outputDate1,
        "doctorName": "Gia kỳ",
        "hospitalName": "Gia Định",
        "prescriptDetails": [
          {
            "medicineName": medName,
            "dateStart": outputDate2,
            "dateEnd": outputDate3,
            "totalDose": totalmed,
            "morningDose": sang,
            "noonDose": trua,
            "afternoonDose": chieu,
            "nightDose": toi,
            "dosageInstruction": "Aftermeal"
          }
        ]
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    genMediceneIntake(json['id']);
    log(json.toString());
  }

  void genMediceneIntake(String pID) async {
    final response = await http.post(
      Uri.parse(
          "https://pp-devtest2.azurewebsites.net/api/medication-intakes/$pID"),
      headers: <String, String>{
        'Authorization': 'Bearer $tokene',
      },
    );
    final json = jsonDecode(response.body);
    log(json.toString());
    log("okene");
  }

  void pushMedicineVer2(List<Map<String, dynamic>> tesrne) async {
    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/prescripts"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "prescriptImage":
            "https://crazydiscostu.wordpress.com/wp-content/uploads/2023/11/history-of-the-rickroll.jpg",
        "receptionDate": "2024-06-09",
        "doctorName": "Gia kỳ",
        "hospitalName": "Gia Định",
        "prescriptDetails": tesrne
      }),
    );
    log(response.statusCode.toString());
    final json = jsonDecode(response.body);
    genMediceneIntake(json['id']);
    log(json.toString());
  }

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.path!);

    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("recognized page")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Container(
                    //padding: const EdgeInsets.all(1),
                    child: Column(children: [
                  TextFormField(
                    maxLines: 20,
                    controller: controller,
                    decoration:
                        const InputDecoration(hintText: "Text goes here..."),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused))
                          return Colors.red;
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () {
                      for (var i = 0; i < _medicineName.length; i++) {
                        // pushMedicine(
                        //     _medicineName[i],
                        //     _medicineDoseS[i],
                        //     _medicineDoseT[i],
                        //     _medicineDoseC[i],
                        //     _medicineDoseTT[i],
                        //     _medicineTotal[i]);
                        //pushMedicineVer2();
                      }
                      //pushMedicineVer2();
                      tesrne = [];
                      for (var e in testList) {
                        tesrne.add(e.toJsonNe());
                      }
                      log("${tesrne.toString()}");
                      pushMedicineVer2(tesrne);

                    },
                    child: Text("bat dau add"),
                  ),
                ])),
              ));
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    setState(() {
      _isBusy = true;
    });

    //log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    //log(recognizedText.text);
    //controller.text = recognizedText.text;
    //lấy số lượng
    checkSL(recognizedText.blocks);
    //lấy tên thuốc
    checkTen(recognizedText.blocks);
    //lấy sang
    checkTimesang(recognizedText.blocks);
    //Lấy trưa
    _medicineDoseT.add(0);
    _medicineDoseT.add(0);
    _medicineDoseT.add(0);
    //checkTimetrua(recognizedText.blocks);
    //lấy chiều
    checkTimechieu(recognizedText.blocks);
    _medicineDoseTT.add(0);
    _medicineDoseTT.add(0);
    _medicineDoseTT.add(0);
    //checkTimetoi(recognizedText.blocks);

    //ket qua
    log("ket qua");
    log(_medicineDoseS.toString());
    log(_medicineDoseT.toString());
    log(_medicineDoseC.toString());
    log(_medicineDoseTT.toString());
    log(_medicineName.toString());
    log(_medicineTotal.toString());

    ///End busy state
    setState(() {
      for (var i = 0; i < _medicineName.length; i++) {
        controller.text += _medicineName[i];
        controller.text += "\n";
        controller.text += _medicineTotal[i].toString();
        controller.text += " Viêng";
        controller.text += "\n";
        controller.text += "Sang: ";
        controller.text += _medicineDoseS[i].toString();
        controller.text += "\n";
        controller.text += "Trua: ";
        controller.text += _medicineDoseT[i].toString();
        controller.text += "\n";
        controller.text += "Chieu: ";
        controller.text += _medicineDoseC[i].toString();
        controller.text += "\n";
        controller.text += "Toi: ";
        controller.text += _medicineDoseTT[i].toString();
        controller.text += "\n";
      }
      _isBusy = false;
    });
  }

  void checkSL(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("SL:")) {
        List<String> tmp = element.text.split(" ");
        //log(tmp[1]);
        _medicineTotal.add(int.parse(tmp[1]));
      }
    }
  }

  void checkTen(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("(") || element.text.contains(")")) {
        //log(element.text.replaceAll("\n", " "));
        List<String> tmp3 = element.text.replaceAll("\n", " ").split(",");
        _medicineName.add(tmp3[0]);
      }
    }
  }

  void checkTimesang(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("Sáng:")) {
        String tmp = element.text.replaceAll("\n", " ");
        //log("xxxxx");
        String tmp2 = "";
        try {
          for (var i = tmp.indexOf("Sáng:");
              i < tmp.indexOf("Sáng:") + 7;
              i++) {
            tmp2 += tmp[i];
          }
          //log(tmp2);
          addTimeSang(tmp2, "Sáng: ");
          //log("xxxxx");
        } catch (e) {
          _medicineDoseS.add(0);
        }
      }
    }
    //log("Cai nay buoi sang");
    //log(_medicineDose.toString());
  }

  void checkTimetrua(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("Trưa:")) {
        String tmp = element.text.replaceAll("\n", " ");
        //log("xxxxx");
        String tmp2 = "";
        try {
          for (var i = tmp.indexOf("Trưa:");
              i < tmp.indexOf("Trưa:") + 7;
              i++) {
            tmp2 += tmp[i];
          }
          //log(tmp2);
          addTimeSang(tmp2, "Trưa: ");
          //log("xxxxx");
        } catch (e) {
          _medicineDoseT.add(0);
        }
      }
    }
  }

  void checkTimechieu(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("Chiều:")) {
        log(element.toString());
        String tmp = element.text.replaceAll("\n", " ");
        String tmp2 = "";
        try {
          for (var i = tmp.indexOf("Chiều:");
              i < tmp.indexOf("Chiều:") + 8;
              i++) {
            tmp2 += tmp[i];
          }

          addTimeSang(tmp2, "Chiều: ");
        } catch (e) {
          _medicineDoseC.add(0);
        }
      }
    }
  }

  void checkTimetoi(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("Tối:")) {
        String tmp = element.text.replaceAll("\n", " ");
        log("EEEEEE");
        String tmp2 = "";
        try {
          for (var i = tmp.indexOf("Tối:"); i < tmp.indexOf("Tối:") + 8; i++) {
            tmp2 += tmp[i];
          }
          addTimeSang(tmp2, "Tối: ");
        } catch (e) {
          _medicineDoseTT.add(0);
        }
      }
    }
  }

  void addTimeSang(String tmp, String template) {
    String stringType = tmp.replaceAll(template, "");
    int inttmp = int.parse(stringType);
    if (template == "Sáng: ") {
      _medicineDoseS.add(inttmp);
    }
    if (template == "Trưa: ") {
      _medicineDoseT.add(inttmp);
    }
    if (template == "Chiều: ") {
      _medicineDoseC.add(inttmp);
    }
    if (template == "Tối: ") {
      _medicineDoseTT.add(inttmp);
    }
  }
}

class ThePrescriptDetails {
  String medicineName;
  String dateStart;
  String dateEnd;
  int totalDose;
  int morningDose;
  int noonDose;
  int afternoonDose;
  int nightDose;
  String dosageInstruction;

  ThePrescriptDetails(
      {required this.medicineName,
      required this.dateStart,
      required this.dateEnd,
      required this.totalDose,
      required this.morningDose,
      required this.noonDose,
      required this.afternoonDose,
      required this.nightDose,
      required this.dosageInstruction});

  Map<String, dynamic> toJsonNe() => {
        'medicineName': medicineName,
        'dateStart': dateStart,
        'dateEnd': dateEnd,
        'totalDose': totalDose,
        'morningDose': morningDose,
        'noonDose': noonDose,
        'afternoonDose': afternoonDose,
        'nightDose': nightDose,
        'dosageInstruction': dosageInstruction,
      };
}

List<ThePrescriptDetails> testList = [
  ThePrescriptDetails(
      medicineName: "test1",
      dateStart: "2024-07-09",
      dateEnd: "2024-07-10",
      totalDose: 4,
      morningDose: 1,
      noonDose: 0,
      afternoonDose: 1,
      nightDose: 0,
      dosageInstruction: "Aftermeal"),
  ThePrescriptDetails(
      medicineName: "test2",
      dateStart: "2024-07-09",
      dateEnd: "2024-07-10",
      totalDose: 4,
      morningDose: 0,
      noonDose: 1,
      afternoonDose: 0,
      nightDose: 1,
      dosageInstruction: "Aftermeal"),
];
