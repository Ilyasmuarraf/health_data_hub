import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// The single-track segmented control used at the top of the Phenotype
/// Overview screen ("Genotype" / "Phenotype"), where both options share
/// one pill-shaped background and the active side gets a filled chip.
class TogglePillSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const TogglePillSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      width:316,
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: options
            .map((option) => Expanded(
                  child: _option(option, option == selected),
                ))
            .toList(),
      ),
    );
  }

  Widget _option(String title, bool isSelected) {
    return GestureDetector(
      onTap: () => onChanged(title),
      child: AnimatedContainer(
        width: 137,
        height: 33,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white12 : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// The two-separate-pills toggle used under the body map ("Dopamine" /
/// "Serotonin"), where the active option is a filled colored pill and the
/// inactive one is just an outline.
class DualPillToggle extends StatelessWidget {
  final String optionA;
  final String optionB;
  final String selected;
  final Color activeColor;
  final ValueChanged<String> onChanged;

  const DualPillToggle({
    super.key,
    required this.optionA,
    required this.optionB,
    required this.selected,
    required this.onChanged,
    this.activeColor = AppColors.optimalGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pill(optionA),
        const SizedBox(width: 12),
        _pill(optionB),
      ],
    );
  }

  Widget _pill(String label) {
    final bool isActive = label == selected;
    return GestureDetector(
      onTap: () => onChanged(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? activeColor : const Color.fromARGB(0, 255, 255, 255),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
