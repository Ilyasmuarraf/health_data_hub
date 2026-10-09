import 'package:flutter/material.dart';
import '../core/app_assets.dart';
import '../core/app_theme.dart';

/// Wraps a screen's body in the soft radial glow visible behind the header
/// on every reference screen — warm amber on the LDL screen, green on
/// healthy-organ screens, red on flagged-condition screens. Uses the real
/// `ellipse-glow.png` export, re-tinted per screen with [tint] via
/// [BlendMode.modulate] (falls back to a painted radial gradient if the
/// asset is missing, so the layout never breaks).
class GradientScreenBackground extends StatelessWidget {
  final ScreenGlowTint tint;
  final Widget child;
  final double glowHeight;

  const GradientScreenBackground({
    super.key,
    required this.tint,
    required this.child,
    this.glowHeight = 360,
  });

  @override
  Widget build(BuildContext context) {
    final color = tint.color;
    final isNativeTint = tint == ScreenGlowTint.amber;
    return Container(
      color: AppColors.background,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: glowHeight,
            child: isNativeTint
                // ellipse-glow.png is itself a warm amber glow — used
                // untouched on the screen it was designed for (LDL).
                ? Image.asset(
                    AppAssets.glowEllipse,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _paintedFallback(color),
                  )
                // Every other screen re-tints the same asset to its own
                // theme color (green/red/yellow) via BlendMode.modulate.
                : ColorFiltered(
                    colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                    child: Image.asset(
                      AppAssets.glowEllipse,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _paintedFallback(color),
                    ),
                  ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _paintedFallback(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.1,
          colors: [color.withOpacity(0.35), Colors.transparent],
        ),
      ),
    );
  }
}
