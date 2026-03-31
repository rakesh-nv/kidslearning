import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppSettingsController extends GetxController {
  final _box = GetStorage();
  final RxBool isSoundEnabled = true.obs;

  final RxBool isButtonSoundEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    isSoundEnabled.value = _box.read('isSoundEnabled') ?? true;
    isButtonSoundEnabled.value = _box.read('isButtonSoundEnabled') ?? true;
  }

  void toggleSound(bool value) {
    isSoundEnabled.value = value;
    _box.write('isSoundEnabled', value);
  }

  void toggleButtonSound(bool value) {
    isButtonSoundEnabled.value = value;
    _box.write('isButtonSoundEnabled', value);
  }
}

