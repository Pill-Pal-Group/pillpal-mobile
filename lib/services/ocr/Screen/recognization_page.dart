import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pillpalmobile/screens/paidhome/autoadd.dart';
import 'package:pillpalmobile/utils/rive_utils.dart';

class RecognizePage extends StatefulWidget {
  final String? path;
  const RecognizePage({Key? key, this.path}) : super(key: key);

  @override
  State<RecognizePage> createState() => _RecognizePageState();
}

class _RecognizePageState extends State<RecognizePage> {
  bool _isBusy = false;
  List<int> _medicineDose = [];
  List<String> _medicineName = [];
  List<int> _medicineTotal = [];
  TextEditingController controller = TextEditingController();

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
                    child:
                        Column(children: [
                          TextFormField(
                          //maxLines: MediaQuery.of(context).size.height.toInt(),
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: "Text goes here..."),
                        ),
                      TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused))
                              return Colors.red;
                            return null; // Defer to the widget's default.
                          }),
                        ),
                        onPressed: () {
                          for (var i = _medicineName.length - 1; i >= 0; i--) {
                            for (var x = i; x < 12;) {
                              if (_medicineDose[x] != 0) {
                                log(_medicineDose[x].toString());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AutoEntryPage(
                                      nameMedicine: _medicineName[i],
                                      lieudung: _medicineDose[x].toString(),
                                      buoi: x - 3,
                                    ),
                                  ),
                                );
                              }
                              x += 3;
                            }
                          }
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

    log(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);

    //controller.text = recognizedText.text;
    //lấy số lượng
    checkSL(recognizedText.blocks);
    //lấy tên thuốc
    checkTen(recognizedText.blocks);
    //lấy liều
    checkTimesang(recognizedText.blocks);
    _medicineDose.add(0);
    _medicineDose.add(0);
    _medicineDose.add(0);
    //checkTimetrua(recognizedText.blocks);
    checkTimechieu(recognizedText.blocks);
    _medicineDose.add(0);
    _medicineDose.add(0);
    _medicineDose.add(0);
    //checkTimetoi(recognizedText.blocks);

    //ket qua
    log(_medicineDose.toString());
    log(_medicineName.toString());
    log(_medicineTotal.toString());

    ///End busy state
    setState(() {
      for (var element in _medicineName) {
        controller.text += element;
      }
      _isBusy = false;
    });
  }

  void checkSL(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("SL:")) {
        List<String> tmp = element.text.split(" ");
        log(tmp[1]);
        _medicineTotal.add(int.parse(tmp[1]));
      }
    }
  }

  void checkTen(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("(") || element.text.contains(")")) {
        log(element.text.replaceAll("\n", " "));
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
          _medicineDose.add(0);
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
          _medicineDose.add(0);
        }
      }
    }
    log("Cai nay buoi Trưa");
    log(_medicineDose.toString());
  }

  void checkTimechieu(List<TextBlock> tmp) {
    for (var element in tmp) {
      if (element.text.contains("Chiều:")) {
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
          _medicineDose.add(0);
        }
      }
    }
    //log("Cai nay buoi Chiều");
    //log(_medicineDose.toString());
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
          log(tmp2);
          addTimeSang(tmp2, "Tối: ");
          log("xxxxx");
        } catch (e) {
          _medicineDose.add(0);
        }
      }
    }
    log("Cai nay buoi tối");
    log(_medicineDose.toString());
  }

  void addTimeSang(String tmp, String template) {
    String stringType = tmp.replaceAll(template, "");
    try {
      int inttmp = int.parse(stringType);
      _medicineDose.add(inttmp);
    } catch (e) {
      _medicineDose.add(0);
    }
  }
}
