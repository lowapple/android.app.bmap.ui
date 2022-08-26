import 'dart:convert';

import 'package:bmap/models/park_facilities.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const baseUrl = 'http://43.200.220.3';

class DataNetwork {
  late Dio client;

  DataNetwork() {
    client = Dio();
    client.options.baseUrl = baseUrl;
  }

  Future<ParkFacilities> getParkFacilities(String id) async {
    final url = '/amenity/find/$id';
    if (kDebugMode) {
      print("$baseUrl/$url");
    }

    final response = await client.get(url);
    final res = getResponse(response);
    return ParkFacilities.fromJson(res);
  }

  Map<String, dynamic> getResponse(Response response) {
    Map<String, dynamic> res;
    try {
      res = jsonDecode(response.data);
    } catch (e) {
      res = response.data;
    }
    return res;
  }
}
