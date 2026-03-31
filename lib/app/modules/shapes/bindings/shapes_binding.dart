import 'package:get/get.dart';
import '../controllers/shapes_controller.dart';

class ShapesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShapesController());
  }
}
