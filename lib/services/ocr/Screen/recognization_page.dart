import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/model/menu.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({super.key, this.path});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  //controler
  ScrollController sController = ScrollController();
  late final InputImage inputImage;
  String imageDLL = "";
  bool _isBusy = false;
  final List<int> _medicineDoseS = [];
  final List<int> _medicineDoseT = [];
  final List<int> _medicineDoseC = [];
  final List<int> _medicineDoseTT = [];
  final List<String> _medicineName = [];
  final List<int> _medicineTotal = [];
  String tokene = UserInfomation.accessToken;
  TextEditingController controller = TextEditingController();
  DateTime nowTime = DateTime.now();
  var outputFormat = DateFormat('yyyy-MM-dd');
  List<Map<String, dynamic>> tesrne = [];
  List<ThePrescriptDetails> testList = [];
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void genMediceneIntake(String pID) async {
    final response = await http.post(
      Uri.parse(
          "https://pp-devtest2.azurewebsites.net/api/medication-intakes/prescripts/$pID"),
      headers: <String, String>{
        'Authorization': 'Bearer $tokene',
      },
    );
    final json = jsonDecode(response.body);
    log(json.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryPoint(
          selectpage: bottomNavItems.first,
        ),
      ),
    );
    log("okene");
  }

  void pushMedicineVer2(
      List<Map<String, dynamic>> tesrne, String imagelink) async {
    var outputDate1 =
        outputFormat.format(nowTime.subtract(const Duration(days: 10)));
    final response = await http.post(
      Uri.parse("https://pp-devtest2.azurewebsites.net/api/prescripts"),
      headers: <String, String>{
        'accept': 'application/json',
        'Authorization': 'Bearer $tokene',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String, dynamic>{
        "prescriptImage": imagelink,
        "receptionDate": outputDate1,
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

  Future<void> uploads(String? imageName) async {
    final tmppath = 'Prescripts/$imageName';
    final file = File(widget.path!);
    final ref = FirebaseStorage.instance.ref().child(tmppath);
    UploadTask? ult = ref.putFile(file);

    final sanpshot = await ult.whenComplete(() {});
    final url = await sanpshot.ref.getDownloadURL();
    setState(() {
      log("datacheck $url");
      imageDLL = url;
    });
  }

  @override
  void initState() {
    super.initState();
    inputImage = InputImage.fromFilePath(widget.path!);
    processImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Kết quả")),
        body: _isBusy == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                      child: SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _medicineName.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                                child: Text("Thuốc ${_medicineName[index]}")),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText: _medicineName[index],
                                    ),
                                    onChanged: (value) {
                                      _medicineName[index] = value;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineTotal[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineTotal[index] = int.parse(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseS[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseS[index] = int.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseT[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseT[index] = int.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseC[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseC[index] = int.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseTT[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseTT[index] = int.parse(value);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  )),
                  const SizedBox(width: 5),
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.focused)) {
                          return Colors.red;
                        }
                        return null; // Defer to the widget's default.
                      }),
                    ),
                    onPressed: () {
                      var outputDate2 = outputFormat.format(nowTime);
                      for (var i = 0; i < _medicineName.length; i++) {
                        if ((_medicineDoseS[i] +
                                _medicineDoseT[i] +
                                _medicineDoseC[i] +
                                _medicineDoseTT[i]) >
                            0) {
                          int endday = _medicineTotal[i] ~/
                              (_medicineDoseS[i] +
                                  _medicineDoseT[i] +
                                  _medicineDoseC[i] +
                                  _medicineDoseTT[i]);
                          var outputDate3 = outputFormat
                              .format(nowTime.add(Duration(days: endday)));
                          testList.add(ThePrescriptDetails(
                              medicineName: _medicineName[i],
                              dateStart: outputDate2,
                              dateEnd: outputDate3,
                              totalDose: _medicineTotal[i],
                              morningDose: _medicineDoseS[i],
                              noonDose: _medicineDoseT[i],
                              afternoonDose: _medicineDoseC[i],
                              nightDose: _medicineDoseTT[i],
                              dosageInstruction: "Aftermeal"));
                        }
                      }
                      tesrne = [];
                      for (var e in testList) {
                        tesrne.add(e.toJsonNe());
                      }
                      log("datacheck ${tesrne.toString()}");
                      uploads(widget.path!).whenComplete(() {
                        pushMedicineVer2(tesrne, imageDLL);
                      });
                    },
                    child: const Text("Bắt đầu thêm đơn thuốc"),
                  ),
                ],
              ));
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
