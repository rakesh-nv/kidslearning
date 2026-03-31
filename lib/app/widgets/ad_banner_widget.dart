import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';
import '../services/ad_service.dart';
import '../controllers/monetization_controller.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final AdService _adService = Get.find<AdService>();
  final MonetizationController _monetizationController = Get.find<MonetizationController>();

  @override
  void initState() {
    super.initState();
    if (_monetizationController.shouldShowAds) {
      _loadAd();
    }
  }

  void _loadAd() {
    if (_bannerAd != null) return; // Already loading
    
    _bannerAd = BannerAd(
      adUnitId: _adService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _bannerAd = null;
          print('Ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_monetizationController.shouldShowAds) {
        return const SizedBox.shrink(); 
      }
      
      if (!_isLoaded && _bannerAd == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd());
      }
      
      if (_isLoaded && _bannerAd != null) {
        return Container(
          alignment: Alignment.center,
          width: _bannerAd!.size.width.toDouble(),
          height: _bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: _bannerAd!),
        );
      }
      
      // Fun placeholder while loading or if it fails
      return Container(
         height: 50,
         alignment: Alignment.center,
         child: const Text(
           "🐰 Good job! Keep learning!", 
           style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 16)
         ),
      );
    });
  }
}

