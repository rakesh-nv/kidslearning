import 'package:flutter/material.dart';
import '../controllers/shapes_controller.dart';

class ShapeChallengeDemoHand extends StatefulWidget {
  final ShapeItem? correctItem;
  final int correctIndex;

  const ShapeChallengeDemoHand({
    super.key,
    required this.correctItem,
    required this.correctIndex,
  });

  @override
  State<ShapeChallengeDemoHand> createState() => _ShapeChallengeDemoHandState();
}

class _ShapeChallengeDemoHandState extends State<ShapeChallengeDemoHand> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnimation;
  late Animation<double> _xAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Drawer is at bottom, frame is at center
    // Approximate offsets match the 2x2 grid in ShapesView
    double startX = 0;
    if (widget.correctIndex == 0) startX = -120;
    if (widget.correctIndex == 1) startX = 120;
    if (widget.correctIndex == 2) startX = -120;
    if (widget.correctIndex == 3) startX = 120;

    double startY = 320; 
    if (widget.correctIndex >= 2) startY = 420; // Second row in bottom list

    _yAnimation = Tween<double>(begin: startY, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _xAnimation = Tween<double>(begin: startX, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8, curve: Curves.easeInOut)),
    );

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween<double>(1.0), weight: 70),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 15),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.correctItem == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: Offset(_xAnimation.value, _yAnimation.value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🟦 Carrying the Shape
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: widget.correctItem!.color.withOpacity(0.2), blurRadius: 10)],
                  ),
                  child: Icon(widget.correctItem!.icon, size: 50, color: widget.correctItem!.color),
                ),
                const SizedBox(height: 5),
                const Icon(Icons.touch_app_rounded, size: 70, color: Colors.blueAccent),
                const Text("DRAG ME! 🖐️", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 16)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
