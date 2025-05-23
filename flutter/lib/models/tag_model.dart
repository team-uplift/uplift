/// tag_model.dart
///
/// Defines the Tag model that represents categorization and matching criteria:
/// - Tag name
/// - Tag weight/importance
/// - Tag category
///
/// Used throughout the app to categorize recipients and donors,
/// enabling the matching algorithm to find suitable donation pairs.

import 'package:flutter/material.dart';

class Tag {
  final DateTime createdAt;
  final String tagName;
  final double weight;
  final DateTime addedAt;
  bool selected;

  Tag({
    required this.createdAt,
    required this.tagName,
    required this.weight,
    required this.addedAt,
    this.selected = false,
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
