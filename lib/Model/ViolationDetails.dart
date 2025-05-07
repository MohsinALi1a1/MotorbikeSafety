class ViolationDetail {
  String violationName;

  ViolationDetail({required this.violationName});

  factory ViolationDetail.fromMap(Map<String, dynamic> map) {
    return ViolationDetail(
      violationName: map['violation_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'violation_name': violationName,
    };
  }
}
