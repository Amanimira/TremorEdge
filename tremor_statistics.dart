class TremorStatistics {
  final DateTime startDate;
  final DateTime endDate;
  final int totalReadings;
  final double averageFrequency;
  final double averageAmplitude;
  final double averageConfidence;
  final int restingTremorCount;
  final int posturalTremorCount;
  final int kineticTremorCount;
  final int normalCount;
  final double highRiskPercentage;
  final double mediumRiskPercentage;
  final int totalTremorEvents;
  
  TremorStatistics({
    required this.startDate,
    required this.endDate,
    required this.totalReadings,
    required this.averageFrequency,
    required this.averageAmplitude,
    required this.averageConfidence,
    required this.restingTremorCount,
    required this.posturalTremorCount,
    required this.kineticTremorCount,
    required this.normalCount,
    required this.highRiskPercentage,
    required this.mediumRiskPercentage,
    required this.totalTremorEvents,
  });
  
  String get durationDays {
    return endDate.difference(startDate).inDays.toString();
  }
  
  String get dominantTremorType {
    if (restingTremorCount > posturalTremorCount && restingTremorCount > kineticTremorCount) {
      return 'Resting (PD)';
    } else if (posturalTremorCount > kineticTremorCount) {
      return 'Postural (ET)';
    } else if (kineticTremorCount > 0) {
      return 'Kinetic';
    }
    return 'Normal';
  }
  
  double get riskScore {
    return (highRiskPercentage * 100 + mediumRiskPercentage * 50) / 100;
  }
}
