class Tag {
  
  final String name;
  final double weight;

  const Tag({required this.name, required this.weight});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      name: json['name'] as String,
      weight: json['weight'] as double,
    );
  }
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