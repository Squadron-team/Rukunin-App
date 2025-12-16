import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart' as http;

class MLFirebaseService {
  static final _functions = FirebaseFunctions.instance;

  static Future<Map<String, dynamic>> classifyImage(
    Uint8List imageBytes,
  ) async {
    final imgBase64 = base64Encode(imageBytes);
    final result = await _functions.httpsCallable('classify_image').call({
      'image': imgBase64,
    });

    return Map<String, dynamic>.from(result.data);
  }

  static Future<Map<String, dynamic>> detectFakeReceipt(
    Uint8List imageBytes,
    String expectedAmount,
  ) async {
    try {
      const functionUrl = 'https://detect-fake-receipt-g73ghhxyqa-uc.a.run.app';

      final request = http.MultipartRequest('POST', Uri.parse(functionUrl));

      // Add image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'receipt.jpg',
        ),
      );

      // Add expected amount
      request.fields['expected_amount'] = expectedAmount;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, ...data};
      } else {
        return {
          'success': false,
          'error': 'HTTP ${response.statusCode}: ${response.body}',
        };
      }
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
