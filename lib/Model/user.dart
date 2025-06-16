class User {
  int? id;
  final String cnic;
  final String email;
  final String mobilenumber;
  final String name;

  // Constructor to create a City object directly with a name
  User(
      {required this.cnic,
      required this.email,
      required this.mobilenumber,
      required this.name});
  // Constructor to create a City from a Map (e.g., from a database row)
  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        cnic = map['cnic'],
        email = map['email'],
        mobilenumber = map['mobilenumber'];

  // Method to convert a City object back to a Map (useful for inserting/updating)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'email': email,
      'mobilenumber': mobilenumber,
      'cnic': cnic
    };
  }
}
