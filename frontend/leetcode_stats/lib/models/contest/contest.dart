class Contest {
  final String title;
  final String slug;
  final int startTime;
  final int duration;

  Contest({required this.title, required this.slug, required this.startTime, required this.duration});

  factory Contest.fromJson(Map<String, dynamic> json){
    return Contest(
        title: json["title"],
        slug: json["titleSlug"],
        startTime: json["startTime"],
        duration: json["duration"],
    );
  }
}