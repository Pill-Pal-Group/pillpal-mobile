import 'dart:developer';
import 'package:image_picker/image_picker.dart';

Future<(String,String?)> pickImage({ImageSource? source}) async {
  final picker = ImagePicker();
  String path = '';
  String? imageName = '';
  try {
    final getImage = await picker.pickImage(source: source!);
    imageName = getImage?.name.toString();
    if (getImage != null) {
      path = getImage.path;
    } else {
      path = '';
    }
  } catch (e) {
    log(e.toString());
  }

  return (path,imageName);
}
