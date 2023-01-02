import 'package:get/get.dart';

import '../controllers/deatil_controller.dart';

class DeatilBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeatilController>(
      () => DeatilController(),
    );
  }
}
