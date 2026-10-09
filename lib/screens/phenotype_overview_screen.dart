import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../core/app_assets.dart';
import '../painters/bezier_chart_painter.dart';
import '../painters/body_silhouette_painter.dart';
import '../widgets/strengths_weaknesses_widget.dart';
import '../widgets/toggle_pill_selector.dart';
import '../widgets/chart_legend.dart';
import '../widgets/dna_score_card.dart';
import '../widgets/callout_card.dart';
import '../widgets/fade_slide_in.dart';
import '../widgets/gradient_screen_background.dart';
import '../widgets/gradient_border_card.dart';
import '../widgets/floating_organ_dropdown.dart';
import '../widgets/score_gauge_image.dart';
import 'organ_detail_screen.dart';

class PhenotypeOverviewScreen extends StatefulWidget {
  const PhenotypeOverviewScreen({super.key});

  @override
  State<PhenotypeOverviewScreen> createState() =>
      _PhenotypeOverviewScreenState();
}

class _PhenotypeOverviewScreenState extends State<PhenotypeOverviewScreen>
    with TickerProviderStateMixin {
  String _genoPhenoSelection = 'Phenotype';
  String _hormoneSelection = 'Serotonin';
  bool _isMenuOpen = false;
  int _menuOpenToken = 0;

  // Slow breathing pulse driving the glow on the (fallback) body
  // silhouette's joints — a small ambient micro-interaction so the hero
  // section doesn't feel static even before the real render loads.
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  // Phase-colored data for the "Dopamine Levels During Physical Activity"
  // chart, matched against the reference: green = Warm Up (the first
  // rising/falling hump), orange = Recovery (the middle undulation),
  // red = Peak Activity (the final steep dip/climb — the most volatile
  // segment, matching the legend's red dot for "Peak Activity").
  static const _warmUp = AppColors.optimalGreen;
  static const _recovery = Color(0xFFFF9F45);
  static const _peak = AppColors.criticalRed;

  static final List<ChartPoint> _chartPoints = [
    ChartPoint(x: 0, y: 78, color: _warmUp),
    ChartPoint(x: 12, y: 95, color: _warmUp),
    ChartPoint(x: 25, y: 78, color: _warmUp),
    ChartPoint(x: 35, y: 60, color: _warmUp),
    ChartPoint(x: 50, y: 83, color: _recovery),
    ChartPoint(x: 58, y: 79, color: _recovery),
    ChartPoint(x: 68, y: 83, color: _recovery),
    ChartPoint(x: 75, y: 78, color: _recovery),
    ChartPoint(x: 80, y: 60, color: _peak),
    ChartPoint(x: 92, y: 87, color: _peak),
    ChartPoint(x: 103, y: 52, color: _peak),
    ChartPoint(x: 120, y: 64, color: _peak),
  ];

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) _menuOpenToken++;
    });
  }

  void _handleOrganSelection(String organ) {
    setState(() => _isMenuOpen = false);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OrganDetailScreen(organName: organ)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {}),
        title: const Text('Phenotype'),
        actions: [
          IconButton(icon: const Icon(Icons.psychology_alt), onPressed: _toggleMenu),
        ],
      ),
      body: GradientScreenBackground(
        tint: ScreenGlowTint.green,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TogglePillSelector(
                    options: const ['Genotype', 'Phenotype'],
                    selected: _genoPhenoSelection,
                    onChanged: (v) => setState(() => _genoPhenoSelection = v),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text('Health Conditions Overview',
                        style: AppTheme.heading(fontSize: 15)),
                  ),
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const OrganDetailScreen(organName: 'Heart')),
                      ),
                      child: _buildFullBodyMap(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                      child: Container(
                    height: 52,
                    width: 254,
                    decoration: BoxDecoration(
                      // The gradient that will act as the border
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF1FCB4F),
                          Color(0xFFFFFFFF),
                        ],
                        begin: Alignment
                            .topLeft, // Adjust gradient direction if needed
                        end: Alignment.bottomRight,
                      ),
                      // Adjust this radius to match your DualPillToggle's shape
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      // This value determines the border's thickness
                      padding: const EdgeInsets.all(0.5),
                      child: Container(
                        decoration: BoxDecoration(
                          // The background color INSIDE the border (change to match your app)
                          color: Colors.black,
                          // Radius should be slightly smaller than the outer container
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DualPillToggle(
                          optionA: 'Dopamine',
                          optionB: 'Serotonin',
                          selected: _hormoneSelection,
                          onChanged: (v) =>
                              setState(() => _hormoneSelection = v),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 100),
                    child: _buildChartSection(),
                  ),
                  const SizedBox(height: 24),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 150),
                    child: _buildHormoneRow(),
                  ),
                  const SizedBox(height: 32),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 220),
                    child: _buildImmuneSystemSection(),
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

  Widget _buildFullBodyMap() {
    return SizedBox(
      height: 340,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 6,
            // Exact size from Figma: 228 W x 142 H.
            child: Image.asset(
              AppAssets.techPedestal,
              width: 228,
              height: 142,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const SizedBox(width: 228, height: 142),
            ),
          ),
          Positioned(
            bottom: 55,
            child: Image.asset(
              AppAssets.bodySilhouette,
              height: 270,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => BodySilhouetteView(
                height: 270,
                glowColor: AppColors.accentCyan,
                pulse: _pulseController,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CalloutCard(
              text: 'Recovery slight\npain in the left\nside neck.',
              color: AppColors.optimalGreen,
              hasViewDetails: true,
            ),
          ),
          const Positioned(
            top: 70,
            left: 0,
            child: CalloutCard(
              text: 'Chronics Lungs\nProblem',
              color: AppColors.criticalRed,
              dotOnRight: true,
            ),
          ),
          const Positioned(
            bottom: 80,
            left: 10,
            child: CalloutCard(
              text: 'Knee Problems',
              color: AppColors.criticalRed,
              dotOnRight: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // "Meditation Stats" rotated vertically outside the card, on the
        // left edge, matching the reference.
        SizedBox(
          height: 240,
          width: 22,
          child: RotatedBox(
            quarterTurns: 3,
            child: Center(
              child: Text('Meditation Stats',
                  style: AppTheme.heading(fontSize: 13, letterSpacing: 1.4)),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: GradientBorderCard(
            borderColors: [
              AppColors.optimalGreen.withOpacity(0.85),
              AppColors.optimalGreen.withOpacity(0.15),
            ],
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Dopamine Levels During Physical Activity',
                    textAlign: TextAlign.center,
                    style: AppTheme.heading(fontSize: 12)),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    // Subtle "good zone / bad zone" background tint
                    // behind the plot, matching the reference.
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.optimalGreen.withOpacity(0.10),
                              Colors.transparent,
                              AppColors.criticalRed.withOpacity(0.10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BezierLineChart(points: _chartPoints, height: 190),
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: ChartLegend(
                        compact: true,
                        entries: [
                          LegendEntry('Warm Up Phase', _warmUp),
                          LegendEntry('Peak Activity', _peak),
                          LegendEntry('Recovery Phace', _recovery),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHormoneRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DnaScoreCard(
          title: 'Hyperprolactinemia Score',
          percent: 0.95,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ABOUT Hyperprolactinemia',
                  style: AppTheme.heading(fontSize: 13)),
              const SizedBox(height: 8),
              Text(
                'This condition is characterized by abnormally high levels of prolactin in the blood, which can result from various factors, including dopamine dysfunction, certain medications, or tumors of the pituitary gland (prolactinomas).',
                style: AppTheme.body(fontSize: 11, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImmuneSystemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Immune system strength', style: AppTheme.heading(fontSize: 20)),
        const SizedBox(height: 16),
        const Center(child: ScoreGaugeImage(score: 30, size: 300)),
        const SizedBox(height: 24),
        // The recommendation text, Strengths, and Weakness sections are
        // all inside ONE gradient-bordered card in the reference — not
        // three separate blocks.
        GradientBorderCard(
          borderColors: [
            AppColors.accentCyan.withOpacity(0.9),
            AppColors.accentBlue.withOpacity(0.35),
          ],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Immune System Recommendation:',
                  style: AppTheme.heading(fontSize: 15)),
              const SizedBox(height: 10),
              Text(
                'Maintaining a strong immune system is essential for overall health and protection against illness.\nWe recommend:',
                style: AppTheme.body(fontSize: 11, height: 1.5),
              ),
              const SizedBox(height: 4),
              Text(
                '•  Eating a balanced diet rich in fruits, vegetables, and\n   proteins.\n•  Staying hydrated and getting enough sleep (7-8\n   hours).\n•  Regular exercise to boost immunity and reduce stress.',
                style: AppTheme.body(fontSize: 11, height: 1.7),
              ),
              const SizedBox(height: 20),
              const StrengthsWeaknessesWidget(
                strengths: [
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                ],
                weaknesses: [
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                  '0.05 HCV Antibody',
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
