import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bounceable.dart';
import '../../../widgets/ad_banner_widget.dart';
import '../controllers/numbers_controller.dart';

class NumbersView extends GetView<NumbersController> {
  const NumbersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Obx(() {
          switch (controller.currentMode.value) {
            case NumberViewMode.selection:
              return const Text('Number Learning',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent));
            case NumberViewMode.learn:
              return const Text('Learn Numbers',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent));
            case NumberViewMode.play:
              return const Text('Number Games',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent));
          }
        }),
        leading: Obx(() {
          if (controller.currentMode.value == NumberViewMode.selection) {
            return IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back));
          } else {
            return IconButton(onPressed: controller.resetToSelection, icon: const Icon(Icons.close_rounded));
          }
        }),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
        actions: [
          Obx(() {
            if (controller.currentMode.value == NumberViewMode.selection) {
              return const SizedBox();
            }
            return IconButton(
              onPressed: controller.toggleMode,
              icon: Icon(
                controller.currentMode.value == NumberViewMode.play
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
          case NumberViewMode.selection:
            return _buildSelectionView(context);
          case NumberViewMode.learn:
            return _buildLearnMode();
          case NumberViewMode.play:
            return _buildQuizMode(context);
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
                        "Count & Play! 🔢",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        "Number Journey",
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
                        title: "Learn 123",
                        subtitle: "Fun World",
                        icon: Icons.onetwothree_rounded,
                        emoji: "🔢",
                        color: const Color(0xFF4A90E2),
                        secondaryColor: const Color(0xFF357ABD),
                        onTap: () => controller.setMode(NumberViewMode.learn),
                      ),
                      _buildSelectionCard(
                        title: "Challenges",
                        subtitle: "Win Stars!",
                        icon: Icons.videogame_asset_rounded,
                        emoji: "🏆",
                        color: const Color(0xFFFF9F1C),
                        secondaryColor: const Color(0xFFE08E19),
                        onTap: () => controller.setMode(NumberViewMode.play),
                      ),
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
          final color = controller.numbers[controller.currentIndex.value].color;
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

        Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.numbers.length,
                itemBuilder: (context, index) {
                  final item = controller.numbers[index];
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
            const AdBannerWidget(),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedDecoration(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildModernLearnCard(NumberItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      width: 260,
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
          // 🚀 Big Number Button!
          Expanded(
            flex: 6,
            child: Bounceable(
              onTap: controller.speakCurrentNumber,
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
                    tag: 'number-${item.value}',
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
                          item.value.toString(),
                          style: const TextStyle(
                            fontSize: 160,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                            shadows: [
                              Shadow(
                                color: Colors.black26, 
                                offset: Offset(4, 4), 
                                blurRadius: 10
                              )
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
          
          // 🦁 Emoji Items Button!
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item.word.toUpperCase(),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: item.color,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Bounceable(
                      onTap: controller.speakCurrentNumber,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          item.value,
                          (i) => Text(item.emoji, style: const TextStyle(fontSize: 32)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
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
            onPressed: controller.previousNumber,
            color: Colors.grey.shade400,
          ),
          Obx(() {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${controller.currentIndex.value + 1} / 20",
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
                    widthFactor: (controller.currentIndex.value + 1) / 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.numbers[controller.currentIndex.value].color,
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
            onPressed: controller.nextNumber,
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
          colors: [
            const Color(0xFFF0F4F8),
            Colors.blue.withOpacity(0.05),
          ],
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
                      color: (controller.correctItem.value?.color ?? Colors.blue).withOpacity(0.2),
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

  Widget _buildOptionCard(NumberItem item) {
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
            item.value.toString(),
            style: TextStyle(
              fontSize: 40,
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
      case NumberGameType.findNumber:
        return "Which number is this?";
      case NumberGameType.countObjects:
        return "Count the items!";
      case NumberGameType.matchShadow:
        return "Match the shadow!";
      case NumberGameType.nextNumber:
        return "What comes next?";
      case NumberGameType.oddOneOut:
        return "Find the odd one!";
    }
  }

  Widget _buildQuestionMainDisplay() {
    final item = controller.correctItem.value;
    if (item == null) return const SizedBox();

    switch (controller.currentGameType.value) {
      case NumberGameType.findNumber:
        return Text(item.value.toString(),
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.blueAccent));
      case NumberGameType.countObjects:
        return SingleChildScrollView(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: List.generate(
              item.value,
              (i) => Text(item.emoji, style: const TextStyle(fontSize: 25)),
            ),
          ),
        );
      case NumberGameType.matchShadow:
        return ColorFiltered(
          colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
          child: Text(item.value.toString(),
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900)),
        );
      case NumberGameType.nextNumber:
        return Text("${item.value - 1}, ?",
            style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: Colors.orangeAccent));
      case NumberGameType.oddOneOut:
        return const Text("🤔", style: TextStyle(fontSize: 80));
    }
  }
}
