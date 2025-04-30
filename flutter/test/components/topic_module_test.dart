import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/painting.dart';
import 'package:uplift/components/topic_module.dart';

void main() {
  const topic = 'Sample Topic';
  const description = 'This is a description';
  const imageURL = 'https://example.com/image.png';

  testWidgets('TopicModule displays texts, layout, and Image widget', (tester) async {
    // Override the error widget to swallow NetworkImageLoadException
    final originalErrorBuilder = ErrorWidget.builder;
    ErrorWidget.builder = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException) {
        return const SizedBox.shrink();
      }
      return originalErrorBuilder(details);
    };

    // Build the widget
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
    // One frame is enough to build the tree; no pumpAndSettle
    await tester.pump();

    // 1. Topic is uppercased
    expect(find.text(topic.toUpperCase()), findsOneWidget);

    // 2. Description is shown as-is
    expect(find.text(description), findsOneWidget);

    // 3. Container has height 80
    final container = find
        .descendant(
          of: find.byType(TopicModule),
          matching: find.byType(Container),
        )
        .first;
    final box = tester.renderObject<RenderBox>(container);
    expect(box.size.height, 80.0);

    // 4. Two Expanded children with flex 2 and flex 1
    final expandeds = tester.widgetList<Expanded>(
      find.descendant(of: find.byType(TopicModule), matching: find.byType(Expanded)),
    ).toList();
    expect(expandeds.length, 2);
    expect(expandeds[0].flex, 2);
    expect(expandeds[1].flex, 1);

    // 5. An Image widget was created with the correct URL and fit
    final image = tester.widget<Image>(find.byType(Image));
    final provider = image.image as NetworkImage;
    expect(provider.url, imageURL);
    expect(image.fit, BoxFit.cover);

    // Restore the original error builder
    ErrorWidget.builder = originalErrorBuilder;
  });
}
