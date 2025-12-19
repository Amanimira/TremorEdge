import 'package:flutter/material.dart';
import 'package:tremor_ring_app/utils/colors.dart';

class TremorRingWidget extends StatelessWidget {
  final double frequency;
  final double amplitude;
  final int confidence;
  final String riskLevel;

  const TremorRingWidget({
    Key? key,
    required this.frequency,
    required this.amplitude,
    required this.confidence,
    required this.riskLevel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 280,
            height: 280,
            child: CircularProgressIndicator(
              value: confidence / 100,
              strokeWidth: 12,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation<Color>(_getRiskColor()),
            ),
          ),
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${frequency.toStringAsFixed(1)} Hz',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Frequency',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _getRiskColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$riskLevel Risk',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: _getRiskColor(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor() {
    if (riskLevel == 'HIGH') return AppColors.error;
    if (riskLevel == 'MODERATE') return AppColors.warning;
    return AppColors.accentGreen;
  }
}