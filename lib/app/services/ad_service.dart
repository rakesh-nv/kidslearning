import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdService extends GetxService {
  final RxBool isAdReady = false.obs;
  final RxBool isAdLoading = false.obs;
  RewardedAd? _rewardedAd;

  // Banner Ad unit IDs
  String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
  }

  // Rewarded Ad unit IDs
  String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test ID
    } else {
      return 'ca-app-pub-3940256099942544/1712485313'; // Test ID
    }
  }

  Future<AdService> init() async {
    await MobileAds.instance.initialize();
    
    // Set targeting for kids
    RequestConfiguration requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    );
    MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    
    loadRewardedAd();
    return this;
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('Banner Ad loaded.'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner Ad failed to load: $error');
        },
      ),
    );
  }

  void loadRewardedAd() {
    if (isAdLoading.value) return; // Don't load twice
    isAdLoading.value = true;
    
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          isAdReady.value = true;
          isAdLoading.value = false;
        },
        onAdFailedToLoad: (error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          isAdReady.value = false;
          isAdLoading.value = false;
        },
      ),
    );
  }

  void showRewardedAd({required Function onRewardEarned}) {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded ad before it was loaded.');
      loadRewardedAd(); // Try again for next time
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => print('Ad showed fullscreen content.'),
      onAdDismissedFullScreenContent: (ad) {
        print('Ad dismissed fullscreen content.');
        ad.dispose();
        _rewardedAd = null;
        isAdReady.value = false;
        loadRewardedAd(); // Load the next one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('Ad failed to show fullscreen content: $error');
        ad.dispose();
        _rewardedAd = null;
        isAdReady.value = false;
        loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('Reward earned: ${reward.amount} ${reward.type}');
        onRewardEarned();
      }
    );
  }
}
