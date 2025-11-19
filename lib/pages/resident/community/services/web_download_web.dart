import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'dart:typed_data';

Future<String?> downloadFile(Uint8List bytes, String filename, String mimeType) async {
  // Create Blob
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));

  // Create Object URL
  final url = web.URL.createObjectURL(blob);

  // Create an <a> element
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = filename;

  // Trigger download
  anchor.click();

  // Cleanup
  web.URL.revokeObjectURL(url);

  return filename;
}
