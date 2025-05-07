import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';

class API {
  static final String _baseurl = 'http://127.0.0.1:4321';

  // City CRUD Operations   get, add ,delete

  Future<http.Response> getAllCities() async {
    String url = '$_baseurl/city';
    try {
      // Assuming the endpoint for cities is /cities
      var response = await http.get(Uri.parse(url));
      return response;
    } catch (e) {
      throw Exception('Error Getting city: $e');
    }
  }

  // Method to add a city
  Future<bool> addCity(City city) async {
    String url = '$_baseurl/addcity';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(city.toMap()), // Send the city data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding city: $e');
    }
  }

  Future<bool> deleteCity(String name) async {
    String url = '$_baseurl/deletecity';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'name': name}), // Send the city data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to Delete city
      }
    } catch (e) {
      throw Exception('Error Deleting city: $e');
    }
  }

  // Crud Operation on Place   (get ,delete , add)

  Future<http.Response> getAllplaces(String name) async {
    String url =
        '$_baseurl/place?name=$name'; // Assuming 'name' is a query parameter

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  Future<bool> deleteplace(String placename, String cityname) async {
    String url = '$_baseurl/deleteplace';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'placename': placename,
          'cityname': cityname
        }), // Send the city data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to delete place
      }
    } catch (e) {
      throw Exception('Error Deleting Place: $e');
    }
  }

  Future<bool> addplace(String placename, String cityname) async {
    String url = '$_baseurl/addplace';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'placename': placename,
          'cityname': cityname
        }), // Send the city data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding city: $e');
    }
  }

// Crud operation on Direction get , delete ,add
  Future<http.Response> getAllDirection(String name) async {
    String url =
        '$_baseurl/directions?name=$name'; // Assuming 'name' is a query parameter

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Direction: $e');
    }
  }

  Future<bool> deletedirection(String directionname, String placename) async {
    String url = '$_baseurl/deletedirection';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'directionname': directionname,
          'placename': placename,
        }), // Send the Place data
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Direction: $e');
    }
  }

  Future<bool> adddirection(String directionname, String placename) async {
    String url = '$_baseurl/adddirection';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'placename': placename,
          'directionname': directionname
        }), // Send the city data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Direction: $e');
    }
  }
//Crud operation for camera

// Crud operation on Direction get , delete ,add
  Future<http.Response> getAllCamera(
      String placename, String directionname) async {
    String url = '$_baseurl/camera';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "placename": placename,
          "directionname": directionname,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Camera: $e');
    }
  }

  Future<bool> deleteCamera(
      String name, String directionname, String cameratype) async {
    String url = '$_baseurl/deletecamera';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': name,
          'directionname': directionname,
          'cameratype': cameratype
        }), // Send the Place data
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Camera: $e');
    }
  }

  Future<bool> addcamera(String name, String directionname, String type) async {
    String url = '$_baseurl/addcamera';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
            {'name': name, 'directionname': directionname, 'type': type}),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Camera: $e');
    }
  }

// Crud operation on NAKA (add ,get)

  Future<bool> addNaka(
      String name, String placename, List<Camera> cameralist) async {
    String url = '$_baseurl/addchowki';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'name': name, 'placename': placename}),
      );

      if (response.statusCode == 201) {
        await addcameraNaka(cameralist, name);
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Naka: $e');
    }
  }

  Future<http.Response> getAllNaka(String placename) async {
    String url = '$_baseurl/chowki';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'placename': placename,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching places: $e');
    }
  }

  Future<bool> deletenaka(String name, String placename) async {
    String url = '$_baseurl/deletechowki';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': name,
          'placename': placename,
        }), // Send the Place data
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Naka: $e');
    }
  }

  Future<bool> addcameraNaka(List<Camera> cameraname, String chowkiname) async {
    String url = '$_baseurl/linkcamerachowki';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'cameraname': cameraname.map((camera) => camera.toMap()).toList(),
          'chowkiname': chowkiname
        }),
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      print(e);
      throw Exception('Error adding Naka: $e');
    }
  }

  Future<http.Response> getAllCamerasofNaka(String chowkiname) async {
    String url = '$_baseurl/linkcamerawithchowki';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "chowkiname": chowkiname,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Camera of Naka:  $e');
    }
  }

  // Crud Operations on Shifts get , add, delete
  Future<http.Response> getAllShifts() async {
    String url =
        '$_baseurl/shift'; // Assuming the endpoint for cities is /cities
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<bool> addshift(
      String shiftname, String starttime, String endtime) async {
    String url = '$_baseurl/addshift';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'shiftname': shiftname,
          'starttime': starttime,
          'endtime': endtime
        }),
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Shifts: $e');
    }
  }

  Future<bool> deleteshift(
      String shiftname, String starttime, String endtime) async {
    String url = '$_baseurl/deleteshift';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'shiftname': shiftname,
          'starttime': starttime,
          'endtime': endtime
        }), // Send the city data
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Shift: $e');
    }
  }

// Crud Operation on Warden (add, get , delete)
  Future<bool> addwarden(String name, String address, String cnic, String email,
      String mobilenumber, String cityname) async {
    String url = '$_baseurl/addtrafficwarden';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': name,
          'address': address,
          'cnic': cnic,
          'email': email,
          'mobilenumber': mobilenumber,
          'cityname': cityname
        }),
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Shifts: $e');
    }
  }

  Future<http.Response> getAllwardens(String cityname) async {
    String url = '$_baseurl/wardensincity';
    print(cityname); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"cityname": cityname}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Wardens: $e');
    }
  }

  Future<bool> deletewarden(String cnic) async {
    String url = '$_baseurl/deletewarden';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'cnic': cnic,
        }), // Send the city data
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Warden: $e');
    }
  }

  // Method to Login Warden
  Future<http.Response> wardenlogin(String badge, String password) async {
    String url = '$_baseurl/wardenlogin';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'badge': badge, 'password': password}),
      );

      return response;
    } catch (e) {
      throw Exception('Error Login Warden: $e');
    }
  }

// Crud Operations on Duty Roster get
  Future<http.Response> getAlldutyroster() async {
    String url =
        '$_baseurl/getassignjobs'; // Assuming 'name' is a query parameter

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching DutyRoster: $e');
    }
  }

  Future<http.Response> autodutyroster() async {
    String url = '$_baseurl/wardenassignments';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      throw Exception('Error Assigning Auto Duty Roster: $e');
    }
  }

  Future<http.Response> getwardendutyrosterbyid(int id) async {
    String url = '$_baseurl/getassignjobofwardenbyid';
    print(id); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"id": id}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Wardens DutyRoster: $e');
    }
  }

  Future<bool> addviolation(
    String name,
    String description,
    int limitValue,
    int fine,
  ) async {
    String url = '$_baseurl/violation';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'name': name,
          'description': description,
          'limitValue': limitValue,
          'fine': fine,
        }),
      );

      if (response.statusCode == 201) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error adding Violations Rule and Fine: $e');
    }
  }

  Future<http.Response> getAllViolation() async {
    String url = '$_baseurl/violations'; // Assuming 'name' is a query parameter

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Violations Rule: $e');
    }
  }

  Future<bool> updateviolation(
      int violation_id,
      String? new_name,
      String? new_description,
      int? newlimitValue,
      int? newfine,
      DateTime? start_date,
      DateTime? end_date) async {
    String url = '$_baseurl/updateviolation';
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violation_id,
          'new_name': new_name,
          'new_description': new_description,
          'newlimitValue': newlimitValue,
          'newfine': newfine,
          'start_date': start_date?.toIso8601String(),
          'end_date': end_date?.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Updating Violations Rule and Fine: $e');
    }
  }

  Future<bool> updateviolationstatus(
    int violation_id,
    String? Status,
  ) async {
    String url = '$_baseurl/updateviolationstatus';
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violation_id,
          'Status': Status,
        }),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Updating Violations Status: $e');
    }
  }

  Future<http.Response> getViolation(int violation_id) async {
    String url =
        '$_baseurl/violationsbyid'; // Assuming 'name' is a query parameter

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violation_id,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Violations Rule: $e');
    }
  }

  Future<http.Response> getviolationhistorybynakaid(int chowki_id) async {
    String url = '$_baseurl/getviolationsrecord_for_nakaid';
    print(chowki_id); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"chowki_id": chowki_id}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Violation History For Naka: $e');
    }
  }

  Future<http.Response> getVehiclebyid(int id) async {
    String url = '$_baseurl/vehiclebyid';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id': id,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Vehicle: $e');
    }
  }

  // Crud Operation on Warden (add, get , delete)
  Future<http.Response> addchallan(
      int violation_history_id,
      List<int> violation_ids,
      String violator_cnic,
      String violator_name,
      String mobile_number,
      String vehicle_number,
      int warden_id,
      double fine_amount,
      String status) async {
    String url = '$_baseurl/addchallanrecord';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_history_id': violation_history_id,
          'violation_ids': violation_ids,
          'violator_cnic': violator_cnic,
          'violator_name': violator_name,
          'mobile_number': mobile_number,
          'vehicle_number': vehicle_number,
          'warden_id': warden_id,
          'fine_amount': fine_amount,
          'status': status
        }),
      );

      return response;
    } catch (e) {
      throw Exception('Error adding Challan and Details: $e');
    }
  }

  Future<http.Response> getchallanhistorybywardenid(int warden_id) async {
    String url = '$_baseurl/getchallans';
    print(warden_id); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"warden_id": warden_id}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Challan History For Warden: $e');
    }
  }

  Future<http.Response> getnotificationbywardenid(int recipient_id) async {
    String recipient_type = "TrafficWarden";
    String url = '$_baseurl/getnotifications';
    print(recipient_id); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "recipient_id": recipient_id,
            "recipient_type": recipient_type
          }));

      return response;
    } catch (e) {
      throw Exception('Error fetching Notification For Warden: $e');
    }
  }
}
