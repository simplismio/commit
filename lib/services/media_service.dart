import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class MediaService with ChangeNotifier {
  File? newAvatarUrl;

  previewNewProfilePhoto(_source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
          source:
              _source == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640);
      newAvatarUrl = File(pickedFile!.path);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
