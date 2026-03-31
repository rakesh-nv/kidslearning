import 'package:get/get.dart';
import '../controllers/shadow_match_controller.dart';

class ShadowMatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShadowMatchController>(() => ShadowMatchController());
  }
}
