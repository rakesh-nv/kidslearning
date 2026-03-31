import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/tts_service.dart';

class NumberItem {
  final int value;
  final String word;
  final String emoji;
  final Color color;

  NumberItem(this.value, this.word, this.emoji, this.color);
}

enum NumberGameType { findNumber, countObjects, matchShadow, nextNumber, oddOneOut }

enum NumberViewMode { selection, learn, play }

class NumbersController extends GetxController {
  final _tts = Get.find<TtsService>();
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  // Mode Selection
  final Rx<NumberViewMode> currentMode = NumberViewMode.selection.obs;

  Future<void> _speak(String text) async {
    if (isClosed) return; // controller disposed — don't speak after leaving
    await _tts.speak(text);
  }

  // Game State
  final RxBool isGameMode = false.obs;
  final RxInt score = 0.obs;
  final Rx<NumberItem?> correctItem = Rx<NumberItem?>(null);
  final RxList<NumberItem> options = <NumberItem>[].obs;
  final Rx<NumberGameType> currentGameType = NumberGameType.findNumber.obs;

  final List<NumberItem> numbers = [
    NumberItem(1, 'One', '🍎', Colors.red.shade400),
    NumberItem(2, 'Two', '⚽', Colors.blue.shade400),
    NumberItem(3, 'Three', '🐱', Colors.orange.shade400),
    NumberItem(4, 'Four', '🐶', Colors.brown.shade400),
    NumberItem(5, 'Five', '🐘', Colors.grey.shade500),
    NumberItem(6, 'Six', '🐟', Colors.lightBlue.shade400),
    NumberItem(7, 'Seven', '🍇', Colors.purple.shade400),
    NumberItem(8, 'Eight', '🎩', Colors.black54),
    NumberItem(9, 'Nine', '🍦', Colors.pink.shade400),
    NumberItem(10, 'Ten', '🧃', Colors.orangeAccent.shade400),
    NumberItem(11, 'Eleven', '🪁', Colors.green.shade400),
    NumberItem(12, 'Twelve', '🦁', Colors.amber.shade500),
    NumberItem(13, 'Thirteen', '🐵', Colors.brown.shade500),
    NumberItem(14, 'Fourteen', '🍓', Colors.pink.shade400),
    NumberItem(15, 'Fifteen', '🍊', Colors.orange.shade500),
    NumberItem(16, 'Sixteen', '🐷', Colors.pink.shade300),
    NumberItem(17, 'Seventeen', '👸', Colors.purpleAccent.shade400),
    NumberItem(18, 'Eighteen', '🐰', Colors.grey.shade400),
    NumberItem(19, 'Nineteen', '☀️', Colors.yellow.shade600),
    NumberItem(20, 'Twenty', '🚂', Colors.blueAccent.shade400),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void setMode(NumberViewMode mode) {
    currentMode.value = mode;
    isGameMode.value = (mode == NumberViewMode.play);
    if (mode == NumberViewMode.play) {
      generateQuiz();
    } else if (mode == NumberViewMode.learn) {
      speakCurrentNumber();
    }
  }

  void resetToSelection() {
    _tts.stop();
    currentMode.value = NumberViewMode.selection;
  }

  void toggleMode() {
    if (currentMode.value == NumberViewMode.selection) return;
    
    _tts.stop();
    if (currentMode.value == NumberViewMode.learn) {
      setMode(NumberViewMode.play);
    } else {
      setMode(NumberViewMode.learn);
    }
  }

  void generateQuiz() {
    final random = Random();
    final gameTypes = NumberGameType.values;
    currentGameType.value = gameTypes[random.nextInt(gameTypes.length)];
    
    int correctIndex;
    if (currentGameType.value == NumberGameType.nextNumber) {
      correctIndex = random.nextInt(numbers.length - 1) + 1;
    } else {
      correctIndex = random.nextInt(numbers.length);
    }
    
    correctItem.value = numbers[correctIndex];
    
    if (currentGameType.value == NumberGameType.oddOneOut) {
      int oddIndex = random.nextInt(numbers.length);
      while(oddIndex == correctIndex) oddIndex = random.nextInt(numbers.length);
      options.value = [numbers[correctIndex], numbers[correctIndex], numbers[oddIndex]];
      correctItem.value = numbers[oddIndex];
    } else {
      Set<int> optionIndices = {correctIndex};
      while (optionIndices.length < 3) {
        optionIndices.add(random.nextInt(numbers.length));
      }
      options.value = optionIndices.map<NumberItem>((i) => numbers[i]).toList();
    }
    options.shuffle();
    speakCurrentQuestion();
  }

  void speakCurrentQuestion() async {
    if (correctItem.value == null || currentMode.value != NumberViewMode.play) return;
    
    switch (currentGameType.value) {
      case NumberGameType.findNumber:
        await _speak("Where is the number ${correctItem.value!.value}?");
        break;
      case NumberGameType.countObjects:
        await _speak("How many objects can you count?");
        break;
      case NumberGameType.nextNumber:
        await _speak("What comes after ${numbers[numbers.indexOf(correctItem.value!) - 1].value}?");
        break;
      case NumberGameType.matchShadow:
        await _speak("Find the matching number for this shadow!");
        break;
      case NumberGameType.oddOneOut:
        await _speak("One of these is different. Can you find it?");
        break;
    }
  }

  void checkAnswer(NumberItem selected) async {
    if (selected.value == correctItem.value?.value) {
      score.value++;
      await _speak("Amazing! That is ${selected.value}");
      await Future.delayed(const Duration(seconds: 1));
      if (currentMode.value == NumberViewMode.play) {
        generateQuiz();
      }
    } else {
      await _speak("Try again!");
    }
  }

  void speakCurrentNumber() async {
    if (currentMode.value != NumberViewMode.learn) return;
    final item = numbers[currentIndex.value];
    await _speak("${item.value}. ${item.word}");
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    speakCurrentNumber();
  }

  void nextNumber() {
    if (currentIndex.value < numbers.length - 1) {
      pageController.nextPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void previousNumber() {
    if (currentIndex.value > 0) {
      pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  @override
  void onClose() {
    _tts.stop();
    pageController.dispose();
    super.onClose();
  }
}
