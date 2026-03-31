import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bounceable.dart';
import '../../../widgets/ad_banner_widget.dart';
import '../../../controllers/monetization_controller.dart';
import '../controllers/alphabet_controller.dart';

class AlphabetView extends GetView<AlphabetController> {
  const AlphabetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Obx(() {
          switch (controller.currentMode.value) {
            case AlphabetViewMode.selection:
              return const Text(
                'ABC Learning',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              );
            case AlphabetViewMode.learn:
              return const Text(
                'Learn Alphabet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              );
            case AlphabetViewMode.play:
              return const Text(
                'ABC Game',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              );
            case AlphabetViewMode.special:
              return const Text(
                'Word Master',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              );
            case AlphabetViewMode.trace:
              return const Text(
                'Magic Tracer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              );
          }
        }),
        leading: Obx(() {
          if (controller.currentMode.value == AlphabetViewMode.selection) {
            return IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            );
          } else {
            return IconButton(
              onPressed: controller.resetToSelection,
              icon: const Icon(Icons.close_rounded),
            );
          }
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          Obx(() {
            if (controller.currentMode.value == AlphabetViewMode.selection) {
              return const SizedBox();
            }
            return IconButton(
              onPressed: controller.toggleMode,
              icon: Icon(
                controller.currentMode.value == AlphabetViewMode.play
                    ? Icons.menu_book_rounded
                    : Icons.extension_rounded,
                color: Colors.orangeAccent,
              ),
              tooltip: 'Switch Mode',
            );
          }),
        ],
      ),
      body: Obx(() {
        switch (controller.currentMode.value) {
          case AlphabetViewMode.selection:
            return _buildSelectionView(context);
          case AlphabetViewMode.learn:
            return _buildLearnMode();
          case AlphabetViewMode.play:
            return _buildQuizMode(context);
          case AlphabetViewMode.special:
            return _buildQuizMode(context);
          case AlphabetViewMode.trace:
            return _buildTraceMode();
        }
      }),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFF0F4F8), Colors.blue.withOpacity(0.05)],
        ),
      ),
      child: Stack(
        children: [
          // Background accents
          Positioned(
            top: -30,
            right: -30,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.blueAccent.withOpacity(0.05),
            ),
          ),
          
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ABC Playground! 🎡",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        "Choose Your Journey",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildSelectionCard(
                        title: "Learn ABC",
                        subtitle: "Fun World",
                        icon: Icons.auto_stories_rounded,
                        emoji: "📚",
                        color: const Color(0xFF4A90E2),
                        secondaryColor: const Color(0xFF357ABD),
                        onTap: () => controller.setMode(AlphabetViewMode.learn),
                      ),
                      _buildSelectionCard(
                        title: "Challenge",
                        subtitle: "Win Stars!",
                        icon: Icons.videogame_asset_rounded,
                        emoji: "🏆",
                        color: const Color(0xFFFF9F1C),
                        secondaryColor: const Color(0xFFE08E19),
                        onTap: () => controller.setMode(AlphabetViewMode.play),
                      ),
                      Obx(() {
                        final monetization = Get.find<MonetizationController>();
                        final isUnlocked = monetization.isPremium;
                        return _buildSelectionCard(
                          title: "Word Wizard",
                          subtitle: isUnlocked ? "Puzzles" : "Watch Ad",
                          icon: Icons.auto_awesome_rounded,
                          emoji: "🧙",
                          color: const Color(0xFF9B51E0),
                          secondaryColor: const Color(0xFF7E3FB8),
                          onTap: () {
                            if (isUnlocked) {
                              controller.setMode(AlphabetViewMode.special);
                            } else {
                              monetization.attemptUnlockWithReward(
                                onSuccess: () => controller.setMode(AlphabetViewMode.special)
                              );
                            }
                          },
                        );
                      }),
                      Obx(() {
                        final monetization = Get.find<MonetizationController>();
                        final isUnlocked = monetization.isPremium;
                        return _buildSelectionCard(
                          title: "Magic Tracer",
                          subtitle: isUnlocked ? "Draw!" : "Watch Ad",
                          icon: Icons.gesture_rounded,
                          emoji: "🎨",
                          color: const Color(0xFF2EC4B6),
                          secondaryColor: const Color(0xFF23968B),
                          onTap: () {
                            if (isUnlocked) {
                              controller.setMode(AlphabetViewMode.trace);
                            } else {
                              monetization.attemptUnlockWithReward(
                                onSuccess: () => controller.setMode(AlphabetViewMode.trace)
                              );
                            }
                          },
                        );
                      }),
                    ],
                  ),
                ),
                const AdBannerWidget(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String emoji,
    required Color color,
    required Color secondaryColor,
    required VoidCallback onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: LinearGradient(
            colors: [color, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: Stack(
            children: [
              // Bubble Accent
              Positioned(
                top: -10,
                left: -10,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.1),
                ),
              ),
              Positioned(
                right: -15,
                top: -10,
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 70),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(icon, color: Colors.white, size: 28),
                    ),
                    const Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLearnMode() {
    return Stack(
      children: [
        // Dynamic background based on current item
        Obx(() {
          final color =
              controller.alphabets[controller.currentIndex.value].color;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withOpacity(0.1), Colors.white],
              ),
            ),
          );
        }),

        // Decorative floating circles
        Positioned(
          top: 40,
          left: -20,
          child: _buildAnimatedDecoration(Colors.blue.withOpacity(0.1), 100),
        ),
        Positioned(
          top: 200,
          right: -30,
          child: _buildAnimatedDecoration(Colors.orange.withOpacity(0.1), 150),
        ),
        Positioned(
          bottom: 150,
          left: 40,
          child: _buildAnimatedDecoration(Colors.purple.withOpacity(0.1), 80),
        ),

        Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.alphabets.length,
                itemBuilder: (context, index) {
                  final item = controller.alphabets[index];
                  return AnimatedBuilder(
                    animation: controller.pageController,
                    builder: (context, child) {
                      double value = 0;
                      if (controller.pageController.position.haveDimensions) {
                        value = (controller.pageController.page ?? 0) - index;
                      }
                      value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);

                      return Center(
                        child: Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value,
                            child: _buildModernLearnCard(item),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Navigation and Progress
            _buildModernControls(),
            const AdBannerWidget(), // Added Ad
            const SizedBox(height: 20),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedDecoration(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildModernLearnCard(AlphabetItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: 260, // 💡 Smaller & easier for kids to focus on
      constraints: const BoxConstraints(maxHeight: 440),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.15),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🚀 Big Letter Button!
          Expanded(
            flex: 6,
            child: Bounceable(
              onTap: controller.speakCurrentLetter,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(45),
                    bottom: Radius.circular(80),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [item.color, item.color.withOpacity(0.8)],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'letter-${item.letter}',
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Decorative sparkles
                        Positioned(
                          top: 20,
                          right: 20,
                          child: Icon(Icons.stars_rounded, color: Colors.white.withOpacity(0.2), size: 40),
                        ),
                        Positioned(
                          bottom: 30,
                          left: 30,
                          child: Icon(Icons.bubble_chart_rounded, color: Colors.white.withOpacity(0.2), size: 30),
                        ),
                        
                        Text(
                          item.letter,
                          style: const TextStyle(
                            fontSize: 150,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                offset: Offset(4, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // 🍎 Big Emoji Button!
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Bounceable(
                  onTap: controller.speakCurrentLetter,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: item.color.withOpacity(0.08),
                      shape: BoxShape.circle,
                      border: Border.all(color: item.color.withOpacity(0.1), width: 2),
                    ),
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 75),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.word.toUpperCase(),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: item.color,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleNavButton(
            icon: Icons.chevron_left_rounded,
            onPressed: controller.previousLetter,
            color: Colors.grey.shade400,
          ),
          Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${controller.currentIndex.value + 1} / 26",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 100,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (controller.currentIndex.value + 1) / 26,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller
                            .alphabets[controller.currentIndex.value]
                            .color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
          _buildCircleNavButton(
            icon: Icons.chevron_right_rounded,
            onPressed: controller.nextLetter,
            color: Colors.blueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildCircleNavButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Bounceable(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 32),
      ),
    );
  }

  Widget _buildQuizMode(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFFF0F4F8), Colors.blue.withOpacity(0.05)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Improved Score Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Colors.orangeAccent,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Text(
                      "SCORE: ${controller.score.value}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2D3142),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Question Text
            Obx(
              () => Text(
                _getQuestionText(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // Question Display (Emoji, Letter, or Shadow)
            Obx(
              () => Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (controller.correctItem.value?.color ?? Colors.blue)
                              .withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(child: _buildQuestionMainDisplay()),
              ),
            ),

            const SizedBox(height: 40),

            // Options Grid
            Expanded(
              child: Obx(
                () => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: controller.options.length,
                  itemBuilder: (context, index) {
                    final item = controller.options[index];
                    return _buildOptionCard(item);
                  },
                ),
              ),
            ),

            // Bottom Control
            _buildListenButton(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(AlphabetItem item) {
    return Bounceable(
      onTap: () => controller.checkAnswer(item),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _getOptionText(item),
            style: TextStyle(
              fontSize: _getOptionSize(),
              fontWeight: FontWeight.bold,
              color: item.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListenButton() {
    return Bounceable(
      onTap: controller.speakCurrentQuestion,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.orangeAccent, Colors.orange],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.volume_up_rounded, color: Colors.white, size: 28),
            SizedBox(width: 12),
            Text(
              "LISTEN",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getQuestionText() {
    switch (controller.currentGameType.value) {
      case AlphabetGameType.findLetter:
        return "Which letter is this?";
      case AlphabetGameType.guessObject:
        return "Find the ${controller.correctItem.value?.word}!";
      case AlphabetGameType.matchShadow:
        return "Match the shadow!";
      case AlphabetGameType.firstLetter:
        return "Which letter starts the word?";
      case AlphabetGameType.upperToLower:
        return "Find the small letter!";
      case AlphabetGameType.completeSequence:
        return "What comes next?";
      case AlphabetGameType.missingLetter:
        return "Find the missing letter!";
      case AlphabetGameType.listenAndPick:
        return "Listen and Pick!";
      case AlphabetGameType.matchEmojiToWord:
        return "Which word is this?";
      case AlphabetGameType.oddOneOut:
        return "Which one is different?";
    }
  }

  Widget _buildQuestionMainDisplay() {
    final item = controller.correctItem.value;
    if (item == null) return const SizedBox();

    switch (controller.currentGameType.value) {
      case AlphabetGameType.findLetter:
        return Text(
          item.letter,
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w900,
            color: Colors.blueAccent,
          ),
        );
      case AlphabetGameType.guessObject:
        return Text(
          item.word,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w900,
            color: Colors.blueAccent,
          ),
        );
      case AlphabetGameType.matchShadow:
        return ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
          child: Text(item.emoji, style: const TextStyle(fontSize: 100)),
        );
      case AlphabetGameType.firstLetter:
        return Text(item.emoji, style: const TextStyle(fontSize: 100));
      case AlphabetGameType.upperToLower:
        return Text(
          item.letter,
          style: const TextStyle(
            fontSize: 100,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        );
      case AlphabetGameType.completeSequence:
        final idx = controller.alphabets.indexOf(item);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${controller.alphabets[idx - 2].letter}, ",
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            Text(
              "${controller.alphabets[idx - 1].letter}, ",
              style: const TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const Text(
              "?",
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
          ],
        );
      case AlphabetGameType.missingLetter:
        final word = item.word.toUpperCase();
        return Text(
          "_ ${word.substring(1)}",
          style: const TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.w900,
            letterSpacing: 8,
            color: Colors.blueAccent,
          ),
        );
      case AlphabetGameType.listenAndPick:
        return const Icon(
          Icons.volume_up_rounded,
          size: 100,
          color: Colors.orangeAccent,
        );
      case AlphabetGameType.matchEmojiToWord:
        return Text(item.emoji, style: const TextStyle(fontSize: 100));
      case AlphabetGameType.oddOneOut:
        return const Text("🤔", style: TextStyle(fontSize: 100));
    }
  }

  String _getOptionText(AlphabetItem item) {
    switch (controller.currentGameType.value) {
      case AlphabetGameType.findLetter:
        return item.letter;
      case AlphabetGameType.firstLetter:
        return item.letter;
      case AlphabetGameType.guessObject:
        return item.emoji;
      case AlphabetGameType.matchShadow:
        return item.emoji;
      case AlphabetGameType.upperToLower:
        return item.letter.toLowerCase();
      case AlphabetGameType.completeSequence:
        return item.letter;
      case AlphabetGameType.missingLetter:
        return item.letter;
      case AlphabetGameType.listenAndPick:
        return item.letter;
      case AlphabetGameType.matchEmojiToWord:
        return item.word;
      case AlphabetGameType.oddOneOut:
        return item.emoji;
    }
  }

  double _getOptionSize() {
    switch (controller.currentGameType.value) {
      case AlphabetGameType.findLetter:
        return 50;
      case AlphabetGameType.firstLetter:
        return 50;
      case AlphabetGameType.guessObject:
        return 60;
      case AlphabetGameType.matchShadow:
        return 60;
      case AlphabetGameType.upperToLower:
        return 50;
      case AlphabetGameType.completeSequence:
        return 50;
      case AlphabetGameType.missingLetter:
        return 50;
      case AlphabetGameType.listenAndPick:
        return 50;
      case AlphabetGameType.matchEmojiToWord:
        return 22;
      case AlphabetGameType.oddOneOut:
        return 60;
    }
  }

  Widget _buildTraceMode() {
    final alphabet = controller.alphabets[controller.currentIndex.value];

    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Stack(
              children: [
                // Background Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: alphabet.color.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Opacity(
                      opacity: 0.1,
                      child: Text(
                        alphabet.letter,
                        style: const TextStyle(
                          fontSize: 350,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),

                // Drawing Layer
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onPanUpdate: (details) {
                          // Get local position within the card
                          controller.addTracePoint(details.localPosition);
                        },
                        onPanEnd: (details) => controller.addTracePoint(null),
                        child: Obx(() {
                          // Explicitly call toList() to ensure GetX observes changes to the RxList
                          final points = controller.tracePoints.toList();
                          return CustomPaint(
                            painter: TracingPainter(
                              points: points,
                              color: alphabet.color,
                              letter: alphabet.letter,
                            ),
                            size: Size.infinite,
                          );
                        }),
                      );
                    },
                  ),
                ),

                // Content overlay (Title)
                Positioned(
                  top: 20,
                  left: 30,
                  child: Text(
                    "Trace: ${alphabet.letter}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: alphabet.color,
                    ),
                  ),
                ),

                // Clear Button
                Positioned(
                  top: 15,
                  right: 15,
                  child: Bounceable(
                    onTap: controller.clearTracePoints,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Controls
        _buildModernControls(),
        const AdBannerWidget(),
        const SizedBox(height: 10),
      ],
    );
  }
}

class TracingPainter extends CustomPainter {
  final List<Offset?> points;
  final Color color;
  final String letter;

  TracingPainter({
    required this.points,
    required this.color,
    required this.letter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // 1. Prepare Text Painter for masking
    TextPainter tp = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          fontSize: 350, // Matches the background guide
          fontWeight: FontWeight.w900,
          color: Colors.black, // Color used for the mask (doesn't matter)
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    // 2. Same centering logic as background Text
    Offset offset = Offset(
      (size.width - tp.width) / 2,
      (size.height - tp.height) / 2,
    );

    // 3. Create a layer for masking
    canvas.saveLayer(Offset.zero & size, Paint());

    // 4. Draw the destination (the letter mask)
    tp.paint(canvas, offset);

    // 5. Draw the source (the tracing points) with BlendMode.srcIn
    // srcIn only shows the paint where the destination (letter) was drawn

    // We use a separate paint object for the line drawing to apply the blend mode
    Paint strokePaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 35.0
      ..blendMode = BlendMode.srcIn;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, strokePaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(TracingPainter oldDelegate) => true;
}
