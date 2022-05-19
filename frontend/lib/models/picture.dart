class PictureData {
  const PictureData({
    required this.name,
    required this.url,
    required this.tags,
    required this.date,
  });

  final String name;
  final String url;
  final List<String> tags;
  final DateTime date;

  fromJson(Map<String, dynamic> json) {
    return PictureData(
      name: json['name'] as String,
      url: json['url'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      date: DateTime.parse(
        json['date'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'tags': tags,
      'date': date.toIso8601String(),
    };
  }
}
