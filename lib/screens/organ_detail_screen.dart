import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/organ_data_model.dart';
import '../widgets/organ_3d_callout_view.dart';
import '../widgets/floating_organ_dropdown.dart';
import '../widgets/strengths_weaknesses_widget.dart';
import '../widgets/risk_assessment_table.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/gradient_screen_background.dart';
import '../widgets/gradient_border_card.dart';
import '../widgets/score_gauge_image.dart';
import 'condition_detail_screen.dart';

/// Shows the overall condition of a single organ: score gauge, bulleted
/// health recommendation, strengths & weaknesses, and the risk table.
/// Works for any organ backed by [OrganDataModel.forOrgan].
class OrganDetailScreen extends StatefulWidget {
  final String organName;

  const OrganDetailScreen({super.key, this.organName = 'Heart'});

  @override
  State<OrganDetailScreen> createState() => _OrganDetailScreenState();
}

class _OrganDetailScreenState extends State<OrganDetailScreen> {
  bool _isMenuOpen = false;
  int _menuOpenToken = 0; // bumped each open so the dropdown's staggered
  // item entrance animation replays every time, not just on first mount.
  late String _selectedOrgan = widget.organName;
  late OrganDataModel _data = OrganDataModel.forOrgan(_selectedOrgan);

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) _menuOpenToken++;
    });
  }

  void _handleOrganSelection(String organ) {
    setState(() {
      _selectedOrgan = organ;
      _isMenuOpen = false;
      _data = OrganDataModel.forOrgan(organ);
    });
  }

  void _openConditionDetails(ConditionData condition) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConditionDetailScreen(condition: condition),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHealthy = _data.healthScore >= 40;
    final glowTint = _data.healthScore >= 70
        ? ScreenGlowTint.green
        : (_data.healthScore >= 40 ? ScreenGlowTint.yellow : ScreenGlowTint.red);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Phenotype'),
        actions: [
          IconButton(icon: const Icon(Icons.psychology_alt), onPressed: _toggleMenu),
        ],
      ),
      body: GradientScreenBackground(
        tint: glowTint,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text('$_selectedOrgan Conditions Overview',
                      style: AppTheme.heading(fontSize: 17)),
                  const SizedBox(height: 16),
                  FadeSlideIn(
                    child: Organ3DCalloutView(
                      imagePath: _data.imagePath,
                      callouts: _data.callouts,
                      onCalloutViewDetails: (callout) {
                        if (_data.featuredCondition != null) {
                          _openConditionDetails(_data.featuredCondition!);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(_data.conditionTitle,
                      style: AppTheme.heading(fontSize: 20)),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    child: ScoreGaugeImage(
                        score: _data.healthScore,
                        size: 300),
                  ),
                  const SizedBox(height: 40),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GradientBorderCard(
                        borderColors: isHealthy
                            ? [
                                AppColors.accentCyan.withOpacity(0.9),
                                AppColors.accentBlue.withOpacity(0.4),
                              ]
                            : [
                                AppColors.criticalRed.withOpacity(0.9),
                                AppColors.criticalRed.withOpacity(0.25),
                              ],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_data.recommendationTitle,
                                style: AppTheme.heading(fontSize: 13)),
                            const SizedBox(height: 8),
                            Text(_data.recommendationIntro,
                                style: AppTheme.body(fontSize: 11, height: 1.5)),
                            const SizedBox(height: 6),
                            ..._data.recommendationBullets.map(
                              (bullet) => Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('•  ', style: AppTheme.body(fontSize: 12)),
                                    Expanded(
                                      child: Text(bullet,
                                          style: AppTheme.body(fontSize: 11, height: 1.5)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StrengthsWeaknessesWidget(
                        strengths: _data.strengths,
                        weaknesses: _data.weaknesses,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 250),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RiskAssessmentTable(
                          title: _data.riskTableTitle,
                          metrics: _data.riskAssessments),
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
