/// Central registry for every bundled image path so screens never hardcode
/// asset strings directly. Keep this in sync with the `assets/images/`
/// folder declared in pubspec.yaml.
///
/// IMPORTANT — place these exact files under `assets/images/` (rename from
/// whatever the export/download gave them):
///   platform.png        <- the glowing tech-pedestal graphic
///   ellipse-glow.png     <- warm radial glow used behind screen headers
///   hormone-dna.png      <- small DNA-helix thumbnail
///   human-body.png       <- the full-body x-ray/scan render
/// All four now have real files — Image.asset is the primary render path,
/// with a CustomPainter/graceful fallback kept only for safety.
class AppAssets {
  AppAssets._();

  // Organs — still awaiting real exports; Image.asset falls back to a
  // small icon via errorBuilder until these exist.
  static const String heart = 'assets/images/heart-organ.png';
  static const String lungs = 'assets/images/lungs-organ-1.png';
  static const String kidney = 'assets/images/kidney-organ-1.png';
  static const String brain = 'assets/images/brain-organ-1.png';
  static const String spine = 'assets/images/spine--1.png';
  static const String stomach = 'assets/images/stomach-organ-1.png';
  static const String intestine = 'assets/images/intestine-organ-1.png';

  // Full body x-ray/scan render used on the Phenotype Overview screen.
  static const String bodySilhouette = 'assets/images/human-body.png';

  // Glowing tech pedestal under every organ / body render.
  static const String techPedestal = 'assets/images/platform.png';

  // Small DNA helix icon used in the Hyperprolactinemia score card.
  static const String dnaHelix = 'assets/images/hormone-dna.png';

  // Warm radial glow used behind the header of most screens (re-tinted
  // per screen via ColorFiltered — see widgets/gradient_background.dart).
  static const String glowEllipse = 'assets/images/ellipse-glow.png';

  // The three exact gauge renders from Figma, used directly instead of a
  // painted approximation (see widgets/score_gauge_image.dart). Bucketed
  // by score: green = healthy (>=70), yellow = moderate (40-69),
  // red = critical (<40).
  static const String gaugeGreen = 'assets/images/graph2.png'; // 76%
  static const String gaugeYellow = 'assets/images/graph1.png'; // 66%
  static const String gaugeRed = 'assets/images/graph3.png'; // 30%
}
