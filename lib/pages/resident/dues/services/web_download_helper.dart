import 'dart:typed_data';

// Conditional import for web
import 'web_download_stub.dart'
    if (dart.library.html) 'web_download_web.dart';

Future<String?> downloadFileWeb(Uint8List bytes, String filename, String mimeType) async {
  return downloadFile(bytes, filename, mimeType);
}
