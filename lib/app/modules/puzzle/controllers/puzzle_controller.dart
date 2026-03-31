import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../services/tts_service.dart';

class ShapeItem {
  final String name;
  final IconData icon;
  final Color color;

  ShapeItem(this.name, this.icon, this.color);
}

class PuzzleController extends GetxController {
  final _tts = Get.find<TtsService>();
  
  final List<ShapeItem> allShapes = [
    ShapeItem('Circle', Icons.circle, Colors.redAccent),
    ShapeItem('Square', Icons.square, Colors.blueAccent),
    ShapeItem('Triangle', Icons.change_history, Colors.greenAccent),
    ShapeItem('Star', Icons.star, Colors.orangeAccent),
  ];

  final RxMap<String, bool> matchedShapes = <String, bool>{}.obs;
  final RxList<ShapeItem> shuffledShapes = <ShapeItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    resetGame();
  }

  Future<void> _speak(String text) async {
    if (isClosed) return; // controller disposed — don't speak after leaving
    await _tts.speak(text);
  }

  void resetGame() {
    matchedShapes.clear();
    for (var shape in allShapes) {
      matchedShapes[shape.name] = false;
    }
    shuffledShapes.assignAll(List.from(allShapes)..shuffle());
    _speak("Let's match the shapes!");
  }

  void onShapeDropped(String shapeName) async {
    if (matchedShapes.containsKey(shapeName)) {
      matchedShapes[shapeName] = true;
      await _speak("Great! That's a $shapeName");
      
      if (isGameComplete) {
        await Future.delayed(const Duration(seconds: 1));
        await _speak("Awesome! You matched all the shapes!");
      }
    }
  }

  bool get isGameComplete => matchedShapes.values.every((matched) => matched);

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}

