class Shift {
  final int id;
  final String shiftType;
  final String startTime;
  final String endTime;

  // Constructor
  Shift({
    required this.id,
    required this.shiftType,
    required this.startTime,
    required this.endTime,
  });

  // Factory method to create an instance of Shift from a map (similar to how data is retrieved from the API)
  factory Shift.fromMap(Map<String, dynamic> map) {
    return Shift(
      id: map['id'],
      shiftType: map['name'],
      startTime: map['start_time'],
      endTime: map['end_time'],
    );
  }

  // Method to convert Shift instance to a map (for sending data to an API or database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': shiftType,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
