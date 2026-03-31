import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/ad_banner_widget.dart';
import '../../../controllers/monetization_controller.dart';
import '../../../widgets/bounceable.dart';
import '../controllers/shapes_controller.dart';
import '../widgets/shape_challenge_demo_hand.dart';

class ShapesView extends GetView<ShapesController> {
  const ShapesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Obx(() {
          switch (controller.currentMode.value) {
            case ShapesViewMode.selection:
              return const Text("Shapes World! 🟠");
            case ShapesViewMode.learn:
              return const Text("Learn Shapes 🎓");
            case ShapesViewMode.play:
              return const Text("Shape Challenge 🎮");
            case ShapesViewMode.trace:
              return const Text("Magic Tracer ✨");
          }
        }),
        leading: Obx(
          () => IconButton(
            onPressed: controller.currentMode.value == ShapesViewMode.selection
                ? () => Get.back()
                : controller.resetToSelection,
            icon: Icon(
              controller.currentMode.value == ShapesViewMode.selection
                  ? Icons.arrow_back_rounded
                  : Icons.close_rounded,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: Obx(() {
        switch (controller.currentMode.value) {
          case ShapesViewMode.selection:
            return _buildSelectionView(context);
          case ShapesViewMode.learn:
            return _buildLearnMode();
          case ShapesViewMode.play:
            return _buildPlayMode();
          case ShapesViewMode.trace:
            return _buildTraceMode();
        }
      }),
      floatingActionButton: Obx(() {
        if (controller.currentMode.value == ShapesViewMode.play &&
            controller.showDemo.value) {
          return _buildDemoHand();
        }
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDemoHand() {
    return IgnorePointer(
      child: ShapeChallengeDemoHand(
        correctItem: controller.targetShape.value,
        correctIndex: controller.correctOptionIndex,
      ),
    );
  }

  Widget _buildSelectionView(BuildContext context) {
    final monetization = Get.find<MonetizationController>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSelectionCard(
            title: "Shape World",
            subtitle: "Meet and hear the shapes",
            icon: Icons.auto_stories_rounded,
            color: Colors.blueAccent,
            onTap: () => controller.setMode(ShapesViewMode.learn),
          ),
          const SizedBox(height: 20),
          Obx(() {
            final isUnlocked = monetization.isPremium;
            return _buildSelectionCard(
              title: isUnlocked ? "Shape Quest" : "Shape Quest (Watch Ad)",
              subtitle: "Sorter & Real-world puzzles",
              icon: Icons.videogame_asset_rounded,
              color: Colors.orangeAccent,
              onTap: () {
                if (isUnlocked) {
                  controller.setMode(ShapesViewMode.play);
                } else {
                  monetization.attemptUnlockWithReward(
                    onSuccess: () => controller.setMode(ShapesViewMode.play),
                  );
                }
              },
            );
          }),
          const SizedBox(height: 20),
          Obx(() {
            final isUnlocked = monetization.isPremium;
            return _buildSelectionCard(
              title: isUnlocked ? "Magic Tracer" : "Magic Discovery (Watch Ad)",
              subtitle: "Draw shapes with magic!",
              icon: Icons.auto_awesome_rounded,
              color: Colors.purpleAccent,
              onTap: () {
                if (isUnlocked) {
                  controller.setMode(ShapesViewMode.trace);
                } else {
                  monetization.attemptUnlockWithReward(
                    onSuccess: () => controller.setMode(ShapesViewMode.trace),
                  );
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(minHeight: 150), // ✅ flexible height
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(width: 16),

            /// ✅ TEXT AREA FIXED
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // 🔥 prevents overflow
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24, // slightly reduced
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnMode() {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            itemCount: controller.allShapes.length,
            itemBuilder: (context, index) {
              final shape = controller.allShapes[index];
              return Center(child: _buildLearnCard(shape));
            },
          ),
        ),
        _buildNavControls(),
        const AdBannerWidget(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildLearnCard(ShapeItem item) {
    return Container(
      width: 320,
      height: 480,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(40),
                  bottom: Radius.circular(80),
                ),
              ),
              child: Icon(item.icon, size: 180, color: Colors.white),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: item.color,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  children: item.realWorldObjects
                      .map(
                        (obj) =>
                            Text(obj, style: const TextStyle(fontSize: 40)),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: controller.previousShape,
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 30),
          ),
          Obx(
            () => Text(
              "${controller.learnIndex.value + 1} / ${controller.allShapes.length}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: controller.nextShape,
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayMode() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildScoreBoard(),
        Expanded(
          flex: 5,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final target = controller.targetShape.value;
                if (target == null) return const SizedBox.shrink();
                return DragTarget<ShapeItem>(
                  onWillAccept: (data) => true,
                  onAccept: (data) => controller.onMatched(data),
                  builder: (context, candidateData, rejectedData) {
                    bool isActive = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(20),
                      constraints: const BoxConstraints(
                        maxWidth: 300,
                        maxHeight: 300,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? target.color.withOpacity(0.1)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: isActive ? target.color : Colors.grey.shade200,
                          width: 6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: controller.isSecondGameMode.value
                              ? _buildRealWorldTarget(target)
                              : _buildShapeSorterTarget(target),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Obx(
                  () => Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: controller.options
                        .map((option) => _buildDraggable(option))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const AdBannerWidget(),
      ],
    );
  }

  Widget _buildRealWorldTarget(ShapeItem target) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          controller.currentRealWorldObject.value,
          style: const TextStyle(fontSize: 140),
        ),
        const SizedBox(height: 10),
        Text(
          "Matches a ${target.name}!",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: target.color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildShapeSorterTarget(ShapeItem target) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(target.icon, size: 160, color: Colors.grey.shade100),
        const SizedBox(height: 10),
        Text(
          "Where is the ${target.name}?",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildTraceMode() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Magic Discovery! ✨",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.purpleAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Tap the cards to find shapes!",
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final shape = controller
                    .allShapes[(index + 3) % controller.allShapes.length];
                return Bounceable(
                  onTap: () => controller.speakShape(shape),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        shape.icon,
                        size: 80,
                        color: shape.color.withOpacity(0.4),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const AdBannerWidget(),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
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
          const Icon(Icons.stars_rounded, color: Colors.amber, size: 32),
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
    );
  }

  Widget _buildDraggable(ShapeItem item) {
    final shapeWidget = Icon(item.icon, size: 80, color: item.color);

    return Draggable<ShapeItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.2, child: shapeWidget),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildOptionContainer(item, shapeWidget),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: _buildOptionContainer(item, shapeWidget),
      ),
    );
  }

  Widget _buildOptionContainer(ShapeItem item, Widget shapeWidget) {
    return Bounceable(
      onTap: () {
        controller.speak(item.name);
      },
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(child: shapeWidget),
      ),
    );
  }
}
