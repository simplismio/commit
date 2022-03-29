import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaService with ChangeNotifier {
  static displayPickImageDialog() async {
    try {
      final XFile? pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      print(pickedFile);
    } catch (e) {}
  }
}
