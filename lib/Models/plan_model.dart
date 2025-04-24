class PlanModel {
  final int id;
  final String name;
  final bool enableStreaming;
  final bool enableFullStreamStorage;
  final bool enableAIDetection;
  final bool enableAIChunkStorage;
  final int fullStreamRetentionHours;
  final int aiChunkRetentionHours;
  final int maxTotalStorageMB;

  PlanModel({
    required this.id,
    required this.name,
    required this.enableStreaming,
    required this.enableFullStreamStorage,
    required this.enableAIDetection,
    required this.enableAIChunkStorage,
    required this.fullStreamRetentionHours,
    required this.aiChunkRetentionHours,
    required this.maxTotalStorageMB,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'],
      name: json['name'],
      enableStreaming: json['enableStreaming'],
      enableFullStreamStorage: json['enableFullStreamStorage'],
      enableAIDetection: json['enableAIDetection'],
      enableAIChunkStorage: json['enableAIChunkStorage'],
      fullStreamRetentionHours: json['fullStreamRetentionHours'],
      aiChunkRetentionHours: json['aiChunkRetentionHours'],
      maxTotalStorageMB: json['maxTotalStorageMB'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'enableStreaming': enableStreaming,
      'enableFullStreamStorage': enableFullStreamStorage,
      'enableAIDetection': enableAIDetection,
      'enableAIChunkStorage': enableAIChunkStorage,
      'fullStreamRetentionHours': fullStreamRetentionHours,
      'aiChunkRetentionHours': aiChunkRetentionHours,
      'maxTotalStorageMB': maxTotalStorageMB,
    };
  }
}
