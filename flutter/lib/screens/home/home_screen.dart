import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/providers/donor_notifier_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

final List<Image> items = [
  Image.network(
      'https://www.reimaginerpe.org/files/images/03.16.espinoza2.NGUYEN.jpg'),
  Image.network(
      'https://www.brookings.edu/wp-content/uploads/2024/04/distressed-mother-and-child.jpg?quality=75'),
];

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final donorAsync =
        ref.watch(donorProvider("f4d82478-e011-7085-fe80-ecd3cc145ce4")); // Use your real donorId here

    return Scaffold(
      appBar: AppBar(
        title: const Text('uplift'),
      ),
      drawer: const DrawerWidget(),
      body: donorAsync.when(
        data: (donor) {
          return Column(
            children: [
              Text("Welcome, ${donor?.nickname ?? 'Donor'}"),
              const SizedBox(height: 20),
              CarouselSlider(
                items: items,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                ),
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    StandardButton(
                      title: 'help someone in need',
                      onPressed: () => context.pushNamed('/quiz'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
