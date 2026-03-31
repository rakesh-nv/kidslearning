import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/bounceable.dart';
import '../../../widgets/ad_banner_widget.dart';
import '../controllers/shadow_match_controller.dart';
import '../widgets/repeating_demo_hand.dart';

class ShadowMatchView extends GetView<ShadowMatchController> {
  const ShadowMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          "Shadow Match!",
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.deepPurple, fontSize: 26),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.deepPurple),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEDE7F6), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildScoreBoard(),
              
              // The Target Shadow
              Expanded(
                flex: 5,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(() {
                      final target = controller.targetItem.value;
                      if (target == null) return const SizedBox.shrink();
                      
                      return DragTarget<MatchItem>(
                        onWillAccept: (data) => true,
                        onAccept: (data) => controller.onMatched(data),
                        builder: (context, candidateData, rejectedData) {
                          bool isActive = candidateData.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            constraints: const BoxConstraints(
                              maxWidth: 300,
                              maxHeight: 300,
                            ),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.deepPurple.withOpacity(0.1) : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                              border: Border.all(
                                color: isActive ? Colors.deepPurpleAccent : Colors.transparent,
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: ColorFiltered(
                                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcATop),
                                    child: Hero(
                                      tag: 'shadow-${target.name}',
                                      child: Text(
                                        target.emoji,
                                        style: const TextStyle(fontSize: 160),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
          
              // Draggable Options
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
                    ],
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Obx(() => Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: controller.options.map((option) => _buildDraggable(option)).toList(),
                      )),
                    ),
                  ),
                ),
              ),
              
              const AdBannerWidget(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildDemoHand(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDemoHand() {
    return Obx(() {
      if (!controller.showDemo.value) return const SizedBox.shrink();
      
      return IgnorePointer(
        child: RepeatingDemoHand(
          correctItem: controller.targetItem.value,
          correctIndex: controller.correctOptionIndex,
        ),
      );
    });
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.stars_rounded, color: Colors.orangeAccent, size: 32),
          const SizedBox(width: 12),
          Obx(() => Text(
                "SCORE: ${controller.score.value}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3142),
                  letterSpacing: 2,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDraggable(MatchItem item) {
    final emojiWidget = Text(item.emoji, style: const TextStyle(fontSize: 70));
    
    return Draggable<MatchItem>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(scale: 1.2, child: emojiWidget),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildOptionContainer(item, emojiWidget),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: _buildOptionContainer(item, emojiWidget),
      ),
    );
  }

  Widget _buildOptionContainer(MatchItem item, Widget emojiWidget) {
    return Bounceable(
      onTap: () {},
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: item.color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Center(child: emojiWidget),
      ),
    );
  }
}
