class TremorReading {
  final int? id;
  final DateTime timestamp;
  final int tremorType;
  final double frequency;
  final double amplitude;
  final int confidence;
  final int heartRate;
  final double temperature;
  
  TremorReading({
    this.id,
    required this.timestamp,
    required this.tremorType,
    required this.frequency,
    required this.amplitude,
    required this.confidence,
    required this.heartRate,
    required this.temperature,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'tremor_type': tremorType,
      'frequency': frequency,
      'amplitude': amplitude,
      'confidence': confidence,
      'heart_rate': heartRate,
      'temperature': temperature,
    };
  }
  
  factory TremorReading.fromMap(Map<String, dynamic> map) {
    return TremorReading(
      id: map['id'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      tremorType: map['tremor_type'],
      frequency: map['frequency'],
      amplitude: map['amplitude'],
      confidence: map['confidence'],
      heartRate: map['heart_rate'],
      temperature: map['temperature'],
    );
  }
}
