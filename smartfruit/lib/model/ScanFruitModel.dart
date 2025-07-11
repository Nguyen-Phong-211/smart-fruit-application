class ScanFruitResult {
  final String fruitName;
  final double freshnessPercent;
  final String freshnessStatus;

  ScanFruitResult({
    required this.fruitName,
    required this.freshnessPercent,
    required this.freshnessStatus,
  });

  factory ScanFruitResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return ScanFruitResult(
      fruitName: data['fruit'] ?? 'Unknown',
      freshnessPercent: (data['freshness_percent'] as num).toDouble(),
      freshnessStatus: data['freshness'] ?? 'Unknown',
    );
  }
}

class ScanSaveRequest {
  final String image;
  final String fruit;
  final double freshnessPercent;
  final double latitude;
  final double longitude;
  final String freshnessStatus;
  final int userId;

  ScanSaveRequest({
    required this.image,
    required this.fruit,
    required this.freshnessPercent,
    required this.latitude,
    required this.longitude,
    required this.freshnessStatus,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'fruit': fruit,
      'freshness_percent': freshnessPercent,
      'latitude': latitude,
      'longitude': longitude,
      'freshness_status': freshnessStatus,
      'user_id': userId,
    };
  }
}

