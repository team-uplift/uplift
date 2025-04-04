class Tag {
  final DateTime createdAt;
  final String tagName;
  final double weight;
  final DateTime addedAt;
  bool selected; // remove `final`

  Tag({
    required this.createdAt,
    required this.tagName,
    required this.weight,
    required this.addedAt,
    this.selected = false, // default
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      createdAt: DateTime.parse(json['createdAt']),
      tagName: json['tagName'] as String,
      weight: (json['weight'] as num).toDouble(),
      addedAt: DateTime.parse(json['addedAt']),
      selected: json['selected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'createdAt': createdAt.toIso8601String(),
    'tagName': tagName,
    'weight': weight,
    'addedAt': addedAt.toIso8601String(),
    'selected': selected,
  };
}


// TODO remove comments
// class Duck {
//   final String url;
//   final String msg;

//   const Duck({required this.url, required this.msg});

//   factory Duck.fromJson(Map<String, dynamic> json) {
//     return switch (json) {
//       {'url': String url, 'message': String msg} => Duck(
//         url: url,
//         msg: msg,
//       ),
//       _ => throw const FormatException('Not a duck'),
//     };
//   }
// }