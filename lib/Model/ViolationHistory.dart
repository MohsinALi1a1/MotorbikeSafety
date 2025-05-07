import 'package:motorbikesafety/Model/ViolationDetails.dart';

class ViolationHistory {
  int id;
  int vehicleId;
  String violationDatetime;
  String location;
  String status;
  int cameraId;
  String licenseplate;
  String vehicletype;
  List<ViolationDetail> violationDetails;

  ViolationHistory({
    required this.id,
    required this.licenseplate,
    required this.vehicletype,
    required this.vehicleId,
    required this.violationDatetime,
    required this.location,
    required this.status,
    required this.cameraId,
    required this.violationDetails,
  });

  factory ViolationHistory.fromMap(Map<String, dynamic> map) {
    return ViolationHistory(
      id: map['id'],
      vehicletype: map['vehicletype'],
      licenseplate: map['licenseplate'],
      vehicleId: map['vehicle_id'],
      violationDatetime: map['violation_datetime'],
      location: map['location'],
      status: map['status'],
      cameraId: map['camera_id'],
      violationDetails: (map['violation_details'] as List)
          .map((e) => ViolationDetail.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'licenseplate': licenseplate,
      'vehicletype': vehicletype,
      'vehicle_id': vehicleId,
      'violation_datetime': violationDatetime,
      'location': location,
      'status': status,
      'camera_id': cameraId,
      'violation_details': violationDetails.map((e) => e.toMap()).toList(),
    };
  }
}
