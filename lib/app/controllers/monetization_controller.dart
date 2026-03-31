import 'package:get/get.dart';
import '../services/ad_service.dart';
import '../services/connectivity_service.dart';
import '../services/purchase_service.dart';
import 'package:flutter/material.dart';

class MonetizationController extends GetxController {
  final _adService = Get.find<AdService>();
  final _connectivity = Get.find<ConnectivityService>();
  final _purchase = Get.find<PurchaseService>();

  bool get shouldShowAds => _connectivity.isOnline.value && !_purchase.isPremium.value;
  bool get isOnline => _connectivity.isOnline.value;
  bool get isPremium => _purchase.isPremium.value;

  void attemptUnlockWithReward({required Function onSuccess}) {
    if (isPremium) {
      onSuccess();
      return;
    }

    if (!isOnline) {
      Get.snackbar(
        "No Internet! 🐰", 
        "Connect to the internet to unlock this feature and have more fun!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent.withOpacity(0.9),
        colorText: Colors.white,
      );
      return;
    }

    if (!_adService.isAdReady.value) {
      // Show loading dialog immediately
      Get.dialog(
        const Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.blueAccent),
                  SizedBox(height: 25),
                  Text("🐰 Magic Gift Loading...", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)
                  ),
                  SizedBox(height: 10),
                  Text("Wait just a second, kids!", 
                    style: TextStyle(fontSize: 14, color: Colors.grey)
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Listener for when ad becomes ready
      ever(_adService.isAdReady, (bool ready) {
        if (ready && Get.isDialogOpen!) {
          Get.back(); // close dialog
          _adService.showRewardedAd(onRewardEarned: () => onSuccess());
        }
      });

      // Also ensure it is actually trying to load
      if (!_adService.isAdLoading.value) {
         _adService.loadRewardedAd();
      }
      return;
    }

    _adService.showRewardedAd(
      onRewardEarned: () {
        onSuccess();
      }
    );
  }

  void attemptPremiumAction({required Function onSuccess}) {
    if (isPremium) {
      onSuccess();
      return;
    }
    
    Get.defaultDialog(
      title: "Unlock Everything! 💎",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
      content: const Column(
        children: [
          Text("Get premium to unlock all levels forever and remove all ads! 🐰"),
          SizedBox(height: 20),
          Icon(Icons.stars_rounded, color: Colors.orangeAccent, size: 50),
        ],
      ),
      textConfirm: "Go Premium",
      confirmTextColor: Colors.white,
      buttonColor: Colors.blueAccent,
      textCancel: "Maybe Later",
      onConfirm: () {
        Get.back(); // close dialog
        _purchase.buyPremium();
      },
    );
  }
}
