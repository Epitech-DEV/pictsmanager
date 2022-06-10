
class SearchQuery {
  final List<String>? tags;
  final String? name;
  final DateTime? begin;
  final DateTime? end;

  SearchQuery({
    this.tags,
    this.name,
    this.begin,
    this.end,
  });

  Map<String, dynamic> toJson() {
    return {
      'tags': tags?.join(','),
      'name': name,
      'begin': begin?.toIso8601String(),
      'end': end?.toIso8601String(),
    };
  }
}