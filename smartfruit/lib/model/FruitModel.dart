class FruitModel {
  final int fruitId;
  final String fruitName;
  final String fruitImageUrl;

  FruitModel({required this.fruitId, required this.fruitName, required this.fruitImageUrl});

  factory FruitModel.fromJson(Map<String, dynamic> json) {
    return FruitModel(
      fruitId: json['fruit_id'],
      fruitName: json['fruit_name'],
      fruitImageUrl: json['fruit_image'],
    );
  }
}
