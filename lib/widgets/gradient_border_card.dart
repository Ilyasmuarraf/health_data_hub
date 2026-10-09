import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Recreates the glowing gradient-bordered cards seen at the bottom of
/// most screens (Recommendation cards, Immune System card, etc.) — a
/// gradient stroke around the edge and a subtle dark gradient fill,
/// rather than the flat single-color border/background Flutter's
/// [BoxDecoration.border] can do natively (which only supports solid
/// colors). Implemented with the classic "double container" trick: an
/// outer container painted with the border gradient, padded by
/// [borderWidth], containing an inner container with the fill gradient.
class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final List<Color> borderColors;
  final List<Color>? fillColors;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;

  const GradientBorderCard({
    super.key,
    required this.child,
    required this.borderColors,
    this.fillColors,
    this.borderWidth = 1.4,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.all(16),
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final fill = fillColors ??
        [
          AppColors.cardSurface,
          Color.lerp(AppColors.cardSurface, borderColors.first, 0.10)!,
        ];

    return Container(
      margin: margin,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: borderColors,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColors.first.withOpacity(0.25),
            blurRadius: 18,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: fill,
          ),
        ),
        child: child,
      ),
    );
  }
}
