import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:rukunin/modules/community/models/dues_payment.dart';

class DuesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Submit payment with XFile (works for both web and mobile)
  Future<String?> submitPaymentWithFile({
    required String userId,
    required String userName,
    required String userPhone,
    required String rt,
    required String rw,
    required double amount,
    required String month,
    required int year,
    required XFile receiptFile,
    String? notes,
  }) async {
    try {
      // Upload receipt image
      final String fileName =
          'receipts/${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = _storage.ref(fileName);

      String receiptUrl;

      if (kIsWeb) {
        // For web, use putData with bytes
        final bytes = await receiptFile.readAsBytes();
        final uploadTask = await storageRef.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        receiptUrl = await uploadTask.ref.getDownloadURL();
      } else {
        // For mobile, use putFile
        final file = File(receiptFile.path);
        final uploadTask = await storageRef.putFile(file);
        receiptUrl = await uploadTask.ref.getDownloadURL();
      }

      // Create payment with pending status
      // Verification will be done server-side or by treasurer
      final payment = DuesPayment(
        userId: userId,
        userName: userName,
        userPhone: userPhone,
        rt: rt,
        rw: rw,
        amount: amount,
        month: month,
        year: year,
        receiptImageUrl: receiptUrl,
        status: PaymentStatus.pending,
        createdAt: DateTime.now(),
        isAutoVerified: false,
        verificationScore: null,
      );

      final docRef = await _firestore
          .collection('dues_payments')
          .add(payment.toFirestore());

      return docRef.id;
    } catch (e) {
      print('Error submitting payment: $e');
      return null;
    }
  }

  // Update user payment status
  Future<void> _updateUserPaymentStatus(
    String userId,
    String month,
    int year,
  ) async {
    try {
      await _firestore
          .collection('user_payments')
          .doc('${userId}_${month}_$year')
          .set({
            'userId': userId,
            'month': month,
            'year': year,
            'isPaid': true,
            'paidAt': Timestamp.fromDate(DateTime.now()),
          });
    } catch (e) {
      print('Error updating user payment status: $e');
    }
  }

  // Get user's payment history
  Stream<List<DuesPayment>> getUserPayments(String userId, {int? year}) {
    Query query = _firestore
        .collection('dues_payments')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (year != null) {
      query = query.where('year', isEqualTo: year);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DuesPayment.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Get pending payments for treasurer (filtered by RT)
  Stream<List<DuesPayment>> getPendingPayments({String? rt}) {
    Query query = _firestore
        .collection('dues_payments')
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true);

    if (rt != null && rt != 'Semua') {
      final rtNumber = rt.replaceAll('RT ', '');
      query = query.where('rt', isEqualTo: rtNumber);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return DuesPayment.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
    });
  }

  // Get single payment
  Future<DuesPayment?> getPayment(String paymentId) async {
    try {
      final doc = await _firestore
          .collection('dues_payments')
          .doc(paymentId)
          .get();
      if (doc.exists) {
        return DuesPayment.fromFirestore(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting payment: $e');
      return null;
    }
  }

  // Verify payment manually by treasurer
  Future<bool> verifyPayment(String paymentId, String treasurerId) async {
    try {
      final payment = await getPayment(paymentId);
      if (payment == null) return false;

      await _firestore.collection('dues_payments').doc(paymentId).update({
        'status': PaymentStatus.verified.toString().split('.').last,
        'verifiedAt': Timestamp.fromDate(DateTime.now()),
        'verifiedBy': treasurerId,
      });

      // Update user payment status
      await _updateUserPaymentStatus(
        payment.userId,
        payment.month,
        payment.year,
      );

      return true;
    } catch (e) {
      print('Error verifying payment: $e');
      return false;
    }
  }

  // Reject payment
  Future<bool> rejectPayment(
    String paymentId,
    String treasurerId,
    String reason,
  ) async {
    try {
      await _firestore.collection('dues_payments').doc(paymentId).update({
        'status': PaymentStatus.rejected.toString().split('.').last,
        'verifiedAt': Timestamp.fromDate(DateTime.now()),
        'verifiedBy': treasurerId,
        'rejectionReason': reason,
      });
      return true;
    } catch (e) {
      print('Error rejecting payment: $e');
      return false;
    }
  }

  // Get user's paid months for current year
  Future<List<String>> getUserPaidMonths(String userId, int year) async {
    try {
      final snapshot = await _firestore
          .collection('dues_payments')
          .where('userId', isEqualTo: userId)
          .where('year', isEqualTo: year)
          .where('status', whereIn: ['verified', 'autoVerified'])
          .get();

      return snapshot.docs.map((doc) => doc.data()['month'] as String).toList();
    } catch (e) {
      print('Error getting paid months: $e');
      return [];
    }
  }

  // Get community summary
  Future<Map<String, dynamic>> getCommunitySummary(int year) async {
    try {
      final snapshot = await _firestore
          .collection('dues_payments')
          .where('year', isEqualTo: year)
          .where('status', whereIn: ['verified', 'autoVerified'])
          .get();

      double totalCollected = 0;
      int totalPayments = snapshot.docs.length;

      for (var doc in snapshot.docs) {
        totalCollected += (doc.data()['amount'] ?? 0).toDouble();
      }

      return {'totalCollected': totalCollected, 'totalPayments': totalPayments};
    } catch (e) {
      print('Error getting community summary: $e');
      return {'totalCollected': 0.0, 'totalPayments': 0};
    }
  }
}
