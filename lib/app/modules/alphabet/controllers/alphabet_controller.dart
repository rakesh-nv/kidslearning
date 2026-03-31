import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/tts_service.dart';

class AlphabetItem {
  final String letter;
  final String word;
  final String emoji;
  final Color color;

  AlphabetItem(this.letter, this.word, this.emoji, this.color);
}

enum AlphabetGameType {
  findLetter,
  guessObject,
  matchShadow,
  firstLetter,
  upperToLower,
  completeSequence,
  missingLetter,
  listenAndPick,
  matchEmojiToWord,
  oddOneOut,
}

enum AlphabetViewMode { selection, learn, play, special, trace }

class AlphabetController extends GetxController {
  final _tts = Get.find<TtsService>();
  final PageController pageController = PageController();
  var currentIndex = 0.obs;

  // Mode Selection
  final Rx<AlphabetViewMode> currentMode = AlphabetViewMode.selection.obs;

  Future<void> _speak(String text) async {
    if (isClosed) return; // controller disposed — don't speak after leaving
    await _tts.speak(text);
  }

  // Game State
  final RxBool isGameMode = false.obs;
  final RxInt score = 0.obs;
  final Rx<AlphabetItem?> correctItem = Rx<AlphabetItem?>(null);
  final RxList<AlphabetItem> options = <AlphabetItem>[].obs;
  final Rx<AlphabetGameType> currentGameType = AlphabetGameType.findLetter.obs;

  // Tracing State
  final RxList<Offset?> tracePoints = <Offset?>[].obs;

  void addTracePoint(Offset? point) {
    tracePoints.add(point);
  }

  void clearTracePoints() {
    tracePoints.clear();
  }

  final List<AlphabetItem> alphabets = [
    AlphabetItem('A', 'Apple', '🍎', Colors.red.shade400),
    AlphabetItem('B', 'Ball', '⚽', Colors.blue.shade400),
    AlphabetItem('C', 'Cat', '🐱', Colors.orange.shade400),
    AlphabetItem('D', 'Dog', '🐶', Colors.brown.shade400),
    AlphabetItem('E', 'Elephant', '🐘', Colors.grey.shade500),
    AlphabetItem('F', 'Fish', '🐟', Colors.lightBlue.shade400),
    AlphabetItem('G', 'Grapes', '🍇', Colors.purple.shade400),
    AlphabetItem('H', 'Hat', '🎩', Colors.black54),
    AlphabetItem('I', 'Ice Cream', '🍦', Colors.pink.shade400),
    AlphabetItem('J', 'Juice', '🧃', Colors.orangeAccent.shade400),
    AlphabetItem('K', 'Kite', '🪁', Colors.green.shade400),
    AlphabetItem('L', 'Lion', '🦁', Colors.amber.shade500),
    AlphabetItem('M', 'Monkey', '🐵', Colors.brown.shade500),
    AlphabetItem('N', 'Net', '🥅', Colors.orange.shade400),
    AlphabetItem('O', 'Orange', '🍊', Colors.orange.shade500),
    AlphabetItem('P', 'Pig', '🐷', Colors.pink.shade300),
    AlphabetItem('Q', 'Queen', '👸', Colors.purpleAccent.shade400),
    AlphabetItem('R', 'Rabbit', '🐰', Colors.grey.shade400),
    AlphabetItem('S', 'Sun', '☀️', Colors.yellow.shade600),
    AlphabetItem('T', 'Train', '🚂', Colors.blueAccent.shade400),
    AlphabetItem('U', 'Umbrella', '☂️', Colors.deepPurple.shade400),
    AlphabetItem('V', 'Van', '🚐', Colors.teal.shade400),
    AlphabetItem('W', 'Watermelon', '🍉', Colors.green.shade500),
    AlphabetItem('X', 'Xylophone', '🎹', Colors.blueGrey.shade400),
    AlphabetItem('Y', 'Yak', '🐂', Colors.brown.shade600),
    AlphabetItem('Z', 'Zebra', '🦓', Colors.black87),
  ];

  @override
  void onInit() {
    super.onInit();
  }

  void setMode(AlphabetViewMode mode) {
    currentMode.value = mode;
    isGameMode.value = (mode == AlphabetViewMode.play || mode == AlphabetViewMode.special);
    if (isGameMode.value) {
      generateQuiz();
    } else if (mode == AlphabetViewMode.learn || mode == AlphabetViewMode.trace) {
      speakCurrentLetter();
    }
  }

  void resetToSelection() {
    _tts.stop();
    currentMode.value = AlphabetViewMode.selection;
  }

  void toggleMode() {
    if (currentMode.value == AlphabetViewMode.selection) return;

    _tts.stop();
    if (currentMode.value == AlphabetViewMode.learn) {
      setMode(AlphabetViewMode.play);
    } else if (currentMode.value == AlphabetViewMode.play) {
      setMode(AlphabetViewMode.trace);
    } else {
      setMode(AlphabetViewMode.learn);
    }
  }

  void generateQuiz() {
    final random = Random();
    
    if (currentMode.value == AlphabetViewMode.special) {
      // Special mode only does Match Word and Odd One Out
      currentGameType.value = random.nextBool() ? AlphabetGameType.matchEmojiToWord : AlphabetGameType.oddOneOut;
    } else {
      final gameTypes = AlphabetGameType.values.where((t) => t != AlphabetGameType.matchEmojiToWord && t != AlphabetGameType.oddOneOut).toList();
      currentGameType.value = gameTypes[random.nextInt(gameTypes.length)];
    }

    // Some games need specific indices
    int correctIndex;
    if (currentGameType.value == AlphabetGameType.completeSequence) {
      // Ensure there are at least 2 letters before the correct one
      correctIndex = random.nextInt(alphabets.length - 2) + 2;
    } else {
      correctIndex = random.nextInt(alphabets.length);
    }

    correctItem.value = alphabets[correctIndex];

    if (currentGameType.value == AlphabetGameType.oddOneOut) {
      int oddIndex = random.nextInt(alphabets.length);
      while(oddIndex == correctIndex) oddIndex = random.nextInt(alphabets.length);
      
      // options will have 2 same and 1 different. The odd one is the answer.
      correctItem.value = alphabets[oddIndex];
      options.value = [alphabets[correctIndex], alphabets[correctIndex], alphabets[oddIndex]];
    } else {
      Set<int> optionIndices = {correctIndex};
      while (optionIndices.length < 3) {
        optionIndices.add(random.nextInt(alphabets.length));
      }
      options.value = optionIndices.map<AlphabetItem>((i) => alphabets[i]).toList();
    }
    
    options.shuffle();
    speakCurrentQuestion();
  }

  void speakCurrentQuestion() async {
    if (correctItem.value == null || !isGameMode.value)
      return;

    switch (currentGameType.value) {
      case AlphabetGameType.findLetter:
        await _speak("Where is the letter ${correctItem.value!.letter}?");
        break;
      case AlphabetGameType.guessObject:
        await _speak("Find the ${correctItem.value!.word}");
        break;
      case AlphabetGameType.matchShadow:
        await _speak("Can you find the match for this shadow?");
        break;
      case AlphabetGameType.firstLetter:
        await _speak("What is the first letter of ${correctItem.value!.word}?");
        break;
      case AlphabetGameType.upperToLower:
        await _speak("Find the small letter for ${correctItem.value!.letter}");
        break;
      case AlphabetGameType.completeSequence:
        final idx = alphabets.indexOf(correctItem.value!);
        await _speak(
          "${alphabets[idx - 2].letter}, ${alphabets[idx - 1].letter}. What comes next?",
        );
        break;
      case AlphabetGameType.missingLetter:
        await _speak(
          "Which letter is missing in the word ${correctItem.value!.word}?",
        );
        break;
      case AlphabetGameType.listenAndPick:
        await _speak(
          "Listen carefully. Can you find the letter ${correctItem.value!.letter}?",
        );
        break;
      case AlphabetGameType.matchEmojiToWord:
        await _speak("Which word matches this picture?");
        break;
      case AlphabetGameType.oddOneOut:
        await _speak("One of these is different. Can you find it?");
        break;
    }
  }

  void checkAnswer(AlphabetItem selected) async {
    if (selected.letter == correctItem.value?.letter) {
      score.value++;
      switch (currentGameType.value) {
        case AlphabetGameType.findLetter:
          await _speak("Good job! That's ${selected.letter}");
          break;
        case AlphabetGameType.guessObject:
          await _speak("Exactly! ${selected.emoji} is for ${selected.word}");
          break;
        case AlphabetGameType.matchShadow:
          await _speak("Perfect match! ${selected.emoji}");
          break;
        case AlphabetGameType.firstLetter:
          await _speak(
            "You got it! ${selected.letter} is for ${correctItem.value!.word}",
          );
          break;
        case AlphabetGameType.upperToLower:
          await _speak(
            "Correct! Small ${selected.letter.toLowerCase()} for big ${selected.letter}",
          );
          break;
        case AlphabetGameType.completeSequence:
          await _speak(
            "Amazing! ${selected.letter} comes after ${alphabets[alphabets.indexOf(selected) - 1].letter}",
          );
          break;
        case AlphabetGameType.missingLetter:
          await _speak(
            "Well done! ${correctItem.value!.word} starts with ${selected.letter}",
          );
          break;
        case AlphabetGameType.listenAndPick:
          await _speak("Yes! That was the letter ${selected.letter}");
          break;
        case AlphabetGameType.matchEmojiToWord:
          await _speak("Right! That is ${selected.word}");
          break;
        case AlphabetGameType.oddOneOut:
          await _speak("You found it! ${selected.letter} was the different one");
          break;
      }
      await Future.delayed(const Duration(seconds: 1));
      if (isGameMode.value) {
        generateQuiz();
      }
    } else {
      await _speak("Try again!");
    }
  }

  void speakCurrentLetter() async {
    if (currentMode.value != AlphabetViewMode.learn && currentMode.value != AlphabetViewMode.trace) return;
    final item = alphabets[currentIndex.value];
    if (currentMode.value == AlphabetViewMode.trace) {
      await _speak("Let's trace the letter ${item.letter}");
    } else {
      await _speak("${item.letter} for ${item.word}");
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
    clearTracePoints();
    speakCurrentLetter();
  }

  void nextLetter() {
    if (currentIndex.value < alphabets.length - 1) {
      if (pageController.hasClients) {
        pageController.nextPage(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        onPageChanged(currentIndex.value + 1);
      }
    }
  }

  void previousLetter() {
    if (currentIndex.value > 0) {
      if (pageController.hasClients) {
        pageController.previousPage(
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      } else {
        onPageChanged(currentIndex.value - 1);
      }
    }
  }

  @override
  void onClose() {
    _tts.stop();
    pageController.dispose();
    super.onClose();
  }
}
