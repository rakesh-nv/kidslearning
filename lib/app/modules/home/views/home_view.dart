import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/app_settings_controller.dart';
import '../../../controllers/monetization_controller.dart';
import '../../../widgets/bounceable.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  void _showSettings(BuildContext context) {
    final settings = Get.find<AppSettingsController>();
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 25),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              "Settings ⚙️",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 30),
            Obx(
              () => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: settings.isSoundEnabled.value
                        ? Colors.blueAccent.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    settings.isSoundEnabled.value
                        ? Icons.record_voice_over_rounded
                        : Icons.voice_over_off_rounded,
                    color: settings.isSoundEnabled.value
                        ? Colors.blueAccent
                        : Colors.grey,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Learning Voice",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Turn on/off study reading"),
                trailing: Switch(
                  value: settings.isSoundEnabled.value,
                  onChanged: (v) {
                    controller.speak("Voice ${v ? 'On' : 'Off'}");
                    settings.toggleSound(v);
                  },
                  activeColor: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: settings.isButtonSoundEnabled.value
                        ? Colors.orangeAccent.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    settings.isButtonSoundEnabled.value
                        ? Icons.touch_app_rounded
                        : Icons.do_not_touch_rounded,
                    color: settings.isButtonSoundEnabled.value
                        ? Colors.orangeAccent
                        : Colors.grey,
                    size: 30,
                  ),
                ),
                title: const Text(
                  "Button Sounds",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text("Enable clicking sounds"),
                trailing: Switch(
                  value: settings.isButtonSoundEnabled.value,
                  onChanged: settings.toggleButtonSound,
                  activeColor: Colors.orangeAccent,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final monetization = Get.find<MonetizationController>();

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 Playful Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5), Color(0xFFFFF3E0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          
          // ☁️ Abstract Decorative Shapes
          Positioned(
            top: -50,
            right: -50,
            child: _buildBubble(200, Colors.blueAccent.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: _buildBubble(300, Colors.pinkAccent.withOpacity(0.08)),
          ),
          Positioned(
            top: 400,
            right: -80,
            child: _buildBubble(150, Colors.orangeAccent.withOpacity(0.05)),
          ),

          SafeArea(
            child: Column(
              children: [
                /// 🌈 HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HAPPY LEARNING! 🎨",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Colors.blue.shade700,
                              letterSpacing: 2,
                            ),
                          ),
                          const Text(
                            "Let's Play",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2D3142),
                            ),
                          ),
                        ],
                      ),
                      Bounceable(
                        onTap: () => _showSettings(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: const Icon(Icons.settings_rounded, size: 30, color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ),

                /// 📚 ACTIVITY GRID
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    child: Column(
                      children: [
                        // 🌟 HERO ACTIVITY (ABC)
                        _buildHeroCard(
                          title: "ABC Learning",
                          subtitle: "Learn Letters with Fun!",
                          emoji: "🔤",
                          color: Colors.lightBlue,
                          onTap: () {
                             controller.speak("Let's learn the Alphabet!");
                             Get.toNamed('/alphabet');
                          }
                        ),
                        
                        const SizedBox(height: 20),

                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 18,
                          mainAxisSpacing: 18,
                          childAspectRatio: 0.88,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildGridCard("Numbers", "🔢", Colors.orangeAccent, () {
                              controller.speak("Numbers!");
                              Get.toNamed('/numbers');
                            }),
                            _buildGridCard("Shapes", "🟠", Colors.pinkAccent, () {
                              controller.speak("Shapes!");
                              Get.toNamed('/shapes');
                            }),
                            _buildGridCard("Fruits", "🍎", Colors.lightGreen, () {
                              controller.speak("Fruits!");
                              Get.toNamed('/fruits');
                            }),
                            _buildGridCard("Puzzles", "🧩", Colors.purpleAccent, () {
                              controller.speak("Puzzles!");
                              Get.toNamed('/puzzle');
                            }),
                            _buildGridCard("Colors", "🎨", Colors.tealAccent, () => controller.speak("Colors!")),
                            
                            // SHADOW MATCH (REWARDED)
                            Obx(() {
                              final isLocked = !monetization.isPremium;
                              return _buildGridCard(
                                isLocked ? "Shadows 🎁" : "Shadow Match", 
                                "👻", 
                                Colors.indigoAccent, 
                                () {
                                  if (!isLocked) {
                                    controller.speak("Shadow Match!");
                                    Get.toNamed('/shadow-match');
                                  } else {
                                    monetization.attemptUnlockWithReward(
                                      onSuccess: () => Get.toNamed('/shadow-match')
                                    );
                                  }
                                }
                              );
                            }),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// 💎 PREMIUM BANNER
                        Obx(() {
                           if (monetization.isPremium) {
                             return Container(
                               padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                               decoration: BoxDecoration(
                                 color: Colors.amber.shade100,
                                 borderRadius: BorderRadius.circular(30),
                                 border: Border.all(color: Colors.amber.shade300, width: 2),
                               ),
                               child: const Row(
                                 children: [
                                   Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 40),
                                   SizedBox(width: 15),
                                   Text("Premium Hero 🛡️", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                                 ],
                               ),
                             );
                           }

                           return Bounceable(
                             onTap: () => monetization.attemptPremiumAction(onSuccess: () {}),
                             child: Container(
                               padding: const EdgeInsets.all(25),
                               decoration: BoxDecoration(
                                 gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
                                 borderRadius: BorderRadius.circular(35),
                                 boxShadow: [
                                   BoxShadow(color: Colors.purple.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                                 ],
                               ),
                               child: const Row(
                                 children: [
                                   Icon(Icons.stars_rounded, color: Colors.white, size: 50),
                                   SizedBox(width: 15),
                                   Expanded(
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Text("GO PREMIUM! 💎", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                                         Text("Unlock all games & Remove ads", style: TextStyle(color: Colors.white70, fontSize: 13)),
                                       ],
                                     ),
                                   ),
                                   Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 20),
                                 ],
                               ),
                             ),
                           );
                        }),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildHeroCard({
    required String title,
    required String subtitle,
    required String emoji,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Text(emoji, style: const TextStyle(fontSize: 60)),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(String title, String emoji, Color color, VoidCallback onTap) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 42)),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
