import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/components/topic_module.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({super.key});

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Topic'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const TopicModule(
              topic: 'Hunger',
              description: 'A description here',
              imageURL:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFP_O_d03HwYyE7hpKR34dA3h0rOJcOokZTA&s',
            ),
            const SizedBox(height: 10),
            const TopicModule(
              topic: 'Single Parents',
              description: 'A description here',
              imageURL:
                  'https://datacenter.aecf.org/~/media/1700/update-2019kidscountdatabook-2019.jpg',
            ),
            const SizedBox(height: 10),
            const TopicModule(
              topic: 'Homelessness',
              description: 'A description here',
              imageURL:
                  'https://letsgowashington.com/wp-content/uploads/2022/09/homelessness.jpg',
            ),
            const SizedBox(height: 10),
            const TopicModule(
              topic: 'Job Loss',
              description: 'A description here',
              imageURL:
                  'https://image.cnbcfm.com/api/v1/image/103183902-GettyImages-498334813.jpg?v=1672930764',
            ),
            const SizedBox(height: 40),
            StandardButton(
              title: 'Generate Quiz',
              onPressed: () {
                context.pushNamed('/question');
              },
            ),
          ],
        ),
      ),
    );
  }
}
