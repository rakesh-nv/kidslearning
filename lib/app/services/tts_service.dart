import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import '../controllers/app_settings_controller.dart';

/// Centralised Text-To-Speech service with a fun, cartoon-style voice.
///
/// Tuning guide:
///   pitch      – 1.8 gives a high-pitched, playful cartoon feel
///   speechRate – 0.42 is clear enough for young children yet energetic
///   volume     – 1.0 always at full so kids can hear clearly
class TtsService extends GetxService {
  late final FlutterTts _tts;
  final _settings = Get.find<AppSettingsController>();

  @override
  Future<void> onInit() async {
    super.onInit();
    _tts = FlutterTts();
    await _configure();
  }

  Future<void> _configure() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.42);   // Slightly upbeat but clear for kids
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.8);         // High pitch = cartoon / fun voice
    await _tts.awaitSpeakCompletion(true);
  }

  /// Speak [text] only if sound is enabled in settings.
  Future<void> speak(String text) async {
    if (_settings.isSoundEnabled.value) {
      await _tts.stop();
      await _tts.speak(text);
    }
  }

  /// Speak without waiting for completion (fire-and-forget).
  Future<void> speakAsync(String text) async {
    if (_settings.isSoundEnabled.value) {
      await _tts.awaitSpeakCompletion(false);
      await _tts.stop();
      await _tts.speak(text);
      await _tts.awaitSpeakCompletion(true); // restore default
    }
  }

  Future<void> stop() async {
    await _tts.stop();
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
