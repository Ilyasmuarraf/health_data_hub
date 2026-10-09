import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class LegendEntry {
  final String label;
  final Color color;
  const LegendEntry(this.label, this.color);
}

/// Small "● Label" list shown as a floating semi-transparent chip in the
/// top-right corner of a chart (matching the reference design), rather
/// than a horizontal row above the chart title.
class ChartLegend extends StatelessWidget {
  final List<LegendEntry> entries;
  final bool compact;

  const ChartLegend({super.key, required this.entries, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: entries
          .map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration:
                          BoxDecoration(color: e.color, shape: BoxShape.circle, boxShadow: [
                        BoxShadow(color: e.color.withOpacity(0.8), blurRadius: 4),
                      ]),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      e.label,
                      style: AppTheme.body(fontSize: 8, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ))
          .toList(),
    );

    if (!compact) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: content,
    );
  }
}
