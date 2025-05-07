class CameraNaka {
  int camera_id;
  String camera_name;
  String place_name;
  String chowki_name;
  String camera_type;

  // Constructor to create a Camera object directly with required fields
  CameraNaka(
      {required this.camera_id,
      required this.place_name,
      required this.chowki_name,
      required this.camera_name,
      required this.camera_type});

  // Constructor to create a Camera from a Map (e.g., from a database row)
  CameraNaka.fromMap(Map<String, dynamic> map)
      : camera_id = map['camera_id'],
        place_name = map['place_name'],
        camera_name = map['camera_name'],
        chowki_name = map['chowki_name'],
        camera_type = map['camera_type'];

  // Method to convert a Camera object back to a Map (useful for inserting/updating)
  Map<String, dynamic> toMap() {
    return {
      'camera_id': camera_id,
      'place_name': place_name,
      'camera_name': camera_name,
      'chowki_name': chowki_name,
      'camera_type': camera_type
    };
  }
}
