import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/puzzle_controller.dart';

class PuzzleView extends GetView<PuzzleController> {
  const PuzzleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Shape Jam!',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blueAccent, fontSize: 26),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F2FE), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildMessageCard(),
              const SizedBox(height: 40),
              
              // 1. Target Silhouettes (The Shadows)
              const Text(
                "Match them up!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 30,
                  runSpacing: 30,
                  alignment: WrapAlignment.center,
                  children: controller.allShapes.map((shape) => _buildTarget(shape)).toList(),
                ),
              ),
              
              const Spacer(),
              
              // 2. Playable Shapes (The Draggables)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))
                  ],
                ),
                child: Obx(() => Wrap(
                  spacing: 25,
                  runSpacing: 25,
                  alignment: WrapAlignment.center,
                  children: controller.shuffledShapes
                    .where((s) => !(controller.matchedShapes[s.name] ?? false))
                    .map((shape) => _buildDraggable(shape))
                    .toList(),
                )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.resetGame,
        backgroundColor: Colors.orangeAccent,
        icon: const Icon(Icons.refresh_rounded, color: Colors.white),
        label: const Text("New Game", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFF0FDF4),
            radius: 25,
            child: Icon(Icons.psychology_rounded, color: Colors.greenAccent, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Obx(() => Text(
              controller.isGameComplete ? "YAY! YOU DID IT!" : "Drag the shapes to their outlines!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: controller.isGameComplete ? Colors.green : Colors.blueGrey.shade700,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTarget(ShapeItem shape) {
    return Obx(() {
      final isMatched = controller.matchedShapes[shape.name] ?? false;
      
      return DragTarget<String>(
        onWillAccept: (data) => data == shape.name && !isMatched,
        onAccept: (data) => controller.onShapeDropped(data),
        builder: (context, candidateData, rejectedData) {
          bool isActive = candidateData.isNotEmpty;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isMatched 
                  ? shape.color.withOpacity(0.2) 
                  : (isActive ? shape.color.withOpacity(0.1) : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isMatched ? shape.color : (isActive ? shape.color : Colors.grey.shade300),
                width: 3,
                style: isMatched ? BorderStyle.solid : BorderStyle.none,
              ),
            ),
            child: Center(
              child: Icon(
                shape.icon,
                size: 50,
                color: isMatched ? shape.color : Colors.grey.shade400.withOpacity(0.5),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildDraggable(ShapeItem shape) {
    return Draggable<String>(
      data: shape.name,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            color: shape.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 10))],
          ),
          child: Icon(shape.icon, size: 55, color: Colors.white),
        ),
      ),
      childWhenDragging: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: shape.color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shape.color.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(5, 5),
              )
            ],
          ),
          child: Icon(shape.icon, size: 50, color: Colors.white),
        ),
      ),
    );
  }
}
