import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/modules/activities/models/activity.dart';

class ActivityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'activities';

  // Get all activities
  Stream<List<Activity>> getEvents() {
    return _firestore
        .collection(_collectionName)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Activity.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Get activities for a specific date
  Future<List<Activity>> getEventsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _firestore
          .collection(_collectionName)
          .where(
            'dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
          )
          .where('dateTime', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('dateTime')
          .get();

      return snapshot.docs
          .map((doc) => Activity.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching activities by date: $e');
      return [];
    }
  }

  // Get single activity by ID
  Stream<Activity?> getEventById(String eventId) {
    return _firestore.collection(_collectionName).doc(eventId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return Activity.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  // Create new activity
  Future<String?> createEvent(Activity event) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(event.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating activity: $e');
      return null;
    }
  }

  // Update activity
  Future<bool> updateEvent(String eventId, Activity event) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .update(event.toMap());
      return true;
    } catch (e) {
      print('Error updating activity: $e');
      return false;
    }
  }

  // Delete activity
  Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).delete();
      return true;
    } catch (e) {
      print('Error deleting activity: $e');
      return false;
    }
  }

  // Join activity (add user to participants)
  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
      return true;
    } catch (e) {
      print('Error joining activity: $e');
      return false;
    }
  }

  // Leave activity (remove user from participants)
  Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).update({
        'participants': FieldValue.arrayRemove([userId]),
      });
      return true;
    } catch (e) {
      print('Error leaving activity: $e');
      return false;
    }
  }

  // Check if user has joined activity
  Future<bool> hasUserJoined(String eventId, String userId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .get();

      if (doc.exists) {
        final participants = List<String>.from(
          doc.data()?['participants'] ?? [],
        );
        return participants.contains(userId);
      }
      return false;
    } catch (e) {
      print('Error checking user participation: $e');
      return false;
    }
  }

  // Get participant count
  Future<int> getParticipantCount(String eventId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .get();

      if (doc.exists) {
        final participants = List<String>.from(
          doc.data()?['participants'] ?? [],
        );
        return participants.length;
      }
      return 0;
    } catch (e) {
      print('Error getting participant count: $e');
      return 0;
    }
  }

  // Get activities by category
  Stream<List<Activity>> getEventsByCategory(String category) {
    return _firestore
        .collection(_collectionName)
        .where('category', isEqualTo: category)
        .orderBy('dateTime', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Activity.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Get upcoming activities
  Stream<List<Activity>> getUpcomingEvents() {
    final now = DateTime.now();
    return _firestore
        .collection(_collectionName)
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
        .orderBy('dateTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Activity.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Get past activities
  Stream<List<Activity>> getPastEvents() {
    final now = DateTime.now();
    return _firestore
        .collection(_collectionName)
        .where('dateTime', isLessThan: Timestamp.fromDate(now))
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Activity.fromMap(doc.id, doc.data()))
              .toList();
        });
  }
}
