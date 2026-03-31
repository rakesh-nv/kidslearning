import 'package:get/get.dart';
import '../controllers/fruits_controller.dart';

class FruitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FruitsController>(() => FruitsController());
  }
}
