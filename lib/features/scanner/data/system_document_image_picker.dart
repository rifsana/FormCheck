import 'package:image_picker/image_picker.dart';

import '../domain/document_image_picker.dart';

/// Concrete implementation of [DocumentImagePicker] using image_picker.
class SystemDocumentImagePicker implements DocumentImagePicker {
  final ImagePicker _picker;

  SystemDocumentImagePicker({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  @override
  Future<String?> pickDocumentImage() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    return xFile?.path;
  }
}
