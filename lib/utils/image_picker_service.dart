import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
    );
  }

  Future<XFile?> pickImageFromCamera() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
    );
  }

  Future<File?> pickAsFileFromGallery() async {
    final xfile = await pickImageFromGallery();
    if (xfile == null) return null;
    return File(xfile.path);
  }

  Future<File?> pickAsFileFromCamera() async {
    final xfile = await pickImageFromCamera();
    if (xfile == null) return null;
    return File(xfile.path);
  }
}
