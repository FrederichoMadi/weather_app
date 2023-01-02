import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:get/get.dart';
import 'package:weatherapp/app/services/storage_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialConfig();
  initControl();

  runApp(
    GetMaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xff000918)),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}

Future<void> initialConfig() async {
  await Get.putAsync(() => StorageService().init());
}

initControl() async {
  final getStorage = Get.put(StorageService());

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission().then((value) async {
      if (value != LocationPermission.denied) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((position) {
          getStorage.write("lat", position.latitude);
          getStorage.write("long", position.longitude);
        });
      }
    });
  } else if (permission != LocationPermission.denied) {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      getStorage.write("lat", position.latitude);
      getStorage.write("long", position.longitude);
    });
  }
}
