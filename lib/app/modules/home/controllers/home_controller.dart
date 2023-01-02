import 'dart:developer';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:weatherapp/app/data/network/api/api_service.dart';
import 'package:weatherapp/app/data/network/response/weather_response_model.dart';
import 'package:weatherapp/app/services/storage_service.dart';
import 'package:weatherapp/app/utils/const.dart';

class HomeController extends GetxController {
  final apiService = Get.put(WeatherService());
  final getStorage = Get.put(StorageService());
  Map<String, dynamic> weather = {};
  String state = "loading";
  DateTime currentTime = DateTime.now();

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    var lat = getStorage.read('lat');
    var long = getStorage.read('long');

    var params = {
      'lat': lat,
      'long': long,
      'appid': API_KEY,
    };
    log(params.toString());
    if (lat != null) {
      getWeather(params);
    }
  }

  getWeather(Map<String, dynamic> map) {
    state = "loading";
    apiService.getWeather(map).then((res) {
      weather = res;
      currentTime = DateTime.now();
      state = "hasData";
      update();
    }).catchError((error, stackTrace) {
      log(error.toString());
      state = "error";
      update();
    });
  }

  void onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    var lat = getStorage.read('lat');
    var long = getStorage.read('long');

    var params = {
      'lat': lat,
      'long': long,
      'appid': API_KEY,
    };
    log(params.toString());
    if (lat != null) {
      getWeather(params);
    }
    getWeather(params);
    // if failed,use refreshFailed()
    refreshController.refreshCompleted();
    update();
  }

  void onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    var lat = getStorage.read('lat');
    var long = getStorage.read('long');

    var params = {
      'lat': lat,
      'long': long,
      'appid': API_KEY,
    };
    log(params.toString());
    if (lat != null) {
      getWeather(params);
    }
    getWeather(params);
    refreshController.loadComplete();
    update();
  }
}
