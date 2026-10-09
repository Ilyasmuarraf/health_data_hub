import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// The big 270°-sweep circular gauge used across the app:
/// - Organ health score
/// - Condition severity score
/// - Immune system strength
class CircularScoreGauge extends StatelessWidget {
  final double percentage; // 0.0 - 1.0
  final Color themeColor;
  final double size;
  final Duration animationDuration;

  const CircularScoreGauge({
    super.key,
    required this.percentage,
    required this.themeColor,
    this.size = 240,
    this.animationDuration = const Duration(milliseconds: 900),
  });

  @override
  Widget build(BuildContext context) {
    final clamped = percentage.clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: clamped),
        duration: animationDuration,
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _PixelPerfectCircularPainter(
                  percentage: animatedValue,
                  themeColor: themeColor,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    '${(animatedValue * 100).round()}%',
                    style: AppTheme.painterText(
                      fontSize: size * 0.2,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PixelPerfectCircularPainter extends CustomPainter {
  final double percentage;
  final Color themeColor;

  _PixelPerfectCircularPainter(
      {required this.percentage, required this.themeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    const strokeWidth = 16.0;

    const startAngle = 3 * pi / 4;
    const totalSweep = 3 * pi / 2;

    final bgPaint = Paint()
      ..color = const Color(0xFF1B1C24)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, totalSweep, false, bgPaint);

    final activePaint = Paint()
      ..color = themeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 4.0);

    final activeSweep = totalSweep * percentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        startAngle, activeSweep, false, activePaint);

    final inactiveTickPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.5;
    final activeTickPaint = Paint()
      ..color = themeColor
      ..strokeWidth = 2.5;

    const totalTicks = 60;
    final activeTicks = (totalTicks * percentage).toInt();
    const anglePerTick = totalSweep / totalTicks;

    for (int i = 0; i <= totalTicks; i++) {
      final angle = startAngle + (i * anglePerTick);
      final isTickActive = i <= activeTicks;
      const innerR = 12.0;
      const outerR = 18.0;

      final p1 = Offset(center.dx + (radius + innerR) * cos(angle),
          center.dy + (radius + innerR) * sin(angle));
      final p2 = Offset(center.dx + (radius + outerR) * cos(angle),
          center.dy + (radius + outerR) * sin(angle));
      canvas.drawLine(
          p1, p2, isTickActive ? activeTickPaint : inactiveTickPaint);
    }

    final labels = ['0', '20', '40', '60', '80'];
    final labelRadius = radius - 30;
    final textPainter =
        TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);

    for (int i = 0; i < labels.length; i++) {
      final angle = startAngle + (i * (totalSweep / 4));
      final isFortyMark = i == 2;
      textPainter.text = TextSpan(
        text: labels[i],
        style: AppTheme.painterText(
          color: isFortyMark ? themeColor : Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
      textPainter.layout();

      final textCenter = Offset(center.dx + labelRadius * cos(angle),
          center.dy + labelRadius * sin(angle));
      final textOffset = Offset(textCenter.dx - (textPainter.width / 2),
          textCenter.dy - (textPainter.height / 2));

      if (isFortyMark) {
        _drawTopTriangle(canvas, Offset(center.dx, center.dy - radius - 20));
      }
      textPainter.paint(canvas, textOffset);
    }
  }

  void _drawTopTriangle(Canvas canvas, Offset position) {
    final paint = Paint()
      ..color = themeColor
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(position.dx - 6, position.dy - 6)
      ..lineTo(position.dx + 6, position.dy - 6)
      ..lineTo(position.dx, position.dy + 4)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PixelPerfectCircularPainter oldDelegate) =>
      oldDelegate.percentage != percentage ||
      oldDelegate.themeColor != themeColor;
}
