class RecentSolvedModel {
  final String title;
  final String slug;
  final int timestamp;

  RecentSolvedModel({required this.title, required this.slug, required this.timestamp});

  factory RecentSolvedModel.fromJson(Map<String, dynamic> json) {
    return RecentSolvedModel(
      title: json["title"] ?? "",
      slug: json["slug"] ?? "",
      timestamp: int.tryParse(json["timestamp"].toString()) ?? 0,
    );
  }
}