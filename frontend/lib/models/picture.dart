
class PictureData {
  const PictureData({
    this.id,
    this.owner,
    required this.name, 
    required this.path, 
    this.tags = const [], 
    this.createdAt
  });

  final String? id;
  final String? owner;
  final String name;
  final String path;
  final List<String> tags;
  final DateTime? createdAt;

  factory PictureData.fromJson(Map<String, dynamic> json) {
    return PictureData(
      id: json['id'],
      owner: json['owner'],
      name: json['name'] as String,
      path: json['path'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'tags': tags,
    };
  }
}