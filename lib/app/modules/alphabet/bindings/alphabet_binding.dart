import 'package:get/get.dart';
import '../controllers/alphabet_controller.dart';

class AlphabetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlphabetController>(
      () => AlphabetController(),
    );
  }
}
