import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// A single data point on the chart, carrying its own color so the line
/// can change color across phases (Warm Up / Peak / Recovery) exactly like
/// the reference design.
class ChartPoint {
  final double x;
  final double y;
  final Color color;
  const ChartPoint({required this.x, required this.y, required this.color});
}

/// Smooth bezier line chart with a soft gradient fill under the curve,
/// dashed horizontal gridlines, and axis labels.
class BezierLineChart extends StatelessWidget {
  final List<ChartPoint> points;
  final double height;
  final List<String> yLabels;
  final List<String> xLabels;
  final double minValue;
  final double maxValue;

  const BezierLineChart({
    super.key,
    required this.points,
    this.height = 180.0,
    this.yLabels = const ['100', '90', '80', '70', '60', '50'],
    this.xLabels = const ['0', '20', '40', '60', '80', '100', '120'],
    this.minValue = 50.0,
    this.maxValue = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _BezierChartPainter(
          points: points,
          yLabels: yLabels,
          xLabels: xLabels,
          minValue: minValue,
          maxValue: maxValue,
        ),
      ),
    );
  }
}

class _BezierChartPainter extends CustomPainter {
  final List<ChartPoint> points;
  final List<String> yLabels;
  final List<String> xLabels;
  final double minValue;
  final double maxValue;

  _BezierChartPainter({
    required this.points,
    required this.yLabels,
    required this.xLabels,
    required this.minValue,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    const paddingLeft = 30.0;
    const paddingBottom = 20.0;
    final chartWidth = size.width - paddingLeft;
    final chartHeight = size.height - paddingBottom;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Y-axis labels & dashed gridlines
    final gridPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 1.0;

    for (int i = 0; i < yLabels.length; i++) {
      final y = i * (chartHeight / (yLabels.length - 1));

      textPainter.text = TextSpan(
          text: yLabels[i],
          style: AppTheme.painterText(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500));
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6));

      for (double j = paddingLeft; j < size.width; j += 8) {
        canvas.drawLine(Offset(j, y), Offset(j + 4, y), gridPaint);
      }
    }

    // X-axis labels
    final xStep = chartWidth / (xLabels.length - 1);
    for (int i = 0; i < xLabels.length; i++) {
      final x = paddingLeft + (i * xStep);
      textPainter.text = TextSpan(
          text: xLabels[i],
          style: AppTheme.painterText(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w500));
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - (textPainter.width / 2), size.height - 15));
    }

    // Map data points to canvas offsets
    final maxX = points.last.x;
    final List<Offset> offsets = points.map((p) {
      final nx = p.x / (maxX == 0 ? 1 : maxX);
      final ny = (p.y - minValue) / (maxValue - minValue);
      return Offset(
        paddingLeft + nx * chartWidth,
        chartHeight - (ny.clamp(0.0, 1.0) * chartHeight),
      );
    }).toList();

    // Build one smooth path for the fill (single color average looks fine
    // under a translucent gradient), but stroke each segment individually
    // so the line itself can shift color per phase.
    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cpX = p0.dx + (p1.dx - p0.dx) / 2;
      path.cubicTo(cpX, p0.dy, cpX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, chartHeight)
      ..lineTo(paddingLeft, chartHeight)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            points.first.color.withOpacity(0.35),
            Colors.transparent,
          ],
        ).createShader(Rect.fromLTWH(paddingLeft, 0, chartWidth, chartHeight)),
    );

    // Stroke each segment with the color of its starting point, so the
    // line visibly transitions cyan -> green -> red across phases.
    for (int i = 0; i < offsets.length - 1; i++) {
      final p0 = offsets[i];
      final p1 = offsets[i + 1];
      final cpX = p0.dx + (p1.dx - p0.dx) / 2;
      final segmentPath = Path()
        ..moveTo(p0.dx, p0.dy)
        ..cubicTo(cpX, p0.dy, cpX, p1.dy, p1.dx, p1.dy);
      canvas.drawPath(
        segmentPath,
        Paint()
          ..color = points[i].color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Dots
    for (int i = 0; i < offsets.length; i++) {
      canvas.drawCircle(offsets[i], 4.0, Paint()..color = Colors.black);
      canvas.drawCircle(
        offsets[i],
        4.0,
        Paint()
          ..color = points[i].color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BezierChartPainter oldDelegate) =>
      oldDelegate.points != points;
}
