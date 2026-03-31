import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:get_storage/get_storage.dart';

class PurchaseService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;
  final RxBool isPremium = false.obs;
  final _box = GetStorage();
  
  static const String premiumProductId = 'premium_upgrade_01'; // Replace with your actual product ID
  
  Future<PurchaseService> init() async {
    isPremium.value = _box.read('isPremium') ?? false;
    _iap.purchaseStream.listen(_onPurchaseDetailsUpdate);
    return this;
  }
  
  void _onPurchaseDetailsUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.purchased || 
          purchaseDetails.status == PurchaseStatus.restored) {
        _unlockPremium(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        Get.snackbar("Oops! 🐰", "Something went wrong with the purchase.",
            snackPosition: SnackPosition.BOTTOM);
      }
      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> buyPremium() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      Get.snackbar("Uh oh! 🐰", "The store isn't available right now.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    // Note: In a real app, you need to configure the product ID in App Store Connect / Google Play Console
    final ProductDetailsResponse response = await _iap.queryProductDetails({premiumProductId});
        
    if (response.notFoundIDs.isNotEmpty) {
      Get.snackbar("Oops! 🐰", "We couldn't find the premium upgrade.",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    final ProductDetails productDetails = response.productDetails.first;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void _unlockPremium(PurchaseDetails purchaseDetails) {
    if (!isPremium.value) {
      isPremium.value = true;
      _box.write('isPremium', true);
      Get.snackbar("Yay! 🎉", "You are now a Premium user! No more ads!",
          snackPosition: SnackPosition.TOP);
    }
  }
}
