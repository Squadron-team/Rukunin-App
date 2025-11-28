import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DocumentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new document request
  Future<String> createDocumentRequest({
    required String documentType,
    required String documentTitle,
    required String purpose,
    required String notes,
    required List<String> attachmentUrls,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      // Create document request
      final docRef = await _firestore.collection('document_requests').add({
        'userId': user.uid,
        'userName': userData?['name'] ?? '',
        'userNik': userData?['nik'] ?? '',
        'userPhone': userData?['phone'] ?? '',
        'userAddress': userData?['address'] ?? '',
        'userRt': userData?['rt'] ?? '',
        'userRw': userData?['rw'] ?? '',
        'documentType': documentType,
        'documentTitle': documentTitle,
        'purpose': purpose,
        'notes': notes,
        'attachmentUrls': attachmentUrls,
        'attachmentCount': attachmentUrls.length,
        'status': 'pending', // pending, processing, approved, rejected, completed
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'processedAt': null,
        'processedBy': null,
        'adminNotes': '',
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create document request: $e');
    }
  }

  // Get all document requests for current user
  Stream<QuerySnapshot> getUserDocumentRequests() {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    return _firestore
        .collection('document_requests')
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Get single document request by ID
  Future<DocumentSnapshot> getDocumentRequest(String requestId) async {
    try {
      return await _firestore
          .collection('document_requests')
          .doc(requestId)
          .get();
    } catch (e) {
      throw Exception('Failed to get document request: $e');
    }
  }

  // Update document request status (admin function)
  Future<void> updateDocumentStatus({
    required String requestId,
    required String status,
    String? adminNotes,
    String? processedBy,
  }) async {
    try {
      final updates = {
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (adminNotes != null) {
        updates['adminNotes'] = adminNotes;
      }

      if (processedBy != null) {
        updates['processedBy'] = processedBy;
        updates['processedAt'] = FieldValue.serverTimestamp();
      }

      await _firestore
          .collection('document_requests')
          .doc(requestId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update document status: $e');
    }
  }

  // Cancel document request
  Future<void> cancelDocumentRequest(String requestId) async {
    try {
      await _firestore
          .collection('document_requests')
          .doc(requestId)
          .update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel document request: $e');
    }
  }

  // Get document statistics for user
  Future<Map<String, int>> getUserDocumentStatistics() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('document_requests')
          .where('userId', isEqualTo: user.uid)
          .get();

      final stats = {
        'total': 0,
        'pending': 0,
        'processing': 0,
        'approved': 0,
        'rejected': 0,
        'completed': 0,
        'cancelled': 0,
      };

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] as String? ?? 'pending';
        stats['total'] = (stats['total'] ?? 0) + 1;
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      throw Exception('Failed to get document statistics: $e');
    }
  }
}
