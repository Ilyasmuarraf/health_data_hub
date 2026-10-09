import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/organ_data_model.dart';

/// List of risk-assessment metrics. Each row is a rounded card with a
/// horizontal gradient fill (status color fading to transparent) and a
/// large, bold, right-aligned Orbitron value — matching the reference
/// design's "Chronic ... Risk Assessment" rows — rather than a flat row
/// with only a thin colored border-strip.
class RiskAssessmentTable extends StatelessWidget {
  final String title;
  final List<RiskMetric> metrics;

  const RiskAssessmentTable(
      {super.key, required this.title, required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(title, style: AppTheme.heading(fontSize: 16)),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final metric = metrics[index];
            final color = metric.status.color;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: color.withOpacity(0.45), width: 1),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color.withOpacity(0.30),
                    color.withOpacity(0.04),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(8)
                    ),
                    child: Icon(Icons.verified_outlined,
                        color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(metric.name,
                            style: AppTheme.body(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 4),
                        Text(metric.normalRange,
                            style: AppTheme.body(
                                fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Text(metric.actualValue,
                      style: AppTheme.heading(fontSize: 24, color: color)),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
