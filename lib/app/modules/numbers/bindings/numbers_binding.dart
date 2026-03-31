import 'package:get/get.dart';
import '../controllers/numbers_controller.dart';

class NumbersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NumbersController>(
      () => NumbersController(),
    );
  }
}
