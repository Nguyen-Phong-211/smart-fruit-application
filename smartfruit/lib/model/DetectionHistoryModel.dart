import 'package:flutter/foundation.dart';

class DetectionHistoryModel {
  final int detectionHistoryId;
  final double freshnessPercent;
  final DateTime createdAt;
  final String fruitName;
  final String imagePath;

  DetectionHistoryModel({
    required this.detectionHistoryId,
    required this.freshnessPercent,
    required this.createdAt,
    required this.fruitName,
    required this.imagePath,
  });

  factory DetectionHistoryModel.fromJson(Map<String, dynamic> json) {
    return DetectionHistoryModel(
      detectionHistoryId: json['detection_history_id'],
      freshnessPercent: (json['freshness_precent'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      fruitName: json['fruit']['fruit_name'],
      imagePath: json['image']['path'],
    );
  }
}


class DetectionHistoryDetailModel {
  final int detectionHistoryId;
  final double freshnessPercent;
  final String freshnessStatus;
  final DateTime createdAt;
  final String fruitName;
  final String supermarketName;
  final String imagePath;

  DetectionHistoryDetailModel({
    required this.detectionHistoryId,
    required this.freshnessPercent,
    required this.freshnessStatus,
    required this.createdAt,
    required this.fruitName,
    required this.supermarketName,
    required this.imagePath,
  });

  factory DetectionHistoryDetailModel.fromJson(Map<String, dynamic> json) {
    return DetectionHistoryDetailModel(
      detectionHistoryId: json['detection_history_id'],
      freshnessPercent: (json['freshness_precent'] as num).toDouble(),
      freshnessStatus: json['freshness_status'],
      createdAt: DateTime.parse(json['created_at']),
      fruitName: json['fruit']['fruit_name'],
      supermarketName: json['supermarket']['supermarket_name'],
      imagePath: json['image']['path'],
    );
  }
}