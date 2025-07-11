class Home {
  final int fresh;
  final int spoiled;

  Home({required this.fresh, required this.spoiled});
  factory Home.fromJson(Map<String, dynamic> json) {
    return Home(
      fresh: json['fresh'],
      spoiled: json['spoiled'],
    );
  }
}
