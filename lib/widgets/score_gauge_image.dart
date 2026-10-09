import 'package:flutter/material.dart';
import '../core/app_assets.dart';
import '../core/app_theme.dart';
import '../painters/circular_score_gauge.dart';

/// Uses the exact exported gauge image for the score's bucket (green
/// ≥70 / yellow 40-69 / red <40) instead of a painted approximation —
/// per direct instruction, UI exactness takes priority over a fully
/// continuous dynamic gauge. The three bucket images are pixel-exact to
/// Figma for 76% / 66% / 30%; every score in this build is intentionally
/// snapped to one of those three exact values (see organ_data_model.dart)
/// so the baked-in percentage text in each image is always correct.
///
/// If the image is ever missing, falls back to the fully-dynamic painted
/// [CircularScoreGauge] so the app never breaks for an arbitrary score.
class ScoreGaugeImage extends StatelessWidget {
  final int score;
  final double size;

  const ScoreGaugeImage({super.key, required this.score, this.size = 240});

  String get _assetPath {
    if (score >= 70) return AppAssets.gaugeGreen;
    if (score >= 40) return AppAssets.gaugeYellow;
    return AppAssets.gaugeRed;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        _assetPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => CircularScoreGauge(
          percentage: score / 100,
          themeColor: gaugeColorForScore(score),
          size: size,
        ),
      ),
    );
  }
}
