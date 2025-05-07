class ViolationImage {
  final int id;
  final String imagePath;
  final int violationId;

  ViolationImage({
    required this.id,
    required this.imagePath,
    required this.violationId,
  });

  factory ViolationImage.fromJson(Map<String, dynamic> json) {
    return ViolationImage(
      id: json['id'],
      imagePath: json['image_path'],
      violationId: json['violation_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_path': imagePath,
      'violation_id': violationId,
    };
  }
}
