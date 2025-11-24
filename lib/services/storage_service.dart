import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload document attachment
  Future<String> uploadDocumentAttachment({
    required XFile file,
    required String documentType,
    required String requestId,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Read file bytes
      final bytes = await file.readAsBytes();
      final fileName = path.basename(file.name);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final storagePath = 'document_attachments/${user.uid}/$documentType/$requestId/${timestamp}_$fileName';

      // Create reference
      final ref = _storage.ref().child(storagePath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(fileName),
        customMetadata: {
          'userId': user.uid,
          'documentType': documentType,
          'requestId': requestId,
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file
      final uploadTask = ref.putData(bytes, metadata);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload attachment: $e');
    }
  }

  // Upload multiple attachments
  Future<List<String>> uploadMultipleAttachments({
    required List<XFile> files,
    required String documentType,
    required String requestId,
    Function(int current, int total)? onProgress,
  }) async {
    final List<String> downloadUrls = [];

    for (int i = 0; i < files.length; i++) {
      try {
        final url = await uploadDocumentAttachment(
          file: files[i],
          documentType: documentType,
          requestId: requestId,
        );
        downloadUrls.add(url);

        if (onProgress != null) {
          onProgress(i + 1, files.length);
        }
      } catch (e) {
        throw Exception('Failed to upload file ${i + 1}: $e');
      }
    }

    return downloadUrls;
  }

  // Delete document attachment
  Future<void> deleteDocumentAttachment(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete attachment: $e');
    }
  }

  // Delete multiple attachments
  Future<void> deleteMultipleAttachments(List<String> downloadUrls) async {
    for (final url in downloadUrls) {
      try {
        await deleteDocumentAttachment(url);
      } catch (e) {
        // Continue deleting other files even if one fails
        continue;
      }
    }
  }

  // Get file size from URL
  Future<int> getFileSize(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      final metadata = await ref.getMetadata();
      return metadata.size ?? 0;
    } catch (e) {
      throw Exception('Failed to get file size: $e');
    }
  }

  // Helper: Get content type from file extension
  String _getContentType(String fileName) {
    final extension = path.extension(fileName).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  // Helper: Validate file size (max 5MB by default)
  bool validateFileSize(Uint8List bytes, {int maxSizeInMB = 5}) {
    final maxSizeInBytes = maxSizeInMB * 1024 * 1024;
    return bytes.length <= maxSizeInBytes;
  }

  // Helper: Validate file type
  bool validateFileType(String fileName, {List<String>? allowedExtensions}) {
    final defaultExtensions = ['.jpg', '.jpeg', '.png', '.pdf'];
    final extensions = allowedExtensions ?? defaultExtensions;
    final extension = path.extension(fileName).toLowerCase();
    return extensions.contains(extension);
  }
}
