class Appointment {
  const Appointment({
    required this.title,
    required this.notes,
    required this.location,
    required this.startsAt,
    required this.pending,
  });

  final String title;
  final String notes;
  final String location;
  final DateTime startsAt;
  final bool pending;
}
