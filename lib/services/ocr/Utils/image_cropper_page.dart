import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

Future<String> imageCropperView(String? path, BuildContext context) async {
  try {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Chọn vùng thông tin đơn thuốc',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Chọn vùng thông tin đơn thuốc',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );

    if (croppedFile != null) {
      log("Image cropped");
      return croppedFile.path;
    } else {
      log("Do nothing");
      return '';
    }
  } catch (e) {
    Get.snackbar(
      "Có vấn đề xảy ra",
      "Vui lòng thử lại",
      snackPosition: SnackPosition.TOP,
      colorText: const Color.fromARGB(255, 192, 5, 5),
      duration: const Duration(seconds: 5),
      backgroundColor: const Color.fromARGB(255, 151, 151, 151),
    );
    log("Ảnh bị lỗi");
    return '';
  }
}
