import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pillpalmobile/services/ocr/Screen/recognization_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_cropper_page.dart';
import 'package:pillpalmobile/services/ocr/Utils/image_picker_class.dart';
import 'package:pillpalmobile/services/ocr/Widgets/modal_dialog.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.blue.withOpacity(0.04);
                }
                if (states.contains(MaterialState.focused) ||
                    states.contains(MaterialState.pressed)) {
                  return Colors.blue.withOpacity(0.12);
                }
                return null; // Defer to the widget's default.
              },
            ),
          ),
          onPressed: () {
            imagePickerModal(context, onCameraTap: () {
              //log("Camera" as num);
              pickImage(source: ImageSource.camera).then((value) {
                if (value != '') {
                  imageCropperView(value, context).then((value) {
                    if (value != '') {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => RecognizePage(
                            path: value,
                          ),
                        ),
                      );
                    }
                  });
                }
              });
            }, onGalleryTap: () {
              //log("Gallery" as num);
              pickImage(source: ImageSource.gallery).then((value) {
                if (value != '') {
                  imageCropperView(value, context).then((value) {
                    if (value != '') {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => RecognizePage(
                            path: value,
                          ),
                        ),
                      );
                    }
                  });
                }
              });
            });
          },
          child: Text('Bắt đầu Scan')),
    );
  }
}
