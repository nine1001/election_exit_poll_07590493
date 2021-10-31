class NameItem {
  final int number;
  final String displayName;
  final int? score;
  NameItem({
    required this.number,
    required this.displayName,
    this.score
  });

  factory NameItem.fromJson(Map<String, dynamic> json) {
    return NameItem(
      number: json['number'],
      displayName: json['displayName'],
      score: json['score'],
    );
  }

}