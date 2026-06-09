import 'dart:math';
import 'package:flutter/material.dart';

class ScoreGauge extends StatefulWidget {
  final int score;
  final String grade;
  final double size;

  const ScoreGauge({
    super.key,
    required this.score,
    required this.grade,
    this.size = 180,
  });

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.score.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ScoreGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: oldWidget.score.toDouble(),
        end: widget.score.toDouble(),
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
      );
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (widget.score >= 85) {
      scoreColor = const Color(0xFF10B981); // Emerald
    } else if (widget.score >= 70) {
      scoreColor = const Color(0xFF06B6D4); // Teal
    } else if (widget.score >= 55) {
      scoreColor = const Color(0xFFFBBF24); // Amber
    } else if (widget.score >= 40) {
      scoreColor = const Color(0xFFF97316); // Orange
    } else {
      scoreColor = const Color(0xFFEF4444); // Red
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  score: _animation.value,
                  color: scoreColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _animation.value.round().toString(),
                    style: TextStyle(
                      fontSize: widget.size * 0.22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'GRADE ${widget.grade}',
                    style: TextStyle(
                      fontSize: widget.size * 0.08,
                      fontWeight: FontWeight.w800,
                      color: scoreColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double score;
  final Color color;

  _GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 12;

    final bgPaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw full background arc (270 degrees, from 135 to 45)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3 * pi / 4,
      3 * pi / 2,
      false,
      bgPaint,
    );

    // Draw active progress arc based on score ratio
    final sweepAngle = (score / 100) * (3 * pi / 2);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3 * pi / 4,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
