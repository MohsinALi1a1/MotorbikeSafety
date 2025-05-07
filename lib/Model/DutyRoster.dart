class DutyRoster {
  final String wardenName;
  final String badgeNumber;
  final String chowkiName;
  final String chowkiPlace;
  final String shiftName;
  final String shiftTime;
  final String dutyDate;
  final int chowki_id;

  DutyRoster(
      {required this.wardenName,
      required this.badgeNumber,
      required this.chowkiName,
      required this.chowkiPlace,
      required this.shiftName,
      required this.shiftTime,
      required this.dutyDate,
      required this.chowki_id});

  // Convert a map to a DutyRoster object
  factory DutyRoster.fromMap(Map<String, dynamic> map) {
    return DutyRoster(
      wardenName: map['warden_name'],
      badgeNumber: map['badge_number'],
      chowkiName: map['chowki_name'],
      chowkiPlace: map['chowki_place'],
      shiftName: map['shift_name'],
      shiftTime: map['shift_time'],
      dutyDate: map['duty_date'],
      chowki_id: map['chowki_id'],
    );
  }

  // Convert a DutyRoster object to a map
  Map<String, dynamic> toMap() {
    return {
      'warden_name': wardenName,
      'badge_number': badgeNumber,
      'chowki_name': chowkiName,
      'chowki_place': chowkiPlace,
      'shift_name': shiftName,
      'shift_time': shiftTime,
      'duty_date': dutyDate,
      'chowki_id': chowki_id
    };
  }

  @override
  String toString() {
    return 'DutyRoster(wardenName: $wardenName, badgeNumber: $badgeNumber, chowkiName: $chowkiName, chowkiPlace: $chowkiPlace, shiftName: $shiftName, shiftTime: $shiftTime, dutyDate: $dutyDate ,chowki_id : $chowki_id)';
  }
}
