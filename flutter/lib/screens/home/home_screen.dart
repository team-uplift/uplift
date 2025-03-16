import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/standard_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<Image> items = [
  Image.network(
      'https://www.reimaginerpe.org/files/images/03.16.espinoza2.NGUYEN.jpg'),
  Image.network(
      'https://www.brookings.edu/wp-content/uploads/2024/04/distressed-mother-and-child.jpg?quality=75'),
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('uplift'),
      ),
      drawer: const DrawerWidget(),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: CarouselSlider(
              items: items,
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                StandardButton(
                  title: 'Take the quiz',
                  onPressed: () => context.pushNamed('/quiz'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


