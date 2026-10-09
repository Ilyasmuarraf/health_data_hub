import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_assets.dart';
import '../screens/ldl_details_screen.dart';
import 'pressable_scale.dart';
import 'fade_slide_in.dart';

/// The glassmorphic "Organ Metrics" picker. Every row staggers in with a
/// short fade+slide when the panel opens — recreated fresh (via the
/// caller passing a fresh [Key] each time it's shown) so the animation
/// replays on every open, not just the first.
class FloatingOrganDropdown extends StatelessWidget {
  final ValueChanged<String> onOrganSelected;

  const FloatingOrganDropdown({super.key, required this.onOrganSelected});

  static const List<Map<String, String>> _organs = [
    {'name': 'Heart', 'image': AppAssets.heart},
    {'name': 'Lungs', 'image': AppAssets.lungs},
    {'name': 'Kidneys', 'image': AppAssets.kidney},
    {'name': 'Brain', 'image': AppAssets.brain},
    {'name': 'Bones', 'image': AppAssets.spine},
    {'name': 'Stomach', 'image': AppAssets.stomach},
    {'name': 'Intestine', 'image': AppAssets.intestine},
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: 220,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF232323).withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Organ Metrics', style: AppTheme.heading(fontSize: 14)),
                    const Icon(Icons.arrow_drop_up, color: Colors.white54, size: 20),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, thickness: 1),
              for (int i = 0; i < _organs.length; i++)
                FadeSlideIn(
                  delay: Duration(milliseconds: 40 * i),
                  duration: const Duration(milliseconds: 280),
                  slideFrom: 10,
                  child: PressableScale(
                    onTap: () => onOrganSelected(_organs[i]['name']!),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Image.asset(
                            _organs[i]['image']!,
                            width: 24,
                            height: 24,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.circle,
                                size: 20,
                                color: Colors.white38),
                          ),
                          const SizedBox(width: 16),
                          Text(_organs[i]['name']!,
                              style: AppTheme.body(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              FadeSlideIn(
                delay: Duration(milliseconds: 40 * _organs.length),
                duration: const Duration(milliseconds: 280),
                slideFrom: 10,
                child: PressableScale(
                  onTap: () {
                    onOrganSelected('Heart');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LdlDetailsScreen()),
                    );
                  },
                  child: _buildBottomButton('Blood Metrics'),
                ),
              ),
              FadeSlideIn(
                delay: Duration(milliseconds: 40 * (_organs.length + 1)),
                duration: const Duration(milliseconds: 280),
                slideFrom: 10,
                child: PressableScale(
                  onTap: () {},
                  child: _buildBottomButton('Hormone'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: const Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Text(title,
            style: AppTheme.body(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ),
    );
  }
}
