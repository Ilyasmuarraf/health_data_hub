import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../painters/segmented_range_gauge_painter.dart';
import '../widgets/parameter_expand_tile.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/gradient_screen_background.dart';

class LdlDetailsScreen extends StatelessWidget {
  const LdlDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Mentzer'),
      ),
      body: GradientScreenBackground(
        tint: ScreenGlowTint.amber,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              FadeSlideIn(child: _buildHeaderStat()),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: const Duration(milliseconds: 80),
                child: Center(
                  child: SizedBox(
                    width: 280,
                    height: 160,
                    child: CustomPaint(
                        painter: SegmentedRangeGaugePainter(score: 36.7)),
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border.all(
                        color: AppColors.moderateYellow, width: 1.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Moderate 36.7',
                      style: AppTheme.body(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.moderateYellow)),
                ),
              ),
              const SizedBox(height: 40),
              Text('RANGES',
                  style: AppTheme.heading(fontSize: 14, letterSpacing: 1.2)),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 120),
                child: _buildRangeLegend(),
              ),
              const SizedBox(height: 40),
              Text(
                  'Parameters that are generally impacted by LDL Cholesterol:',
                  style: AppTheme.body(fontSize: 13)),
              const SizedBox(height: 16),
              FadeSlideIn(
                delay: const Duration(milliseconds: 160),
                child: const ParameterExpandTile(
                  title: 'Diet (saturated fat, sugar intake)',
                  description:
                      'Limit saturated fats and sugars to keep arteries clear and\ncholesterol in check.',
                ),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 200),
                child: const ParameterExpandTile(
                  title: 'Physical activity levels',
                  description:
                      'Regular exercise strengthens the heart and improves circulation',
                ),
              ),
              FadeSlideIn(
                delay: const Duration(milliseconds: 240),
                child: const ParameterExpandTile(
                  title: 'Body weight and waist circumference',
                  description:
                      'Maintaining a healthy weight reduces strain on the heart and lowers risk\nfactors.',
                ),
              ),
              const SizedBox(height: 14),
              Text('ABOUT LDL CHOLESTEROL', style: AppTheme.heading(fontSize: 12)),
              const SizedBox(height: 12),
              Text(
                'LDL Cholesterol, often referred to as "bad cholesterol," plays\na key role in heart health. Elevated LDL levels can lead to the\nbuildup of plaque in arteries, increasing the risk of heart\ndisease and stroke. Key functions and impacts of LDL\ncholesterol in the body include',
                style: AppTheme.body(fontSize: 11, height: 1.5),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('36.7', style: AppTheme.heading(fontSize: 34)),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 4),
          child: Text('mcg/dl', style: AppTheme.body(fontSize: 12)),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildRangeLegend() {
    return Column(
      children: [
        _legendRow(const Color(0xFFFF5252), '< 4.46 mcg/dL', 'VERY LOW',
            const Color(0xFFFFEE58), '< 6.46 mcg/dL', 'OPTIMAL'),
        const SizedBox(height: 18),
        _legendRow(const Color(0xFFFF8A65), '< 8.46 mcg/dL', 'LOW',
            const Color(0xFF66BB6A), '88.46 - 9.2 mcg/dL', 'HIGH'),
        const SizedBox(height: 18),
        _legendRow(const Color(0xFFFFEE58), '4.46 mcg/dL', 'MODERATE',
            const Color(0xFF2E7D32), '< 10.46 - 22.0 mg/dL', 'VERY HIGH'),
      ],
    );
  }

  Widget _legendRow(
      Color c1, String v1, String t1, Color c2, String v2, String t2) {
    return Row(
      children: [
        Expanded(child: _legendItem(c1, v1, t1)),
        Expanded(child: _legendItem(c2, v2, t2)),
      ],
    );
  }

  Widget _legendItem(Color color, String value, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.7),
                blurRadius: 14,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: AppTheme.body(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text(text, style: AppTheme.body(fontSize: 10)),
          ],
        ),
      ],
    );
  }
}
