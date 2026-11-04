import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/appointment.dart';
import '../../../data/repositories/appointments_repository.dart';

final appointmentsRepositoryProvider = Provider<AppointmentsRepository>(
  (ref) => AppointmentsRepository(FirebaseFirestore.instance),
);

final appointmentsProvider = StreamProvider.autoDispose
    .family<AppointmentSnapshot, String>(
      (ref, uid) => ref.watch(appointmentsRepositoryProvider).watch(uid),
    );
