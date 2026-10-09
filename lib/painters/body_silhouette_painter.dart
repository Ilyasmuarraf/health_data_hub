import 'package:flutter/material.dart';

/// A hand-painted stand-in for the photographic "body scan" render used on
/// the Phenotype Overview screen. A real 3D/photographic asset will always
/// look better and should replace this the moment it's available (see
/// AppAssets.bodySilhouette) — but a plain Material [Icon] was too far off
/// from the reference, so this draws an actual translucent, glowing,
/// x-ray-style humanoid figure entirely via [CustomPainter]: a soft outer
/// glow, a gradient-filled silhouette, faint "skeletal" guide lines, and
/// pulsing joint markers at the shoulders / elbows / hips / knees.
class BodySilhouetteView extends StatelessWidget {
  final double height;
  final Color glowColor;
  final Animation<double>? pulse;

  const BodySilhouetteView({
    super.key,
    this.height = 300,
    this.glowColor = const Color(0xFF29B6F6),
    this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final width = height * 0.42;
    return SizedBox(
      width: width,
      height: height,
      child: AnimatedBuilder(
        animation: pulse ?? const AlwaysStoppedAnimation(0.5),
        builder: (context, _) {
          return CustomPaint(
            size: Size(width, height),
            painter: _BodyPainter(
              glowColor: glowColor,
              pulseValue: pulse?.value ?? 0.5,
            ),
          );
        },
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  final Color glowColor;
  final double pulseValue; // 0..1, drives joint-glow breathing

  _BodyPainter({required this.glowColor, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = _buildSilhouettePath(w, h);

    // 1. Soft outer glow (blurred duplicate of the silhouette)
    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // 2. Gradient-filled translucent body
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            glowColor.withOpacity(0.55),
            glowColor.withOpacity(0.15),
          ],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // 3. Outline
    canvas.drawPath(
      path,
      Paint()
        ..color = glowColor.withOpacity(0.9)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );

    // 4. Faint internal "skeletal" guide lines
    final skeletonPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0;
    // Spine
    canvas.drawLine(Offset(w * 0.5, h * 0.14), Offset(w * 0.5, h * 0.62), skeletonPaint);
    // Collarbone
    canvas.drawLine(Offset(w * 0.30, h * 0.19), Offset(w * 0.70, h * 0.19), skeletonPaint);
    // Pelvis
    canvas.drawLine(Offset(w * 0.34, h * 0.58), Offset(w * 0.66, h * 0.58), skeletonPaint);

    // 5. Glowing joint markers — position roughly matches where the
    // reference design pins its "Knee Problems" / neck callouts.
    final joints = <Offset>[
      Offset(w * 0.5, h * 0.10), // neck
      Offset(w * 0.28, h * 0.22), // left shoulder
      Offset(w * 0.72, h * 0.22), // right shoulder
      Offset(w * 0.22, h * 0.40), // left elbow
      Offset(w * 0.78, h * 0.40), // right elbow
      Offset(w * 0.38, h * 0.58), // left hip
      Offset(w * 0.62, h * 0.58), // right hip
      Offset(w * 0.36, h * 0.80), // left knee
      Offset(w * 0.64, h * 0.80), // right knee
    ];
    final breathe = 0.6 + (pulseValue * 0.4); // 0.6 - 1.0
    for (final joint in joints) {
      canvas.drawCircle(
        joint,
        4.5 * breathe,
        Paint()
          ..color = glowColor.withOpacity(0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
      canvas.drawCircle(joint, 1.6, Paint()..color = Colors.white);
    }
  }

  Path _buildSilhouettePath(double w, double h) {
    final path = Path();
    // Head
    path.addOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.075), width: w * 0.20, height: h * 0.10));

    // Torso + arms + legs as one continuous silhouette outline.
    path.moveTo(w * 0.40, h * 0.135);
    path.cubicTo(w * 0.30, h * 0.16, w * 0.24, h * 0.20, w * 0.20, h * 0.28);
    path.cubicTo(w * 0.15, h * 0.36, w * 0.14, h * 0.42, w * 0.17, h * 0.46); // left hand area
    path.cubicTo(w * 0.20, h * 0.44, w * 0.24, h * 0.38, w * 0.28, h * 0.30);
    path.cubicTo(w * 0.26, h * 0.40, w * 0.27, h * 0.50, w * 0.32, h * 0.58);
    path.cubicTo(w * 0.28, h * 0.62, w * 0.24, h * 0.78, w * 0.22, h * 0.95); // left leg outer
    path.cubicTo(w * 0.24, h * 0.98, w * 0.30, h * 0.98, w * 0.32, h * 0.95);
    path.cubicTo(w * 0.34, h * 0.80, w * 0.37, h * 0.66, w * 0.42, h * 0.60); // inner leg gap
    path.cubicTo(w * 0.43, h * 0.72, w * 0.44, h * 0.86, w * 0.42, h * 0.95); // right leg inner->outer
    path.cubicTo(w * 0.44, h * 0.98, w * 0.50, h * 0.98, w * 0.52, h * 0.95);
    path.cubicTo(w * 0.50, h * 0.86, w * 0.51, h * 0.72, w * 0.53, h * 0.60);
    path.cubicTo(w * 0.58, h * 0.66, w * 0.61, h * 0.80, w * 0.63, h * 0.95); // right leg outer
    path.cubicTo(w * 0.65, h * 0.98, w * 0.71, h * 0.98, w * 0.73, h * 0.95);
    path.cubicTo(w * 0.71, h * 0.78, w * 0.67, h * 0.62, w * 0.63, h * 0.58);
    path.cubicTo(w * 0.68, h * 0.50, w * 0.69, h * 0.40, w * 0.67, h * 0.30);
    path.cubicTo(w * 0.71, h * 0.38, w * 0.75, h * 0.44, w * 0.78, h * 0.46); // right hand area
    path.cubicTo(w * 0.81, h * 0.42, w * 0.80, h * 0.36, w * 0.75, h * 0.28);
    path.cubicTo(w * 0.71, h * 0.20, w * 0.65, h * 0.16, w * 0.55, h * 0.135);
    path.cubicTo(w * 0.52, h * 0.155, w * 0.48, h * 0.155, w * 0.40, h * 0.135);
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant _BodyPainter oldDelegate) =>
      oldDelegate.glowColor != glowColor || oldDelegate.pulseValue != pulseValue;
}
