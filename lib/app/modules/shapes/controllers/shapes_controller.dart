import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../../services/tts_service.dart';

enum ShapeType { circle, square, triangle, star, heart, diamond, rectangle, oval, hexagon, pentagon, crescent }

enum ShapesViewMode { selection, learn, play, trace }

class ShapeItem {
  final ShapeType type;
  final String name;
  final IconData icon;
  final Color color;
  final List<String> realWorldObjects;

  ShapeItem({
    required this.type,
    required this.name,
    required this.icon,
    required this.color,
    required this.realWorldObjects,
  });
}

class ShapesController extends GetxController {
  final _tts = Get.find<TtsService>();

  final RxInt score = 0.obs;
  final Rx<ShapesViewMode> currentMode = ShapesViewMode.selection.obs;
  final RxBool showDemo = true.obs;
  
  // Learn Mode State
  final RxInt learnIndex = 0.obs;
  final PageController pageController = PageController();

  // Quiz Mode State
  final RxBool isSecondGameMode = false.obs;
  final Rx<ShapeItem?> targetShape = Rx<ShapeItem?>(null);
  final RxList<ShapeItem> options = <ShapeItem>[].obs;
  final RxString currentRealWorldObject = "".obs;

  int get correctOptionIndex => options.indexWhere((o) => o.type == targetShape.value?.type);

  final List<ShapeItem> allShapes = [
    ShapeItem(
      type: ShapeType.circle, 
      name: "Circle", 
      icon: Icons.circle, 
      color: Colors.redAccent,
      realWorldObjects: ["⚽", "🍩", "🍕", "⏰"],
    ),
    ShapeItem(
      type: ShapeType.square, 
      name: "Square", 
      icon: Icons.square, 
      color: Colors.blueAccent,
      realWorldObjects: ["🎁", "🖼️", "🧱", "🪟"],
    ),
    ShapeItem(
      type: ShapeType.triangle, 
      name: "Triangle", 
      icon: Icons.change_history_rounded, 
      color: Colors.greenAccent.shade700,
      realWorldObjects: ["📐", "🍕", "🏔️", "🏕️"],
    ),
    ShapeItem(
      type: ShapeType.star, 
      name: "Star", 
      icon: Icons.star_rounded, 
      color: Colors.orangeAccent,
      realWorldObjects: ["⭐", "🌟", "✨"],
    ),
    ShapeItem(
      type: ShapeType.heart, 
      name: "Heart", 
      icon: Icons.favorite_rounded, 
      color: Colors.pinkAccent,
      realWorldObjects: ["💖", "💗", "💝"],
    ),
    ShapeItem(
      type: ShapeType.diamond, 
      name: "Diamond", 
      icon: Icons.diamond_rounded, 
      color: Colors.cyanAccent.shade700,
      realWorldObjects: ["💎", "🪁", "🃏"],
    ),
    ShapeItem(
      type: ShapeType.rectangle, 
      name: "Rectangle", 
      icon: Icons.rectangle_rounded, 
      color: Colors.brown.shade400,
      realWorldObjects: ["🚪", "📱", "📏", "🍫"],
    ),
    ShapeItem(
      type: ShapeType.oval, 
      name: "Oval", 
      icon: Icons.egg_rounded, 
      color: Colors.orange.shade300,
      realWorldObjects: ["🥚", "🏈", "🫒", "🥏"],
    ),
    ShapeItem(
      type: ShapeType.hexagon, 
      name: "Hexagon", 
      icon: Icons.hexagon_rounded, 
      color: Colors.blueGrey,
      realWorldObjects: ["🍯", "🛑", "❄️"],
    ),
    ShapeItem(
      type: ShapeType.pentagon, 
      name: "Pentagon", 
      icon: Icons.pentagon_rounded, 
      color: Colors.amber.shade900,
      realWorldObjects: ["🏠", "⚽"], // soccer balls have pentagons
    ),
    ShapeItem(
      type: ShapeType.crescent, 
      name: "Crescent", 
      icon: Icons.brightness_3_rounded, 
      color: Colors.yellow.shade400,
      realWorldObjects: ["🌙", "🍌", "🥐"],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Do NOT call generateLevel() here — the user is on the selection screen.
    // Speech should only start when the user picks Learn or Play.
  }

  Future<void> speak(String text) async {
    if (isClosed) return; // controller disposed — don't speak after leaving
    await _tts.speak(text);
  }

  void setMode(ShapesViewMode mode) {
    currentMode.value = mode;
    score.value = 0;
    if (mode == ShapesViewMode.learn) {
      learnIndex.value = 0;
      Future.delayed(const Duration(milliseconds: 500), () {
        speakShape(allShapes[0]);
      });
    } else if (mode == ShapesViewMode.play) {
      generateLevel();
    }
  }

  void resetToSelection() {
    currentMode.value = ShapesViewMode.selection;
  }

  void speakShape(ShapeItem item) {
    speak(item.name);
  }

  void onPageChanged(int index) {
    learnIndex.value = index;
    speakShape(allShapes[index]);
  }

  void nextShape() {
    if (learnIndex.value < allShapes.length - 1) {
      if (pageController.hasClients) {
        pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        learnIndex.value++;
      }
    }
  }

  void previousShape() {
    if (learnIndex.value > 0) {
      if (pageController.hasClients) {
        pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      } else {
        learnIndex.value--;
      }
    }
  }

  void generateLevel() {
    final random = Random();
    
    // Toggle game type
    isSecondGameMode.value = random.nextBool();

    final target = allShapes[random.nextInt(allShapes.length)];
    targetShape.value = target;

    if (isSecondGameMode.value) {
      currentRealWorldObject.value = target.realWorldObjects[random.nextInt(target.realWorldObjects.length)];
      options.value = List.from(allShapes)..shuffle();
      options.value = options.take(4).toList();
      if (!options.contains(target)) {
        options[random.nextInt(4)] = target;
      }
      // Don't say the shape name — that gives away the answer!
      speak("What shape is this?");
    } else {
      options.value = List.from(allShapes)..shuffle();
      options.value = options.take(4).toList();
      if (!options.contains(target)) {
        options[random.nextInt(4)] = target;
      }
      // Don't say the shape name — that gives away the answer!
      speak("Can you find and match this shape?");
    }
  }

  void onMatched(ShapeItem dropped) async {
    if (dropped.type == targetShape.value?.type) {
      if (showDemo.value) showDemo.value = false;
      score.value++;
      await speak("Great job! That is a ${dropped.name}.");
      generateLevel();
    } else {
      await speak("Try again, find the ${targetShape.value?.name}.");
    }
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
