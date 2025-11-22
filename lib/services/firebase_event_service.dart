import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rukunin/models/event.dart';

class FirebaseEventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'events';

  // Get all events
  Stream<List<Event>> getEvents() {
    return _firestore
        .collection(_collectionName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Event.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Get events for a specific date
  Future<List<Event>> getEventsByDate(String date) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('date', isEqualTo: date)
          .orderBy('time')
          .get();

      return snapshot.docs
          .map((doc) => Event.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching events by date: $e');
      return [];
    }
  }

  // Get single event by ID
  Stream<Event?> getEventById(String eventId) {
    return _firestore.collection(_collectionName).doc(eventId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return Event.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  // Create new event
  Future<String?> createEvent(Event event) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(event.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating event: $e');
      return null;
    }
  }

  // Update event
  Future<bool> updateEvent(String eventId, Event event) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(eventId)
          .update(event.toMap());
      return true;
    } catch (e) {
      print('Error updating event: $e');
      return false;
    }
  }

  // Delete event
  Future<bool> deleteEvent(String eventId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).delete();
      return true;
    } catch (e) {
      print('Error deleting event: $e');
      return false;
    }
  }

  // Join event (add user to participants)
  Future<bool> joinEvent(String eventId, String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).update({
        'participants': FieldValue.arrayUnion([userId]),
      });
      return true;
    } catch (e) {
      print('Error joining event: $e');
      return false;
    }
  }

  // Leave event (remove user from participants)
  Future<bool> leaveEvent(String eventId, String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(eventId).update({
        'participants': FieldValue.arrayRemove([userId]),
      });
      return true;
    } catch (e) {
      print('Error leaving event: $e');
      return false;
    }
  }

  // Check if user has joined event
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

  // Get events by category
  Stream<List<Event>> getEventsByCategory(String category) {
    return _firestore
        .collection(_collectionName)
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Event.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  // Get upcoming events
  Stream<List<Event>> getUpcomingEvents() {
    final today = DateTime.now();
    final todayStr =
        '${today.day.toString().padLeft(2, '0')} ${_getMonthName(today.month)} ${today.year}';

    return _firestore
        .collection(_collectionName)
        .orderBy('date')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Event.fromMap(doc.id, doc.data()))
              .toList();
        });
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }
}
