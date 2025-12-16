import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:rukunin/firebase_options.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  group('Firebase Functions - classify_image_callable', () {
    testWidgets(
      'should successfully call classify_image_callable and get prediction',
      (WidgetTester tester) async {
        final functions = FirebaseFunctions.instance;
        final callable = functions.httpsCallable('classify_image');

        // Load test image from assets
        final bytes = await rootBundle.load('assets/ml_test/img_0.png');
        final imgBase64 = base64Encode(bytes.buffer.asUint8List());

        // Act
        final result = await callable.call({'image': imgBase64});

        final data = result.data;

        // Assert
        expect(data, isNotNull);
        expect(data, isA<Map<String, dynamic>>());
        expect(
          data['success'],
          isTrue,
          reason: 'Function should return success',
        );
        expect(data['prediction'], isNotNull);
        expect(data['confidence'], isNotNull);
        expect(data['probabilities'], isA<List>());
      },
    );

    testWidgets('should return error when image is missing', (
      WidgetTester tester,
    ) async {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('classify_image_callable');

      final result = await callable.call({});

      expect(result.data['success'], isFalse);
      expect(result.data['error'], isNotNull);
    });
  });

  group('Firebase Functions - calc_callable', () {
    testWidgets('should calculate correctly', (WidgetTester tester) async {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('calc');

      final result = await callable.call({'a': 5, 'b': 3, 'op': 'add'});

      final data = result.data;

      expect(data, isNotNull);
      expect(data['result'], equals(8));
    });

    testWidgets('should return error for invalid op', (
      WidgetTester tester,
    ) async {
      final functions = FirebaseFunctions.instance;
      final callable = functions.httpsCallable('calc_callable');

      final result = await callable.call({'a': 5, 'b': 3, 'op': 'UNKNOWN'});

      expect(result.data['error'], isNotNull);
    });
  });

  group('Firebase Functions - verify_receipt', () {
    late HttpsCallable callable;

    setUp(() {
      callable = FirebaseFunctions.instance.httpsCallable('verify_receipt');
    });

    testWidgets('should successfully verify a receipt', (tester) async {
      // Load a real test image from assets
      final bytes = await rootBundle.load('assets/ml_test/img_0.png');
      final imgBase64 = base64Encode(bytes.buffer.asUint8List());

      final result = await callable.call({
        'image': imgBase64,
        'expected_amount': '25000', // optional
      });

      final data = result.data;
      expect(data, isNotNull);
      expect(data['success'], isTrue);

      expect(data['final_verdict'], isA<bool>());
      expect(data['knn_pass'], isA<bool>());
      expect(data['logistic_pass'], isA<bool>());
      expect(data['is_fake'], isA<bool>());
      expect(data['confidence'], isA<num>());
      expect(data['detected_lines'], isA<num>());

      // optional extra fields
      if (data.containsKey('line_validation')) {
        expect(data['line_validation'], isA<Map>());
      }
      if (data.containsKey('layout_validation')) {
        expect(data['layout_validation'], isA<Map>());
      }
    });

    testWidgets('should return error when image is missing', (tester) async {
      final result = await callable.call({});

      expect(result.data['success'], isFalse);
      expect(result.data['error'], isNotNull);
    });

    testWidgets('should return error for invalid base64', (tester) async {
      final result = await callable.call({'image': 'NOT_A_BASE64_STRING'});

      expect(result.data['success'], isFalse);
      expect(result.data['error'], isNotNull);
    });

    testWidgets('should accept expected_amount and respond', (tester) async {
      final bytes = await rootBundle.load('assets/ml_test/img_0.png');
      final imgBase64 = base64Encode(bytes.buffer.asUint8List());

      final result = await callable.call({
        'image': imgBase64,
        'expected_amount': '12345',
      });

      final data = result.data;

      expect(data['success'], isTrue);
      expect(data['final_verdict'], isNotNull);
    });
  });
}
