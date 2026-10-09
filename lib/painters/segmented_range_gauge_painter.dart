import 'dart:math';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Six-segment half-donut gauge (Very Low -> Very High) with a needle,
/// used on the LDL / Mentzer parameter detail screen.
///
/// NOTE: the "OPTIAL" label (should read "OPTIMAL") is reproduced verbatim
/// because it appears that way in the approved design reference — this is
/// an intentional pixel-match, not a typo in this code.
class SegmentedRangeGaugePainter extends CustomPainter {
  final double score; // 0 - 100

  SegmentedRangeGaugePainter({required this.score});

  static const List<_Segment> _segments = [
    _Segment(Color(0xFFFF5252), 'VERY LOW'),
    _Segment(Color(0xFFFF8A65), 'LOW'),
    _Segment(Color(0xFFFFEE58), 'MODERATE'),
    _Segment(Color(0xFFAEEA00), 'OPTIAL'),
    _Segment(Color(0xFF66BB6A), 'HIGH'),
    _Segment(Color(0xFF2E7D32), 'VERY HIGH'),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = size.width / 2 - 30;
    const strokeWidth = 16.0;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final segmentAngle = pi / _segments.length;
    final textPainter =
        TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);

    for (int i = 0; i < _segments.length; i++) {
      final startAngle = pi + (i * segmentAngle);

      final paint = Paint()
        ..color = _segments[i].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, startAngle, segmentAngle - 0.04, false, paint);

      final textAngle = startAngle + (segmentAngle / 2);
      const textRadius0 = 25.0;
      final textRadius = radius + textRadius0;

      textPainter.text = TextSpan(
        text: _segments[i].label,
        style: AppTheme.painterText(
            color: Colors.white70, fontSize: 8, fontWeight: FontWeight.w700),
      );
      textPainter.layout();

      final textCenter = Offset(center.dx + textRadius * cos(textAngle),
          center.dy + textRadius * sin(textAngle));
      final textOffset = Offset(textCenter.dx - (textPainter.width / 2),
          textCenter.dy - (textPainter.height / 2));
      textPainter.paint(canvas, textOffset);
    }

    final clampedScore = score.clamp(0.0, 100.0);
    final needleAngle = pi + (pi * (clampedScore / 100.0));

    final needlePaint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final needleLength = radius - strokeWidth;
    final tip = Offset(center.dx + needleLength * cos(needleAngle),
        center.dy + needleLength * sin(needleAngle));

    canvas.drawLine(center, tip, needlePaint);
    canvas.drawCircle(center, 12, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant SegmentedRangeGaugePainter oldDelegate) =>
      oldDelegate.score != score;
}

class _Segment {
  final Color color;
  final String label;
  const _Segment(this.color, this.label);
}
