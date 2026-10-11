/// Abstract contract for selecting a document image from device storage.
abstract class DocumentImagePicker {
  /// Prompts the user to pick a document image.
  ///
  /// Returns the local file path of the picked image, or `null` if cancelled.
  Future<String?> pickDocumentImage();
}
