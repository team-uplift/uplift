import 'package:flutter_test/flutter_test.dart';
import 'package:uplift/models/tag_model.dart';

void main() {
  group('Tag Model', () {
    test('fromJson and toJson are consistent', () {
      final json = {
        'createdAt': '2025-04-21T00:00:00Z',
        'tagName': 'Health',
        'weight': 0.8,
        'addedAt': '2025-04-22T00:00:00Z',
        'selected': true,
      };

      final tag = Tag.fromJson(json);
      final output = tag.toJson();

      expect(output['tagName'], 'Health');
      expect(output['weight'], 0.8);
      expect(output['selected'], true);
      expect(output['createdAt'], '2025-04-21T00:00:00.000Z');
      expect(output['addedAt'], '2025-04-22T00:00:00.000Z');
    });

    test('fromJson sets default selected = false', () {
      final json = {
        'createdAt': '2025-04-21T00:00:00Z',
        'tagName': 'Housing',
        'weight': 0.5,
        'addedAt': '2025-04-22T00:00:00Z',
      };

      final tag = Tag.fromJson(json);

      expect(tag.selected, false);
    });
  });
}
