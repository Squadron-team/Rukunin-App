import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';

class MLFirebaseService {
  static Future<Map<String, dynamic>> classifyImage(
    Uint8List imageBytes,
  ) async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('classify_image');

    final imgBase64 = base64Encode(imageBytes);
    final result = await callable.call({'image': imgBase64});

    return Map<String, dynamic>.from(result.data);
  }

  static Future<Map<String, dynamic>> detectFakeReceipt(
    Uint8List imageBytes,
    String expectedAmount,
  ) async {
    final functions = FirebaseFunctions.instance;
    final callable = functions.httpsCallable('detect_fake_receipt');

    final imgBase64 = base64Encode(imageBytes);

    final result = await callable.call({
      'image': imgBase64,
      'expected_fields': {'total_amount': expectedAmount.toLowerCase()},
    });

    return Map<String, dynamic>.from(result.data);
  }
}
