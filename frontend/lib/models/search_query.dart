class SearchQuery {
  final bool useDateRange;
  final List<String>? tags;
  final String? name;
  final DateTime? begin;
  final DateTime? end;

  SearchQuery({
    required this.useDateRange,
    this.tags,
    this.name,
    this.begin,
    this.end,
  });

  Map<String, dynamic> toJson() {
    DateTime? beginDate = begin;
    DateTime? endDate = end;

    if (!useDateRange && endDate != null) {
      beginDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);
      endDate = null;
    }

    return {
      'tags': tags?.join(','),
      'name': name,
      'begin': beginDate?.toUtc().toString(),
      'end': endDate?.toUtc().toString(),
    };
  }
}
