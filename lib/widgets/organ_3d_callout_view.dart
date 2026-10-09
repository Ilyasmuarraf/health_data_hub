import 'package:flutter/material.dart';
import '../core/app_assets.dart';
import '../core/app_theme.dart';
import '../core/organ_data_model.dart';
import 'callout_card.dart';

/// The hero section at the top of the organ detail screen: the organ
/// render floating above a glowing tech pedestal, surrounded by
/// annotation callouts driven by [callouts].
class Organ3DCalloutView extends StatelessWidget {
  final String imagePath;
  final List<CalloutData> callouts;
  final ValueChanged<CalloutData>? onCalloutViewDetails;

  const Organ3DCalloutView({
    super.key,
    required this.imagePath,
    this.callouts = const [],
    this.onCalloutViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient glow behind the organ
          Positioned(
            bottom: 40,
            child: Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.accentBlue.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 10),
                ],
              ),
            ),
          ),
          // Tech pedestal graphic under the organ
          Positioned(
            bottom: 10,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset(
                AppAssets.techPedestal,
                height: 90,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _pedestalFallback(),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            child: Image.asset(
              imagePath,
              height: 260,  
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.favorite,
                size: 180,
                color: AppColors.criticalRed,
              ),
            ),
          ),
          for (final callout in callouts)
            _positionedCallout(callout),
        ],
      ),
    );
  }

  Widget _positionedCallout(CalloutData callout) {
    final dotOnRight = callout.anchor == CalloutAnchor.topLeft ||
        callout.anchor == CalloutAnchor.bottomLeft;

    final card = CalloutCard(
      text: callout.text,
      color: callout.color,
      dotOnRight: dotOnRight,
      hasViewDetails: callout.hasViewDetails,
      onViewDetails: callout.hasViewDetails
          ? () => onCalloutViewDetails?.call(callout)
          : null,
    );

    switch (callout.anchor) {
      case CalloutAnchor.topLeft:
        return Positioned(top: callout.offsetTop, left: callout.offsetSide, child: card);
      case CalloutAnchor.topRight:
        return Positioned(top: callout.offsetTop, right: callout.offsetSide, child: card);
      case CalloutAnchor.bottomLeft:
        return Positioned(bottom: callout.offsetTop, left: callout.offsetSide, child: card);
      case CalloutAnchor.bottomRight:
        return Positioned(bottom: callout.offsetTop, right: callout.offsetSide, child: card);
    }
  }

  /// Simple painted stand-in used only if `tech-pedestal.png` hasn't been
  /// added to assets/images yet, so the layout never breaks.
  Widget _pedestalFallback() {
    return Container(
      width: 160,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        gradient: const LinearGradient(
          colors: [AppColors.accentBlue, AppColors.accentCyan],
        ),
      ),
    );
  }
}
