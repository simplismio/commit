import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaService with ChangeNotifier {
  File? newProfilePhotoUrl;

  previewNewProfilePhoto() async {
    try {
      final XFile? pickedFile = await ImagePicker()
          .pickImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 640);
      newProfilePhotoUrl = File(pickedFile!.path);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
