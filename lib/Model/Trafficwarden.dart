class TrafficWarden {
  final int id;
  final String name;
  final String badgeNumber;
  final String address;
  final String cnic;
  final String email;
  final String mobileNumber;
  final String cityName;

  // Constructor
  TrafficWarden({
    required this.id,
    required this.name,
    required this.badgeNumber,
    required this.address,
    required this.cnic,
    required this.email,
    required this.mobileNumber,
    required this.cityName,
  });

  // Factory method to create an instance of TrafficWarden from a map (similar to how data is retrieved from the API)
  factory TrafficWarden.fromMap(Map<String, dynamic> map) {
    return TrafficWarden(
      id: map['id'],
      name: map['name'],
      badgeNumber: map['badge_number'],
      address: map['address'],
      cnic: map['cnic'],
      email: map['email'],
      mobileNumber: map['mobile_number'],
      cityName: map['city_Name'],
    );
  }

  // Method to convert TrafficWarden instance to a map (for sending data to an API or database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'badge_number': badgeNumber,
      'address': address,
      'cnic': cnic,
      'email': email,
      'mobile_number': mobileNumber,
      'city_Name': cityName,
    };
  }
}
