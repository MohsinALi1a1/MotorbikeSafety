class Vehicle {
  final int id;
  final String licensePlate;
  final String vehicleType;

  Vehicle({
    required this.id,
    required this.licensePlate,
    required this.vehicleType,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      licensePlate: map['licenseplate'],
      vehicleType: map['vehicletype'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'licenseplate': licensePlate,
      'vehicletype': vehicleType,
    };
  }
}
