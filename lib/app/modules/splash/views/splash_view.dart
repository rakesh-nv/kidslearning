import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF81D4FA), Color(0xFFE1F5FE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            
            // 🐰 The Magic Rabbit Mascot
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 1),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded, // Using sun first, for mascot we can use cruelty_free
                      size: 100,
                      color: Colors.orangeAccent,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 15),

            // 🐰 Rabbit Mascot Icon
            const Icon(
              Icons.cruelty_free_rounded,
              size: 120,
              color: Colors.deepPurpleAccent,
            ),
            
            const SizedBox(height: 30),

            // 🎨 Playful App Title
            const Text(
              "Magic Learning",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w900,
                color: Colors.deepPurple,
                letterSpacing: 2,
                shadows: [
                  Shadow(color: Colors.white, offset: Offset(2, 2), blurRadius: 4),
                ],
              ),
            ),
            
            const Text(
              "World 🌎",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),

            const Spacer(flex: 2),

            // 🌀 Playful loading widget
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              strokeWidth: 6,
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              "Gifts getting ready... 🎁",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
