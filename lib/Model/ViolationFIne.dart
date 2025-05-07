class ViolationFine {
  int id;
  int violationId;
  String createdDate;
  double fine;
  int active; // 1 = active, 0 = inactive

  // Constructor
  ViolationFine({
    required this.id,
    required this.violationId,
    required this.createdDate,
    required this.fine,
    required this.active,
  });

  // Factory constructor to create a ViolationFine from a JSON/map object
  factory ViolationFine.fromMap(Map<String, dynamic> map) {
    return ViolationFine(
      id: map['id'],
      violationId: map['violation_id'],
      createdDate: map['created_date'],
      fine: (map['fine'] as num).toDouble(),
      active: map['active'], // Ensuring 0 or 1
    );
  }

  // Convert a ViolationFine object to a Map (for sending data to the server)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'violation_id': violationId,
      'created_date': createdDate,
      'fine': fine,
      'active': active,
    };
  }
}
