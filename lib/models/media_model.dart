import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Media model class
/// Uses ChangeNotifier to update changes to EditProfileView
class MediaModel with ChangeNotifier {
  /// Avatar file object for mobile
  File? newAvatarUrlMobile;

  /// Avatar url for web
  dynamic newAvatarUrlWeb;

  /// Uint8 variable that converts avatar for web to object
  late Future<Uint8List> newAvatarUrlWebData;

  /// Function to show preview avatar on EditProfileView
  void previewNewAvatar(_source) async {
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
