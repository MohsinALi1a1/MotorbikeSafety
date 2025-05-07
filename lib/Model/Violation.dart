import 'package:motorbikesafety/Model/ViolationFIne.dart';

class Violation {
  int id;
  String name;
  String description;
  List<ViolationFine> fines;
  int limitValue;
  String status;
  DateTime? startDate;
  DateTime? endDate;

  // Constructor
  Violation({
    required this.id,
    required this.name,
    required this.description,
    required this.fines,
    required this.limitValue,
    required this.status,
    this.startDate,
    this.endDate,
  });

  // Factory constructor to create a Violation from a Map (JSON response)
  factory Violation.fromMap(Map<String, dynamic> map) {
    return Violation(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      status: map['status'],
      fines: (map['fines'] as List)
          .map((fine) => ViolationFine.fromMap(fine))
          .toList(),
      limitValue: map['limitValue'] ?? -1,
      startDate:
          map['start_date'] != null ? DateTime.parse(map['start_date']) : null,
      endDate: map['end_date'] != null ? DateTime.parse(map['end_date']) : null,
    );
  }

  // Method to convert a Violation object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fines': fines.map((fine) => fine.toMap()).toList(),
      'limitValue': limitValue,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
    };
  }
}
