class ChallanDetail {
  final String violation;
  final double fine;

  ChallanDetail({
    required this.violation,
    required this.fine,
  });

  factory ChallanDetail.fromJson(Map<String, dynamic> json) {
    return ChallanDetail(
      violation: json['violation'],
      fine: (json['fine'] as num).toDouble(),
    );
  }
}
