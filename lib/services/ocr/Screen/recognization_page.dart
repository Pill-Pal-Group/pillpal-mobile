import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:pillpalmobile/constants.dart';
import 'package:pillpalmobile/model/menu.dart';
import 'package:pillpalmobile/screens/entryPoint/entry_point.dart';
import 'package:pillpalmobile/screens/medicationschedule/mscomponents/inputfeild.dart';
import 'package:pillpalmobile/services/auth/auth_service.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({super.key, this.path});

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  //controler
  ScrollController sController = ScrollController();
  final TextEditingController doctorNameCtrl = TextEditingController();
  final TextEditingController hopitalNameCtrl = TextEditingController();
  late final InputImage inputImage;
  String imageDLL = "";
  bool _isBusy = false;
  final List<double> _medicineDoseS = [];
  final List<double> _medicineDoseTr = [];
  final List<double> _medicineDoseC = [];
  final List<double> _medicineDoseT = [];
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
    DateTime today = DateTime.now();
    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate1 = outputFormat.format(today);
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
        "doctorName": doctorNameCtrl.text,
        "hospitalName": hopitalNameCtrl.text,
        "prescriptDetails": tesrne
      }),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      log(response.statusCode.toString());
      final json = jsonDecode(response.body);
      genMediceneIntake(json['id']);
      log(json.toString());
    } else if (response.statusCode == 401) {
      refreshAccessToken(
              UserInfomation.accessToken, UserInfomation.refreshToken)
          .whenComplete(() => pushMedicineVer2(tesrne, imagelink));
    } else {
      log("pushMedicine bug ${response.body}");
      log("pushMedicine bug ${response.statusCode}");
    }
  }

  void processTheImage(InputImage image) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );

    setState(() {
      _isBusy = true;
    });
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    try {
      //lấy tên thuốc
      checkTen(recognizedText.blocks);
      //laySL
      checkSL(recognizedText.blocks);
      // //lấy sang
      checkTimesang(recognizedText.blocks);
      // //Lấy trưa
      checkTimetrua(recognizedText.blocks);
      // //lấy chiều
      checkTimechieu(recognizedText.blocks);
      // //lấy Tối
      checkTimetoi(recognizedText.blocks);
    } catch (e) {
      Get.snackbar(
        "Ảnh bị lỗi",
        "Vui lòng chụp lại",
        snackPosition: SnackPosition.TOP,
        colorText: const Color.fromARGB(255, 192, 5, 5),
        duration: const Duration(seconds: 5),
        backgroundColor: const Color.fromARGB(255, 151, 151, 151),
      );
      Navigator.of(context).pop();
    }

    //ket qua
    log("Name: ${_medicineName.toString()}");
    log("SL: ${_medicineTotal.toString()}");
    log("S: ${_medicineDoseS.toString()}");
    log("Tr: ${_medicineDoseTr.toString()}");
    log("C: ${_medicineDoseC.toString()}");
    log("T: ${_medicineDoseT.toString()}");

    //End busy state
    setState(() {
      _isBusy = false;
    });
  }

  void checkSL(List<TextBlock> tmp) {
    for (TextBlock block in tmp) {
      for (TextLine line in block.lines) {
        if (line.text.contains("SL:")) {
          //log("checkSL line: ${line.text}");
          try {
            int tws = line.text.indexOf("SL:");
            //log("checkSL tws: ${tws}");
            if (tws > 0) {
              String tmp0 = line.text.substring((tws - 1));
              //log("checkSL tmp0v: $tmp0");
              List<String> tmp = tmp0.removeAllWhitespace.split(":");
              //log("checkSL tmp: ${tmp[1]}");
              int tmpint = int.parse(tmp[1]);
              //log("checkSL tmpint: $tmpint");
              _medicineTotal.add(tmpint);
            } else {
              List<String> tmp = line.text.split(" ");
              //log("checkSL tmp: ${tmp[1]}");
              int tmpint = int.parse(tmp[1]);
              //log("checkSL tmpint: $tmpint");
              _medicineTotal.add(tmpint);
            }
          } catch (e) {
            _medicineTotal.add(0);
          }
        }
      }
    }
  }

  Future<void> checkTen(List<TextBlock> tmp) async {
    for (TextBlock line in tmp) {
      if (line.text.contains("(") &&
          line.text.contains(")") &&
          line.text.contains(",")) {
        List<String> tmp1 = line.text.replaceAll('\n', " ").split(",");
        String tmp2 = tmp1[0].replaceAll("(", "");
        String tmp3 = tmp2.replaceAll(")", "");
        _medicineName.add(tmp3);
      }
    }
  }

  void checkTimesang(List<TextBlock> tmp) {
    for (TextBlock block in tmp) {
      for (TextLine line in block.lines) {
        if (line.text.contains("Sáng:") ||
            line.text.contains("Sang:") ||
            line.text.contains("San:")) {
          log("checkSL line: ${line.text}");
          try {
            int tws = line.text.indexOf("Sáng:");
            String tmp0 = line.text.substring(tws);
            //log("checkSL tmp0v: $tmp0");
            List<String> tmp = tmp0.split(" ");
            //log("checkSL tmp: ${tmp[1]}");
            double tmpint = double.parse(tmp[1]);
            //log("checkSL tmpint: $tmpint");
            if (_medicineDoseS.length <= _medicineName.length) {
              _medicineDoseS.add(tmpint);
            }
          } catch (e) {
            _medicineDoseS.add(0);
          }
        }
      }
    }
    if (_medicineDoseS.length < _medicineName.length) {
      while (_medicineDoseS.length < _medicineName.length) {
        _medicineDoseS.add(0);
      }
    }
  }

  void checkTimetrua(List<TextBlock> tmp) {
    for (TextBlock block in tmp) {
      for (TextLine line in block.lines) {
        if (line.text.contains("Trưa:")) {
          log("checkSL line: ${line.text}");
          try {
            int tws = line.text.indexOf("Trưa:");
            String tmp0 = line.text.substring(tws);
            //log("checkSL tmp0v: $tmp0");
            List<String> tmp = tmp0.split(" ");
            //log("checkSL tmp: ${tmp[1]}");
            double tmpint = double.parse(tmp[1]);
            //log("checkSL tmpint: $tmpint");
            if (_medicineDoseTr.length <= _medicineName.length) {
              _medicineDoseTr.add(tmpint);
            }
          } catch (e) {
            _medicineDoseTr.add(0);
          }
        }
      }
    }
    if (_medicineDoseTr.length < _medicineName.length) {
      while (_medicineDoseTr.length < _medicineName.length) {
        _medicineDoseTr.add(0);
      }
    }
  }

  void checkTimechieu(List<TextBlock> tmp) {
    for (TextBlock block in tmp) {
      for (TextLine line in block.lines) {
        if (line.text.contains("Chiều:")) {
          log("checkSL line: ${line.text}");
          try {
            int tws = line.text.indexOf("Chiều:");
            String tmp0 = line.text.substring(tws);
            //log("checkSL tmp0v: $tmp0");
            List<String> tmp = tmp0.split(" ");
            //log("checkSL tmp: ${tmp[1]}");
            double tmpint = double.parse(tmp[1]);
            //log("checkSL tmpint: $tmpint");
            if (_medicineDoseC.length <= _medicineName.length) {
              _medicineDoseC.add(tmpint);
            }
          } catch (e) {
            _medicineDoseC.add(0);
          }
        }
      }
    }
    if (_medicineDoseC.length < _medicineName.length) {
      while (_medicineDoseC.length < _medicineName.length) {
        _medicineDoseC.add(0);
      }
    }
  }

  void checkTimetoi(List<TextBlock> tmp) {
    for (TextBlock block in tmp) {
      for (TextLine line in block.lines) {
        if (line.text.contains("Tối:")) {
          //log("checkSL line: ${line.text}");
          try {
            int tws = line.text.indexOf("Tối:");
            String tmp0 = line.text.substring(tws);
            //log("checkSL tmp0v: $tmp0");
            List<String> tmp = tmp0.split(" ");
            //log("checkSL tmp: ${tmp[1]}");
            double tmpint = double.parse(tmp[1]);
            //log("checkSL tmpint: $tmpint");
            if (_medicineDoseT.length <= _medicineName.length) {
              _medicineDoseT.add(tmpint);
            }
          } catch (e) {
            _medicineDoseT.add(0);
          }
        }
      }
    }
    if (_medicineDoseT.length < _medicineName.length) {
      while (_medicineDoseT.length < _medicineName.length) {
        _medicineDoseT.add(0);
      }
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
    doctorNameCtrl.text = "Gia kỳ";
    hopitalNameCtrl.text = "Gia Định";
    super.initState();
    log("Scaned check path input: ${widget.path}");
    inputImage = InputImage.fromFilePath(widget.path!);
    processTheImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Kiểm tra lại thông tin")),
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
                                    keyboardType: TextInputType.number,
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
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseS[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseS[index] =
                                          double.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseTr[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseTr[index] =
                                          double.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseC[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseC[index] =
                                          double.parse(value);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    //obscureText: true,
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      labelText:
                                          _medicineDoseT[index].toString(),
                                    ),
                                    onChanged: (value) {
                                      _medicineDoseT[index] =
                                          double.parse(value);
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
                  Row(
                    children: [
                      Expanded(
                        child: MsInputFeild(
                          type: TextInputType.text,
                          tittle: 'Tên Bác sĩ',
                          hint: 'nhập tên Bác sĩ',
                          controller: doctorNameCtrl,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: MsInputFeild(
                          type: TextInputType.text,
                          tittle: 'Tên bệnh viện',
                          hint: 'nhập tên bệnh viện',
                          controller: hopitalNameCtrl,
                        ),
                      ),
                    ],
                  ),
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
                                _medicineDoseTr[i] +
                                _medicineDoseC[i] +
                                _medicineDoseT[i]) >
                            0) {
                          int endday = _medicineTotal[i] ~/
                              (_medicineDoseS[i] +
                                  _medicineDoseTr[i] +
                                  _medicineDoseC[i] +
                                  _medicineDoseT[i]);
                          var outputDate3 = outputFormat
                              .format(nowTime.add(Duration(days: endday)));
                          testList.add(ThePrescriptDetails(
                              medicineName: _medicineName[i],
                              dateStart: outputDate2,
                              dateEnd: outputDate3,
                              totalDose: _medicineTotal[i],
                              morningDose: _medicineDoseS[i],
                              noonDose: _medicineDoseTr[i],
                              afternoonDose: _medicineDoseC[i],
                              nightDose: _medicineDoseT[i],
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
                    child: const Text("Thêm đơn thuốc"),
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
  double morningDose;
  double noonDose;
  double afternoonDose;
  double nightDose;
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
