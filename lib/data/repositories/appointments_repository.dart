import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/appointment.dart';

class AppointmentsRepository {
  AppointmentsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _appointments(String uid) =>
      _firestore.collection('users').doc(uid).collection('appointments');

  Stream<List<Appointment>> watch(String uid) {
    return _appointments(uid)
        .orderBy('startsAt')
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => [
            for (final document in snapshot.docs)
              Appointment(
                id: document.id,
                title: document['title'] as String,
                notes: document['notes'] as String,
                location: document['location'] as String,
                startsAt: (document['startsAt'] as Timestamp)
                    .toDate()
                    .toLocal(),
                pending: document.metadata.hasPendingWrites,
              ),
          ],
        );
  }

  Future<void> delete({required String uid, required String id}) =>
      _appointments(uid).doc(id).delete();

  Future<void> save({
    String? id,
    required String uid,
    required String title,
    required String notes,
    required String location,
    required DateTime startsAt,
  }) {
    final fields = <String, dynamic>{
      'title': title,
      'notes': notes,
      'location': location,
      'startsAt': Timestamp.fromDate(startsAt),
    };
    final collection = _appointments(uid);
    return id == null
        ? collection.doc().set(fields)
        : collection.doc(id).update(fields);
  }
}
