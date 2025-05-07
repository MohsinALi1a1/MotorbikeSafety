class Camera {
  int? id;
  String name;
  String Type;
  String direction;
  String place_name;

  // Constructor to create a Camera object directly with required fields
  Camera(
      {required this.name,
      required this.Type,
      required this.direction,
      required this.place_name});

  // Constructor to create a Camera from a Map (e.g., from a database row)
  Camera.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        Type = map['Type'],
        direction = map['direction'],
        place_name = map['place_name'];

  // Method to convert a Camera object back to a Map (useful for inserting/updating)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'Type': Type,
      'direction': direction,
      'place_name': place_name
    };
  }
}
