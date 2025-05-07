import 'package:motorbikesafety/Model/ChallanDetails.dart';

class Challan {
  final int id;
  final String violatorName;
  final String violatorCnic;
  final String mobileNumber;
  final String vehicleNumber;
  final int violationHistoryId;
  final int wardenId;
  final String challanDate;
  final String status;
  final String fineAmount;
  final List<ChallanDetail> challanDetails;

  Challan({
    required this.id,
    required this.violatorName,
    required this.violatorCnic,
    required this.mobileNumber,
    required this.vehicleNumber,
    required this.violationHistoryId,
    required this.wardenId,
    required this.challanDate,
    required this.status,
    required this.fineAmount,
    required this.challanDetails,
  });

  factory Challan.fromJson(Map<String, dynamic> json) {
    return Challan(
      id: json['id'],
      violatorName: json['violator_name'],
      violatorCnic: json['violator_cnic'],
      mobileNumber: json['mobile_number'],
      vehicleNumber: json['vehicle_number'],
      violationHistoryId: json['violation_history_id'],
      wardenId: json['warden_id'],
      challanDate: json['challan_date'],
      status: json['status'],
      fineAmount: json['fine_amount'],
      challanDetails: (json['violation_details'] as List)
          .map((e) => ChallanDetail.fromJson(e))
          .toList(),
    );
  }
}
