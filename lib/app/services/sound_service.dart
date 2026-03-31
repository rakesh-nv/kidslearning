import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../controllers/app_settings_controller.dart';

class SoundService extends GetxService {
  final AudioPlayer _player = AudioPlayer();
  final _settings = Get.find<AppSettingsController>();

  Future<void> playClickSound() async {
    if (_settings.isButtonSoundEnabled.value) {
      // Using a built-in or specific asset sound. 
      // For now, let's use a standard click sound if you have one, 
      // or I can suggest adding a 'click.mp3' to assets.
      try {
        await _player.play(AssetSource('sounds/click.mp3'));
      } catch (e) {
        // Fallback or ignore if asset doesn't exist yet
      }
    }
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
