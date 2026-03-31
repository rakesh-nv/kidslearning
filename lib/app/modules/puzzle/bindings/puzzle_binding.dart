import 'package:get/get.dart';
import '../controllers/puzzle_controller.dart';

class PuzzleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PuzzleController>(() => PuzzleController());
  }
}
