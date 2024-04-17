import 'dart:convert';
import 'package:http/http.dart' as http;

class BusService {
  Future<Map<String, dynamic>> fetchDataFromApi() async {
    const String apiUrl =
        "https://vehicle-tracker-f73518128155.herokuapp.com/app/v1/distance/all";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchStationNames() async {
    const String apiUrl =
        "https://vehicle-tracker-f73518128155.herokuapp.com/app/v1/bus_stops";
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        dynamic data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class BusData {
  dynamic currentData;
  dynamic lastData;
  dynamic stationNames;
  int counter = 0;
  bool isIdle = false;
  int counter2 = 0;
  bool isIdle2 = false;
  int noOfBus = 1;

  void setData(dynamic data, dynamic stations) {
    if (currentData == null) {
      currentData == data;
      lastData == data;
    }
    stationNames = stations;
    noOfBus = data['data'].length;

    lastData = currentData;
    currentData = data;

    if (currentData['data'][0]['distances'][0]['in_m'] ==
        lastData['data'][0]['distances'][0]['in_m']) {
      counter++;
      if (counter > 240) {
        isIdle = true;
      }
    } else {
      counter = 0;
      isIdle = false;
    }
    if (noOfBus == 2) {
      if (currentData['data'][1]['distances'][0]['in_m'] ==
          lastData['data'][1]['distances'][0]['in_m']) {
        counter2++;
        if (counter2 > 240) {
          isIdle2 = true;
        }
      } else {
        counter2 = 0;
        isIdle2 = false;
      }
    }
  }
}
