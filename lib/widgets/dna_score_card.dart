import 'package:flutter/material.dart';
import '../core/app_assets.dart';
import '../core/app_theme.dart';

/// The "Hyperprolactinemia Score" card — a compact two-zone card meant to
/// sit in a Row next to the "ABOUT ..." paragraph (see
/// PhenotypeOverviewScreen), NOT a full-width bar. Two stacked zones:
///  1. The DNA-helix image with the title/subtitle overlaid on top.
///  2. A separate, slightly darker box below with plain "0% / 95% / 100%"
///     text and a caption — there is intentionally NO slider/progress
///     bar graphic here, just text, matching the reference exactly.
class DnaScoreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String caption;
  final double percent; // 0.0 - 1.0

  const DnaScoreCard({
    super.key,
    required this.title,
    this.subtitle = 'From all projects',
    this.caption = 'Based on Hormone',
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final pct = '${(percent.clamp(0.0, 1.0) * 100).round()}%';

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1330),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentBlue.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Zone 1: DNA image with title overlaid on top.
          Stack(
            children: [
              Image.asset(
                AppAssets.dnaHelix,
                width: double.infinity,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: double.infinity,
                  height: 110,
                  color: const Color(0xFF0B1330),
                  child: const Icon(Icons.biotech,
                      color: AppColors.accentCyan, size: 36),
                ),
              ),
              Positioned(
                left: 10,
                top: 8,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTheme.heading(fontSize: 11, color: AppColors.textPrimary)),
                    Text(subtitle,
                        style: AppTheme.body(
                            fontSize: 8, color: AppColors.textTertiary)),
                  ],
                ),
              ),
            ],
          ),
          // Zone 2: plain text stat row, no bar/slider graphic.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: const Color(0xFF111A3D),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('0%',
                        style: AppTheme.body(
                            fontSize: 9, color: AppColors.textTertiary)),
                    Text(pct,
                        style: AppTheme.heading(
                            fontSize: 22, color: AppColors.textPrimary)),
                    Text('100%',
                        style: AppTheme.body(
                            fontSize: 9, color: AppColors.textTertiary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(caption,
                    style: AppTheme.body(
                        fontSize: 9, color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
