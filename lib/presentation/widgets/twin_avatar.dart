import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class TwinAvatar extends StatefulWidget {
  final int score;
  final String personality;
  final double size;

  const TwinAvatar({
    super.key,
    required this.score,
    required this.personality,
    this.size = 200,
  });

  @override
  State<TwinAvatar> createState() => _TwinAvatarState();
}

class _TwinAvatarState extends State<TwinAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isBlinking = false;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    // Schedule random blinking
    _blinkTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() => _isBlinking = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() => _isBlinking = false);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on score
    final List<Color> bgGradientColors;
    final String mood;
    final Color faceColor;

    if (widget.score >= 85) {
      bgGradientColors = [const Color(0xFF10B981), const Color(0xFF047857)];
      mood = 'excellent';
      faceColor = const Color(0xFFD1FAE5);
    } else if (widget.score >= 70) {
      bgGradientColors = [const Color(0xFF06B6D4), const Color(0xFF0891B2)];
      mood = 'good';
      faceColor = const Color(0xFFECFEFF);
    } else if (widget.score >= 55) {
      bgGradientColors = [const Color(0xFFFBBF24), const Color(0xFFD97706)];
      mood = 'fair';
      faceColor = const Color(0xFFFEF3C7);
    } else if (widget.score >= 40) {
      bgGradientColors = [const Color(0xFFF97316), const Color(0xFFC2410C)];
      mood = 'poor';
      faceColor = const Color(0xFFFFEDD5);
    } else {
      bgGradientColors = [const Color(0xFF64748B), const Color(0xFF334155)];
      mood = 'critical';
      faceColor = const Color(0xFFF1F5F9);
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final double pulseVal = _pulseController.value * 0.08;
        return Semantics(
          label: 'Digital Climate Twin avatar representating a ${widget.personality} with score ${widget.score}',
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: bgGradientColors,
                center: Alignment.center,
                radius: 0.6 + pulseVal,
              ),
              boxShadow: [
                BoxShadow(
                  color: bgGradientColors.first.withOpacity(0.4),
                  blurRadius: 30 + (pulseVal * 100),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CustomPaint(
              painter: _AvatarPainter(
                score: widget.score,
                mood: mood,
                faceColor: faceColor,
                isBlinking: _isBlinking,
                animationValue: _pulseController.value,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AvatarPainter extends CustomPainter {
  final int score;
  final String mood;
  final Color faceColor;
  final bool isBlinking;
  final double animationValue;

  _AvatarPainter({
    required this.score,
    required this.mood,
    required this.faceColor,
    required this.isBlinking,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    // Draw background elements (leaves, clouds, smog)
    _paintBackgroundEffects(canvas, size, center);

    // Draw Twin head
    final headPaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    // Draw head shadow offsetted
    canvas.drawCircle(center + const Offset(4, 6), radius, shadowPaint);
    canvas.drawCircle(center, radius, headPaint);

    // Draw ears (if any)
    final earPaint = Paint()..color = faceColor;
    canvas.drawCircle(Offset(center.dx - radius - 2, center.dy), radius * 0.22, earPaint);
    canvas.drawCircle(Offset(center.dx + radius + 2, center.dy), radius * 0.22, earPaint);

    // Draw eyes
    final eyePaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    final double eyeWidth = radius * 0.15;
    final double eyeHeight = isBlinking ? 2.0 : radius * 0.25;
    final double eyeOffsetY = radius * 0.1;
    final double eyeOffsetX = radius * 0.35;

    if (isBlinking) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx - eyeOffsetX, center.dy - eyeOffsetY), width: eyeWidth * 1.2, height: 2),
          const Radius.circular(2),
        ),
        eyePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(center.dx + eyeOffsetX, center.dy - eyeOffsetY), width: eyeWidth * 1.2, height: 2),
          const Radius.circular(2),
        ),
        eyePaint,
      );
    } else {
      // Draw normal round/oval eyes
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx - eyeOffsetX, center.dy - eyeOffsetY), width: eyeWidth, height: eyeHeight),
        eyePaint,
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(center.dx + eyeOffsetX, center.dy - eyeOffsetY), width: eyeWidth, height: eyeHeight),
        eyePaint,
      );

      // Eye highlights
      final highlightPaint = Paint()..color = Colors.white;
      canvas.drawCircle(Offset(center.dx - eyeOffsetX - 2, center.dy - eyeOffsetY - 3), 2.5, highlightPaint);
      canvas.drawCircle(Offset(center.dx + eyeOffsetX - 2, center.dy - eyeOffsetY - 3), 2.5, highlightPaint);
    }

    // Draw cheeks for happy states
    if (mood == 'excellent' || mood == 'good') {
      final cheekPaint = Paint()..color = Colors.red.withOpacity(0.15);
      canvas.drawCircle(Offset(center.dx - eyeOffsetX - 4, center.dy + 4), radius * 0.15, cheekPaint);
      canvas.drawCircle(Offset(center.dx + eyeOffsetX + 4, center.dy + 4), radius * 0.15, cheekPaint);
    }

    // Draw Mouth depending on mood
    final mouthPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    final mouthY = center.dy + (radius * 0.25);

    if (mood == 'excellent') {
      // Big smile
      mouthPath.moveTo(center.dx - (radius * 0.25), mouthY - 2);
      mouthPath.quadraticBezierTo(center.dx, mouthY + (radius * 0.25), center.dx + (radius * 0.25), mouthY - 2);
      
      // Draw full happy smile shape filled
      final fillSmile = Paint()
        ..color = const Color(0xFFE11D48).withOpacity(0.7)
        ..style = PaintingStyle.fill;
      final smilePath = Path()
        ..moveTo(center.dx - (radius * 0.22), mouthY)
        ..quadraticBezierTo(center.dx, mouthY + (radius * 0.25), center.dx + (radius * 0.22), mouthY)
        ..close();
      canvas.drawPath(smilePath, fillSmile);
      canvas.drawPath(mouthPath, mouthPaint);
    } else if (mood == 'good') {
      // Normal Smile
      mouthPath.moveTo(center.dx - (radius * 0.22), mouthY);
      mouthPath.quadraticBezierTo(center.dx, mouthY + (radius * 0.15), center.dx + (radius * 0.22), mouthY);
      canvas.drawPath(mouthPath, mouthPaint);
    } else if (mood == 'fair') {
      // Straight line
      canvas.drawLine(Offset(center.dx - (radius * 0.2), mouthY), Offset(center.dx + (radius * 0.2), mouthY), mouthPaint);
    } else if (mood == 'poor') {
      // Slight frown
      mouthPath.moveTo(center.dx - (radius * 0.22), mouthY + 5);
      mouthPath.quadraticBezierTo(center.dx, mouthY - 2, center.dx + (radius * 0.22), mouthY + 5);
      canvas.drawPath(mouthPath, mouthPaint);
    } else {
      // Deep frown & concern
      mouthPath.moveTo(center.dx - (radius * 0.25), mouthY + 10);
      mouthPath.quadraticBezierTo(center.dx, mouthY, center.dx + (radius * 0.25), mouthY + 10);
      canvas.drawPath(mouthPath, mouthPaint);

      // Sweat droplet or worry line on forehead
      final worryPaint = Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawLine(Offset(center.dx - 8, center.dy - radius * 0.6), Offset(center.dx + 8, center.dy - radius * 0.6), worryPaint);
      canvas.drawLine(Offset(center.dx - 5, center.dy - radius * 0.5), Offset(center.dx + 5, center.dy - radius * 0.5), worryPaint);
    }
  }

  void _paintBackgroundEffects(Canvas canvas, Size size, Offset center) {
    final effectPaint = Paint()..style = PaintingStyle.fill;
    final double w = size.width;
    final double h = size.height;

    // Green leaves for high sustainability
    if (mood == 'excellent' || mood == 'good') {
      effectPaint.color = Colors.white.withOpacity(0.3 + (0.15 * sin(animationValue * 2 * pi)));
      
      // Draw leaf 1 (top-right)
      final leaf1X = center.dx + w * 0.35 + (8 * cos(animationValue * 2 * pi));
      final leaf1Y = center.dy - h * 0.32 + (8 * sin(animationValue * 2 * pi));
      _drawLeaf(canvas, Offset(leaf1X, leaf1Y), effectPaint);

      // Draw leaf 2 (bottom-left)
      final leaf2X = center.dx - w * 0.36 + (6 * sin(animationValue * 2 * pi));
      final leaf2Y = center.dy + h * 0.28 + (6 * cos(animationValue * 2 * pi));
      _drawLeaf(canvas, Offset(leaf2X, leaf2Y), effectPaint);
    } 
    // Floating bubbles for medium score
    else if (mood == 'fair') {
      effectPaint.color = Colors.white.withOpacity(0.25);
      
      final b1X = center.dx - w * 0.38 + (10 * sin(animationValue * pi));
      final b1Y = center.dy - h * 0.2 - (animationValue * 15);
      canvas.drawCircle(Offset(b1X, b1Y), 8, effectPaint);

      final b2X = center.dx + w * 0.35;
      final b2Y = center.dy + h * 0.2 + (animationValue * 20);
      canvas.drawCircle(Offset(b2X, b2Y), 12, effectPaint);
    } 
    // Floating dust/grey clouds for low scores
    else {
      effectPaint.color = const Color(0xFF1E293B).withOpacity(0.2);
      
      // Left smog cloud
      final c1x = center.dx - w * 0.36;
      final c1y = center.dy - h * 0.25 + (8 * sin(animationValue * 2 * pi));
      canvas.drawCircle(Offset(c1x, c1y), 15, effectPaint);
      canvas.drawCircle(Offset(c1x + 10, c1y + 5), 12, effectPaint);

      // Right smog cloud
      final c2x = center.dx + w * 0.34;
      final c2y = center.dy + h * 0.25 + (8 * cos(animationValue * 2 * pi));
      canvas.drawCircle(Offset(c2x, c2y), 18, effectPaint);
      canvas.drawCircle(Offset(c2x - 12, c2y - 6), 14, effectPaint);
    }
  }

  void _drawLeaf(Canvas canvas, Offset position, Paint paint) {
    final path = Path()
      ..moveTo(position.dx, position.dy)
      ..quadraticBezierTo(position.dx + 12, position.dy - 12, position.dx + 24, position.dy)
      ..quadraticBezierTo(position.dx + 12, position.dy + 12, position.dx, position.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    return oldDelegate.score != score ||
        oldDelegate.mood != mood ||
        oldDelegate.isBlinking != isBlinking ||
        oldDelegate.animationValue != animationValue;
  }
}
