import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<String?> downloadFile(Uint8List bytes, String filename, String mimeType) async {
  try {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(bytes);
    
    // Share the file (Android will show save/share options)
    await Share.shareXFiles([XFile(file.path)], text: filename);
    
    return filename;
  } catch (e) {
    return null;
  }
}
