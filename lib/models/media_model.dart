import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class MediaModel with ChangeNotifier {
  File? newAvatarUrlMobile;
  dynamic newAvatarUrlWeb;
  late Future<Uint8List> newAvatarUrlWebData;

  previewNewAvatar(_source) async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
          source:
              _source == 'camera' ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640);
      newAvatarUrlMobile = File(pickedFile!.path);
      newAvatarUrlWeb = pickedFile.path;
      newAvatarUrlWebData = pickedFile.readAsBytes();

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
