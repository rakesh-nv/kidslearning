import 'package:get/get.dart';
import '../../../services/tts_service.dart';

class HomeController extends GetxController {
  final _tts = Get.find<TtsService>();

  Future<void> speak(String text) => _tts.speak(text);

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
