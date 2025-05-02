import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:uplift/components/topic_module.dart';
import 'package:network_image_mock/network_image_mock.dart';

void main() {
  const topic = 'Sample Topic';
  const description = 'This is a description';
  const imageURL = 'https://example.com/image.png';

  testWidgets('TopicModule displays texts, layout, and Image widget', (tester) async {
    // wrap your pump in mockNetworkImagesFor(...)
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TopicModule(
              topic: topic,
              description: description,
              imageURL: imageURL,
            ),
          ),
        ),
      );
      // let the fake-network-image complete
      await tester.pumpAndSettle();

      // 1) Upper‐cased topic
      expect(find.text(topic.toUpperCase()), findsOneWidget);

      // 2) Description
      expect(find.text(description), findsOneWidget);

      // 3) Container height is 80
      final box = tester.renderObject<RenderBox>(
        find.descendant(of: find.byType(TopicModule), matching: find.byType(Container)).first
      );
      expect(box.size.height, 80.0);

      // 4) Two Expanded widgets with flex 2 and 1
      final expandeds = tester.widgetList<Expanded>(
        find.descendant(of: find.byType(TopicModule), matching: find.byType(Expanded)),
      ).toList();
      expect(expandeds.length, 2);
      expect(expandeds[0].flex, 2);
      expect(expandeds[1].flex, 1);

      // 5) There's exactly one Image widget
      expect(find.byType(Image), findsOneWidget);
    });
  });
}
