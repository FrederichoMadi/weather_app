import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:weatherapp/app/data/network/response/weather_response_model.dart';
import 'package:weatherapp/app/utils/const.dart';

class WeatherService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = BASE_URL;

    super.onInit();
  }

  Future<Map<String, dynamic>> getWeather(Map<String, dynamic> map) async {
    final response = await get(
        "onecall?lat=${map['lat']}&lon=${map['long']}&appid=${map['appid']}");
    log(response.toString());
    if (response.statusCode == 200) {
      return json.decode(response.bodyString.toString());
    } else {
      return Future.error(response.body);
    }
  }
}
