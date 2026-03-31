import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/tts_service.dart';

class MatchItem {
  final String name;
  final String emoji;
  final Color color;

  MatchItem(this.name, this.emoji, this.color);
}

class ShadowMatchController extends GetxController {
  final _tts = Get.find<TtsService>();

  final RxInt score = 0.obs;
  final RxBool showDemo = true.obs;
  final Rx<MatchItem?> targetItem = Rx<MatchItem?>(null);
  final RxList<MatchItem> options = <MatchItem>[].obs;

  int get correctOptionIndex => options.indexOf(targetItem.value!);

  final List<MatchItem> allItems = [
    MatchItem('Apple', '🍎', Colors.red.shade400),
    MatchItem('Banana', '🍌', Colors.yellow.shade600),
    MatchItem('Orange', '🍊', Colors.orange.shade500),
    MatchItem('Cat', '🐱', Colors.orangeAccent),
    MatchItem('Dog', '🐶', Colors.brown.shade400),
    MatchItem('Elephant', '🐘', Colors.grey.shade500),
    MatchItem('Fish', '🐟', Colors.lightBlue.shade400),
    MatchItem('Frog', '🐸', Colors.green.shade500),
    MatchItem('Car', '🚗', Colors.redAccent),
    MatchItem('Train', '🚂', Colors.blue.shade600),
    MatchItem('Pineapple', '🍍', Colors.yellow.shade700),
    MatchItem('Strawberry', '🍓', Colors.pink.shade400),
  ];

  @override
  void onInit() {
    super.onInit();
    generateLevel();
  }

  Future<void> _speak(String text) async {
    if (isClosed) return; // controller disposed — don't speak after leaving
    await _tts.speak(text);
  }

  void generateLevel() {
    final random = Random();
    final correctIndex = random.nextInt(allItems.length);
    targetItem.value = allItems[correctIndex];

    Set<int> optionIndices = {correctIndex};
    while (optionIndices.length < 4) {
      optionIndices.add(random.nextInt(allItems.length));
    }

    options.value = optionIndices.map((i) => allItems[i]).toList();
    options.shuffle();

    Future.delayed(const Duration(milliseconds: 500), () {
      _speak("Find the shadow!");
    });
  }

  void onMatched(MatchItem dropped) async {
    if (dropped.name == targetItem.value?.name) {
      if (showDemo.value) showDemo.value = false;
      score.value++;
      await _speak("Awesome! That is a ${dropped.name}.");
      generateLevel();
    } else {
      await _speak("Oops! Try again.");
    }
  }

  @override
  void onClose() {
    _tts.stop();
    super.onClose();
  }
}
