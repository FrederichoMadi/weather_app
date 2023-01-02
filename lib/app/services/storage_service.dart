import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  Future<StorageService> init() async {
    await GetStorage.init();
    return this;
  }

  void write(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  dynamic read(String key) => GetStorage().read(key);
  dynamic remove(String key) => GetStorage().remove(key);
}
