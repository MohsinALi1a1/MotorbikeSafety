import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:motorbikesafety/Model/Camera.dart';
import 'package:motorbikesafety/Model/City.dart';

class API {
  static final String baseurl = 'http://192.168.1.19:4321';

  // City CRUD Operations   get, add ,delete

  Future<http.Response> getAllCities() async {
    String url = '$baseurl/city';
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
    String url = '$baseurl/addcity';
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
    String url = '$baseurl/deletecity';
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
        '$baseurl/place?name=$name'; // Assuming 'name' is a query parameter

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
    String url = '$baseurl/deleteplace';
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
    String url = '$baseurl/addplace';
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
        '$baseurl/directions?name=$name'; // Assuming 'name' is a query parameter

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
    String url = '$baseurl/deletedirection';
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
    String url = '$baseurl/adddirection';
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
    String url = '$baseurl/camera';

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
    String url = '$baseurl/deletecamera';
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
    String url = '$baseurl/addcamera';
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
    String url = '$baseurl/addchowki';
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
    String url = '$baseurl/chowki';

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
    String url = '$baseurl/deletechowki';
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
    String url = '$baseurl/linkcamerachowki';
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
      throw Exception('Error adding camera with Naka: $e');
    }
  }

  Future<http.Response> getAllCamerasofNaka(String chowkiname) async {
    String url = '$baseurl/linkcamerawithchowki';

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

  Future<http.Response> getAllNakaofNaka(int Nakaid) async {
    String url = '$baseurl/getnakadirectlink';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "FromNakaID": Nakaid,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Link Naka of Naka:  $e');
    }
  }

  Future<http.Response> add_NakawithNaka(
      int FromNakaID, ToNakaIDlist, distanceList) async {
    String url = '$baseurl/linkNakawithnaka';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "FromNakaID": FromNakaID,
          "ToNakaID": ToNakaIDlist,
          "DistanceKM": distanceList
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error Linking  Naka with of Naka:  $e');
    }
  }

  Future<bool> deleteLinknaka(int nakaid, int tonaka) async {
    String url = '$baseurl/deletelinknaka';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json
            .encode({'id': nakaid, 'tonakaid': tonaka}), // Send the Place data
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        return false; // Failed to add city
      }
    } catch (e) {
      throw Exception('Error Deleting Link Naka: $e');
    }
  }

  // Crud Operations on Shifts get , add, delete
  Future<http.Response> getAllShifts() async {
    String url =
        '$baseurl/shift'; // Assuming the endpoint for cities is /cities
    var response = await http.get(Uri.parse(url));
    return response;
  }

  Future<bool> addshift(
      String shiftname, String starttime, String endtime) async {
    String url = '$baseurl/addshift';
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
    String url = '$baseurl/deleteshift';
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
    String url = '$baseurl/addtrafficwarden';
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
    String url = '$baseurl/wardensincity';
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
    String url = '$baseurl/deletewarden';
    try {
      var response = await http.delete(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'cnic': cnic,
        }), // Send the city data
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
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
    String url = '$baseurl/wardenlogin';
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

  Future<http.Response> userlogin(String cnic, String password) async {
    String url = '$baseurl/Userlogin';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'Cnic': cnic, 'password': password}),
      );

      return response;
    } catch (e) {
      throw Exception('Error Login User: $e');
    }
  }

// Crud Operations on Duty Roster get
  Future<http.Response> getAlldutyroster() async {
    String url =
        '$baseurl/getassignjobs'; // Assuming 'name' is a query parameter

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
    String url = '$baseurl/wardenassignments';

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
    String url = '$baseurl/getassignjobofwardenbyid';
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

  Future<http.Response> getuserbyid(int id) async {
    String url = '$baseurl/userbyid';
    print(id); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"id": id}));

      return response;
    } catch (e) {
      throw Exception('Error fetching User: $e');
    }
  }

  Future<bool> addviolation(
    String name,
    String description,
    int limitValue,
    int fine,
  ) async {
    String url = '$baseurl/violation';
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
    String url = '$baseurl/violations'; // Assuming 'name' is a query parameter

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
      int violationId,
      String? newName,
      String? newDescription,
      int? newlimitValue,
      int? newfine,
      DateTime? startDate,
      DateTime? endDate) async {
    String url = '$baseurl/updateviolation';
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violationId,
          'new_name': newName,
          'new_description': newDescription,
          'newlimitValue': newlimitValue,
          'newfine': newfine,
          'start_date': startDate?.toIso8601String(),
          'end_date': endDate?.toIso8601String(),
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
    int violationId,
    String? Status,
  ) async {
    String url = '$baseurl/updateviolationstatus';
    try {
      var response = await http.put(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violationId,
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

  Future<http.Response> getViolation(int violationId) async {
    String url =
        '$baseurl/violationsbyid'; // Assuming 'name' is a query parameter

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_id': violationId,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Error fetching Violations Rule: $e');
    }
  }

  Future<http.Response> getviolationhistorybynakaid(
      int chowkiId, int wardenId) async {
    String url = '$baseurl/getviolationsrecord_for_nakaid';
    // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"warden_id": wardenId}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Violation History For Naka: $e');
    }
  }

  Future<http.Response> getVehiclebyid(int id) async {
    String url = '$baseurl/vehiclebyid';

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
      int violationHistoryId,
      List<int> violationIds,
      String violatorCnic,
      String violatorName,
      String mobileNumber,
      String vehicleNumber,
      int wardenId,
      double fineAmount,
      String status) async {
    String url = '$baseurl/addchallanrecord';
    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'violation_history_id': violationHistoryId,
          'violation_ids': violationIds,
          'violator_cnic': violatorCnic,
          'violator_name': violatorName,
          'mobile_number': mobileNumber,
          'vehicle_number': vehicleNumber,
          'warden_id': wardenId,
          'fine_amount': fineAmount,
          'status': status
        }),
      );

      return response;
    } catch (e) {
      throw Exception('Error adding Challan and Details: $e');
    }
  }

  Future<http.Response> getchallanhistorybywardenid(int wardenId) async {
    String url = '$baseurl/getchallans';
    print(wardenId); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"warden_id": wardenId}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Challan History For Warden: $e');
    }
  }

  Future<http.Response> getnotificationbywardenid(int recipientId) async {
    String recipientType = "TrafficWarden";
    String url = '$baseurl/getnotifications';
    print(recipientId); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(
              {"recipient_id": recipientId, "recipient_type": recipientType}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Notification For Warden: $e');
    }
  }

  Future<http.Response> send_notificationto_link_Naka(int FromNakaID,
      String bike, int hops, String location, int violationhistoryId) async {
    String url = '$baseurl/testing_get_naka';

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({
            "FromNakaID": FromNakaID,
            "bike": bike,
            "hops": hops,
            "location": location,
            "violationhistory_id": violationhistoryId
          }));

      return response;
    } catch (e) {
      throw Exception('Error Sending  Notification to Link Naka: $e');
    }
  }

  Future<http.Response> getchallanhistorybyuserid(int userCnic) async {
    String url = '$baseurl/getchallans';
    print(userCnic); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode({"user_id": userCnic}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Challan History For USerCnic: $e');
    }
  }

  Future<http.Response> getnotificationbyuserid(int recipientId) async {
    String recipientType = "User";
    String url = '$baseurl/getnotifications';
    print(recipientId); // Assuming 'name' is a query parameter

    try {
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: json.encode(
              {"recipient_id": recipientId, "recipient_type": recipientType}));

      return response;
    } catch (e) {
      throw Exception('Error fetching Notification For USer: $e');
    }
  }
}
