import 'package:flutter/material.dart';
import 'app_assets.dart';
import 'app_theme.dart';

/// A single row in a "Risk Assessment" table (Mentzer, HCV Antibody, etc).
class RiskMetric {
  final String name;
  final String normalRange;
  final String actualValue;
  final RiskStatus status;

  const RiskMetric({
    required this.name,
    required this.normalRange,
    required this.actualValue,
    required this.status,
  });
}

/// Where a floating annotation card sits relative to the organ/body render,
/// and whether it carries a "View in Details →" link.
enum CalloutAnchor { topLeft, topRight, bottomLeft, bottomRight }

class CalloutData {
  final String text;
  final Color color;
  final CalloutAnchor anchor;
  final double offsetTop;
  final double offsetSide;
  final bool hasViewDetails;

  const CalloutData({
    required this.text,
    required this.color,
    required this.anchor,
    required this.offsetTop,
    required this.offsetSide,
    this.hasViewDetails = false,
  });
}

/// A specific flagged condition (e.g. "Heart Attack (Myocardial Infarction)")
/// reached by tapping "View in Details →" on a callout. Rendered with the
/// red/plain-numbered-list layout, weaknesses only.
class ConditionData {
  final String organName;
  final String conditionTitle;
  final int severityScore; // gauge percentage
  final String recommendationBody; // numbered list, \n separated
  final List<String> weaknesses;
  final String riskTableTitle;
  final List<RiskMetric> riskAssessments;

  const ConditionData({
    required this.organName,
    required this.conditionTitle,
    required this.severityScore,
    required this.recommendationBody,
    required this.weaknesses,
    required this.riskTableTitle,
    required this.riskAssessments,
  });

  factory ConditionData.heartAttackMock() {
    return const ConditionData(
      organName: 'Heart',
      conditionTitle: 'Heart Attack (Myocardial Infarction)',
      severityScore: 30,
      recommendationBody:
          '1. Adopt a Heart-Healthy Diet – Eat more fruits, vegetables, whole\ngrains, and lean proteins. Reduce salt, sugar, and unhealthy fats.\n'
          '2. Regular Exercise – Engage in at least 30 minutes of moderate\nexercise (walking, cycling, swimming) most days of the week.\n'
          '3. Manage Stress – Practice meditation, deep breathing, or yoga to\nkeep stress levels in check.\n'
          '4. Quit Smoking & Limit Alcohol – Avoid tobacco and limit alcohol intake\nto protect your heart.\n'
          '5. Monitor Blood Pressure & Cholesterol – Regularly check your vitals\nand follow medical advice if needed.\n'
          '6. Take Prescribed Medications – Follow your doctor\'s\nrecommendations for heart health management.\n'
          '7. Seek Immediate Help for Symptoms – If you experience chest pain,\nshortness of breath, or nausea, get medical help immediately.',
      weaknesses: [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      riskTableTitle: 'Chronic Heart Disease Risk Assessment',
      riskAssessments: [
        RiskMetric(
            name: 'Mentzer',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '16.7',
            status: RiskStatus.moderate),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '56.6',
            status: RiskStatus.good),
        RiskMetric(
            name: 'Apolipoprotine A1',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '14.9',
            status: RiskStatus.critical),
        RiskMetric(
            name: 'Prothorombine Time',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '6.2',
            status: RiskStatus.good),
      ],
    );
  }
}

/// The general "organ overview" screen data — green/cyan themed,
/// bulleted recommendation, both strengths & weaknesses shown.
class OrganDataModel {
  final String organName;
  final String imagePath;
  final String conditionTitle; // "Heart Condition" / "Lungs Condition"
  final int healthScore;
  final String recommendationTitle;
  final String recommendationIntro;
  final List<String> recommendationBullets;
  final List<String> strengths;
  final List<String> weaknesses;
  final String riskTableTitle;
  final List<RiskMetric> riskAssessments;
  final List<CalloutData> callouts;
  final ConditionData? featuredCondition;

  const OrganDataModel({
    required this.organName,
    required this.imagePath,
    required this.conditionTitle,
    required this.healthScore,
    required this.recommendationTitle,
    required this.recommendationIntro,
    required this.recommendationBullets,
    required this.strengths,
    required this.weaknesses,
    required this.riskTableTitle,
    required this.riskAssessments,
    required this.callouts,
    this.featuredCondition,
  });

  factory OrganDataModel.heart() {
    return OrganDataModel(
      organName: 'Heart',
      imagePath: AppAssets.heart,
      conditionTitle: 'Heart Condition',
      healthScore: 76,
      recommendationTitle: 'Heart Health Recommendation :',
      recommendationIntro:
          'Maintaining a healthy heart is essential for overall well-being and\nlongevity.',
      recommendationBullets: const [
        'Eating a heart-friendly diet rich in fruits, vegetables, whole\ngrains, and lean proteins.',
        'Reducing salt, sugar, and unhealthy fats to help manage blood\npressure and cholesterol.',
        'Staying active with regular cardiovascular exercise, such as any\nconcerns early.',
        'Managing stress through relaxation techniques and maintaining.',
      ],
      strengths: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      weaknesses: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      riskTableTitle: 'Chronic Heart Disease Risk Assessment',
      riskAssessments: const [
        RiskMetric(
            name: 'Mentzer',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '16.7',
            status: RiskStatus.moderate),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '56.6',
            status: RiskStatus.good),
        RiskMetric(
            name: 'Apolipoprotine A1',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '14.9',
            status: RiskStatus.critical),
        RiskMetric(
            name: 'Prothorombine Time',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '6.2',
            status: RiskStatus.good),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '26.0',
            status: RiskStatus.good),
      ],
      callouts: [
        CalloutData(
          text: 'Recovery phase\nwith mild\ndiscomfort noted',
          color: AppColors.optimalGreen,
          anchor: CalloutAnchor.topRight,
          offsetTop: 10,
          offsetSide: 0,
          hasViewDetails: true,
        ),
        const CalloutData(
          text: 'Better Cardiac\nCondition than Past',
          color: AppColors.optimalGreen,
          anchor: CalloutAnchor.topLeft,
          offsetTop: 60,
          offsetSide: 0,
        ),
        const CalloutData(
          text: 'Notice a minor\nblockage in the lower\n4 th chamber.',
          color: AppColors.criticalRed,
          anchor: CalloutAnchor.bottomLeft,
          offsetTop: 100,
          offsetSide: 0,
        ),
      ],
      featuredCondition: ConditionData.heartAttackMock(),
    );
  }

  factory OrganDataModel.lungs() {
    return OrganDataModel(
      organName: 'Lungs',
      imagePath: AppAssets.lungs,
      conditionTitle: 'Lungs Condition',
      healthScore: 66,
      recommendationTitle: 'Lungs Health Recommendation :',
      recommendationIntro:
          'Maintaining healthy lungs is essential for overall well-being and\nvitality',
      recommendationBullets: const [
        'Eating a lung-friendly diet rich in fruits, vegetables, whole grains,\nand antioxidants to support respiratory health.',
        'Avoiding smoking, air pollution, and harmful chemicals to protect\nlung function.',
        'Staying active with regular aerobic exercise, such as walking,\nswimming, or cycling, to strengthen lung capacity.',
        'Practicing deep breathing exercises and maintaining good.',
      ],
      strengths: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      weaknesses: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      riskTableTitle: 'Chronic lungs Disease Risk Assessment',
      riskAssessments: const [
        RiskMetric(
            name: 'Mentzer',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '16.7',
            status: RiskStatus.moderate),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '56.6',
            status: RiskStatus.good),
        RiskMetric(
            name: 'Apolipoprotine A1',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '14.9',
            status: RiskStatus.critical),
        RiskMetric(
            name: 'Prothorombine Time',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '6.2',
            status: RiskStatus.good),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '26.0',
            status: RiskStatus.good),
        RiskMetric(
            name: 'Immunoglobulim E2',
            normalRange: '< 152.9 KUI/L',
            actualValue: '69',
            status: RiskStatus.critical),
      ],
      callouts: const [
        CalloutData(
          text: 'Better Respiration\nCondition than Past.',
          color: AppColors.optimalGreen,
          anchor: CalloutAnchor.topLeft,
          offsetTop: 10,
          offsetSide: 0,
        ),
        CalloutData(
          text: 'Recovery phase\nwith better\noxygen Supply',
          color: AppColors.optimalGreen,
          anchor: CalloutAnchor.topRight,
          offsetTop: 50,
          offsetSide: 0,
          hasViewDetails: true,
        ),
        CalloutData(
          text: 'Notice a minor\nblockage in the lower.',
          color: AppColors.criticalRed,
          anchor: CalloutAnchor.bottomLeft,
          offsetTop: 110,
          offsetSide: 0,
        ),
      ],
      // No deep-dive condition mocked for Lungs yet; the callout simply
      // won't be tappable when this is null (handled by the caller).
      featuredCondition: null,
    );
  }

  /// Generic dummy-data factory used for every organ that doesn't have a
  /// bespoke mock yet (Kidneys, Brain, Bones, Stomach, Intestine). Backend
  /// integration is out of scope for this assignment, so each organ gets
  /// plausible placeholder numbers/text rather than silently reusing the
  /// Heart data — this keeps the dropdown functionally correct (every
  /// organ shows its own name/score/content) while remaining clearly
  /// swappable for real data later.
  factory OrganDataModel.placeholder({
    required String organName,
    required String imagePath,
    required int healthScore,
  }) {
    return OrganDataModel(
      organName: organName,
      imagePath: imagePath,
      conditionTitle: '$organName Condition',
      healthScore: healthScore,
      recommendationTitle: '$organName Health Recommendation :',
      recommendationIntro:
          'Maintaining a healthy $organName is essential for overall well-being\nand vitality.',
      recommendationBullets: [
        'Eating a balanced diet rich in fruits, vegetables, and\nlean proteins.',
        'Staying hydrated and getting consistent, quality sleep.',
        'Regular moderate exercise to support long-term $organName function.',
        'Routine checkups to track $organName health over time.',
      ],
      strengths: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      weaknesses: const [
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
        '0.05 HCV Antibody',
      ],
      riskTableTitle: 'Chronic $organName Disease Risk Assessment',
      riskAssessments: const [
        RiskMetric(
            name: 'Mentzer',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '16.7',
            status: RiskStatus.moderate),
        RiskMetric(
            name: 'HCV AntiBody',
            normalRange: '< 0.389',
            actualValue: '56.6',
            status: RiskStatus.good),
        RiskMetric(
            name: 'Apolipoprotine A1',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '14.9',
            status: RiskStatus.critical),
        RiskMetric(
            name: 'Prothorombine Time',
            normalRange: '12.3 - 15.5 secs',
            actualValue: '6.2',
            status: RiskStatus.good),
      ],
      callouts: [
        CalloutData(
          text: 'Stable $organName\nfunction noted\nin latest scan.',
          color: AppColors.optimalGreen,
          anchor: CalloutAnchor.topLeft,
          offsetTop: 20,
          offsetSide: 0,
        ),
        CalloutData(
          text: 'Routine monitoring\nrecommended.',
          color: AppColors.moderateYellow,
          anchor: CalloutAnchor.topRight,
          offsetTop: 20,
          offsetSide: 0,
        ),
      ],
      featuredCondition: null,
    );
  }

  /// Lookup used by the organ dropdown / detail screen. Heart and Lungs
  /// have full bespoke mock data (matching the reference screens exactly);
  /// every other organ uses [OrganDataModel.placeholder] with a distinct
  /// score/name so switching organs always shows organ-specific content.
  static OrganDataModel forOrgan(String organName) {
    switch (organName) {
      case 'Heart':
        return OrganDataModel.heart();
      case 'Lungs':
        return OrganDataModel.lungs();
      case 'Kidneys':
        return OrganDataModel.placeholder(
            organName: 'Kidneys', imagePath: AppAssets.kidney, healthScore: 76);
      case 'Brain':
        return OrganDataModel.placeholder(
            organName: 'Brain', imagePath: AppAssets.brain, healthScore: 30);
      case 'Bones':
        return OrganDataModel.placeholder(
            organName: 'Bones', imagePath: AppAssets.spine, healthScore: 66);
      case 'Stomach':
        return OrganDataModel.placeholder(
            organName: 'Stomach', imagePath: AppAssets.stomach, healthScore: 30);
      case 'Intestine':
        return OrganDataModel.placeholder(
            organName: 'Intestine',
            imagePath: AppAssets.intestine,
            healthScore: 66);
      default:
        return OrganDataModel.heart();
    }
  }
}
