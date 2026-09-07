import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/app_settings_controller.dart';
import 'app/services/sound_service.dart';
import 'app/services/tts_service.dart';
import 'app/services/ad_service.dart';
import 'app/services/connectivity_service.dart';
import 'app/services/purchase_service.dart';
import 'app/controllers/monetization_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AppSettingsController());
  Get.put(SoundService());
  Get.put(TtsService(), permanent: true);
  Get.put(ConnectivityService(), permanent: true);
  Get.put(PurchaseService(), permanent: true);
  Get.put(AdService(), permanent: true);
  Get.put(MonetizationController(), permanent: true);
  runApp(const MyApp());
}










class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kids Learning',
      theme: ThemeData(
        fontFamily: 'ComicSans', // Works if you add the font, otherwise gracefully defaults
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
} 
