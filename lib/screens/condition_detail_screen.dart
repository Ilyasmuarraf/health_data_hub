import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/organ_data_model.dart';
import '../widgets/strengths_weaknesses_widget.dart';
import '../widgets/risk_assessment_table.dart';
import '../widgets/floating_organ_dropdown.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/gradient_screen_background.dart';
import '../widgets/gradient_border_card.dart';
import '../widgets/score_gauge_image.dart';
import 'organ_detail_screen.dart';

/// The "View in Details →" deep-dive for a specific flagged condition
/// (e.g. Heart Attack / Myocardial Infarction). Always red-themed with a
/// plain numbered recommendation and weaknesses only — distinct from the
/// green/cyan bulleted layout of [OrganDetailScreen]. The reference design
/// also shows the Organ Metrics dropdown overlaying this screen, so the
/// tune icon behaves the same way here: picking a different organ jumps
/// straight to that organ's overview.
class ConditionDetailScreen extends StatefulWidget {
  final ConditionData condition;

  const ConditionDetailScreen({super.key, required this.condition});

  @override
  State<ConditionDetailScreen> createState() => _ConditionDetailScreenState();
}

class _ConditionDetailScreenState extends State<ConditionDetailScreen> {
  bool _isMenuOpen = false;
  int _menuOpenToken = 0;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) _menuOpenToken++;
    });
  }

  void _handleOrganSelection(String organ) {
    setState(() => _isMenuOpen = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrganDetailScreen(organName: organ)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final condition = widget.condition;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Phenotype'),
        actions: [
          IconButton(icon: const Icon(Icons.tune), onPressed: _toggleMenu),
        ],
      ),
      body: GradientScreenBackground(
        tint: ScreenGlowTint.red,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(condition.conditionTitle,
                        textAlign: TextAlign.center,
                        style: AppTheme.heading(fontSize: 14)),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    child: ScoreGaugeImage(
                      score: condition.severityScore,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 40),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GradientBorderCard(
                        borderColors: [
                          AppColors.criticalRed.withOpacity(0.9),
                          AppColors.criticalRed.withOpacity(0.25),
                        ],
                        child: Text(
                          'For individuals who have experienced\na heart attack (myocardial infarction),\nit is crucial to follow these health\nrecommendations:\n\n${condition.recommendationBody}',
                          style: AppTheme.body(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StrengthsWeaknessesWidget(
                        strengths: const [],
                        weaknesses: condition.weaknesses,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RiskAssessmentTable(
                          title: condition.riskTableTitle,
                          metrics: condition.riskAssessments),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 16,
              child: IgnorePointer(
                ignoring: !_isMenuOpen,
                child: AnimatedOpacity(
                  opacity: _isMenuOpen ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedScale(
                    scale: _isMenuOpen ? 1 : 0.85,
                    alignment: Alignment.topRight,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: FloatingOrganDropdown(
                      key: ValueKey(_menuOpenToken),
                      onOrganSelected: _handleOrganSelection,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
