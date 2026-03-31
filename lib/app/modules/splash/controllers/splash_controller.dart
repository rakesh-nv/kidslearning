import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../services/ad_service.dart';
import '../../../services/connectivity_service.dart';
import '../../../services/purchase_service.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // ⏳ Start minimum display timer
    final startTime = DateTime.now();

    // 🚀 Background Initializations
    // Find the global permanent services from main.dart and initialize them
    final connectivity = Get.find<ConnectivityService>();
    final purchase = Get.find<PurchaseService>();
    final adService = Get.find<AdService>();
    
    // Await their internal async logic
    await connectivity.init();
    await purchase.init();
    await adService.init();
    
    // Force pre-caching of the first ad
    adService.loadRewardedAd();

    // 🎯 Calculate remaining time to keep splash visible
    final elapsedTime = DateTime.now().difference(startTime);
    final remainingTime = const Duration(milliseconds: 2500) - elapsedTime;

    if (remainingTime > Duration.zero) {
      await Future.delayed(remainingTime);
    }

    // 🏁 Cleanly transition to Home
    Get.offNamed(Routes.HOME);
  }
}
