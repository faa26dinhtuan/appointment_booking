enum AppointmentStatus {
  upcoming,
  completed,
  canceled;

  static AppointmentStatus fromStorage(Object? value) => switch (value) {
    'completed' => completed,
    'canceled' => canceled,
    _ => upcoming,
  };
}

class Appointment {
  const Appointment({
    required this.id,
    required this.title,
    required this.notes,
    required this.location,
    required this.startsAt,
    required this.pending,
    required this.status,
  });

  final String id;
  final String title;
  final String notes;
  final String location;
  final DateTime startsAt;
  final bool pending;
  final AppointmentStatus status;
}

typedef AppointmentSnapshot = ({List<Appointment> items, bool isFromCache});
