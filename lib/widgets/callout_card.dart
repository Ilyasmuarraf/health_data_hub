import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'pressable_scale.dart';

/// The small bordered "Recovery phase with mild discomfort noted" style
/// annotation card that floats around organ renders and the body map.
/// A glowing dot sits on the side nearest the organ, and an optional
/// "View in Details →" link can be tapped to drill into a specific
/// condition screen.
class CalloutCard extends StatelessWidget {
  final String text;
  final Color color;
  final bool dotOnRight;
  final bool hasViewDetails;
  final VoidCallback? onViewDetails;

  const CalloutCard({
    super.key,
    required this.text,
    required this.color,
    this.dotOnRight = false,
    this.hasViewDetails = false,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 140),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: color, width: 1.0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 10, height: 1.3),
          ),
          if (hasViewDetails) ...[
            const SizedBox(height: 4),
            PressableScale(
              onTap: onViewDetails,
              child: Text(
                'View in Details →',
                style: TextStyle(
                  color: color,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!dotOnRight) ...[_buildDot(), const SizedBox(width: 8)],
        card,
        if (dotOnRight) ...[const SizedBox(width: 8), _buildDot()],
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 6, spreadRadius: 2)],
      ),
    );
  }
}
