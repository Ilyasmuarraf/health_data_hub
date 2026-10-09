import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// Renders the "Strengths :" / "Weakness :" badge grid. Uses a 3-column
/// [GridView] that fills the available width evenly with generous
/// padding — the earlier fixed-90px-wide [Wrap] badges felt visibly
/// compressed compared to the reference, which spaces them out across
/// the full card width.
class StrengthsWeaknessesWidget extends StatelessWidget {
  final List<String> strengths;
  final List<String> weaknesses;

  const StrengthsWeaknessesWidget(
      {super.key, required this.strengths, required this.weaknesses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (strengths.isNotEmpty)
          _buildSection('Strengths :', strengths, AppColors.optimalGreen),
        if (strengths.isNotEmpty && weaknesses.isNotEmpty)
          const SizedBox(height: 22),
        if (weaknesses.isNotEmpty)
          _buildSection('Weakness :', weaknesses, AppColors.criticalRed),
      ],
    );
  }

  Widget _buildSection(String title, List<String> items, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTheme.heading(fontSize: 13)),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 2.23,
          ),
          itemBuilder: (context, index) => _buildBadge(items[index], color),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    final parts = text.split(' ');
    final value = parts.isNotEmpty ? parts.first : '';
    final label = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        border: Border.all(color: color.withOpacity(0.45), width: 1.0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value,
              style: AppTheme.body(
                  color: color, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 3),
          Text(label,
              style: AppTheme.body(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}
