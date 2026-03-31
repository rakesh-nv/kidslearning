import 'package:flutter/material.dart';
import '../controllers/shadow_match_controller.dart';

class RepeatingDemoHand extends StatefulWidget {
  final MatchItem? correctItem;
  final int correctIndex; // 0, 1, 2, 3

  const RepeatingDemoHand({
    super.key, 
    required this.correctItem,
    required this.correctIndex,
  });

  @override
  State<RepeatingDemoHand> createState() => _RepeatingDemoHandState();
}

class _RepeatingDemoHandState extends State<RepeatingDemoHand> with SingleTickerProviderStateMixin {
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

    // Calculate approximate starting X based on index (0-3) in a Wrap/Grid
    double startX = 0;
    if (widget.correctIndex == 0) startX = -120;
    if (widget.correctIndex == 1) startX = 120;
    if (widget.correctIndex == 2) startX = -120;
    if (widget.correctIndex == 3) startX = 120;

    double startY = 220;
    if (widget.correctIndex >= 2) startY = 320; // second row

    _yAnimation = Tween<double>(begin: startY, end: -150).animate(
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
                // 🍎 The Emoji being "Carried"
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5), width: 2),
                  ),
                  child: Text(widget.correctItem!.emoji, style: const TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 5),
                const Icon(Icons.touch_app_rounded, size: 70, color: Colors.deepPurpleAccent),
                const SizedBox(height: 5),
                const Text("DRAG ME! 🖐️", 
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple, fontSize: 16)
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
