import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/components/drawer_widget.dart';
import 'package:uplift/components/standard_button.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/providers/user_notifier_provider.dart';
import 'package:uplift/services/badge_service.dart';
import 'package:uplift/models/badge.dart';

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
  late final BadgeService _badgeService;
  late Future<List<DonorBadge>> _badgesFuture;

  @override
  void initState() {
    super.initState();
    _badgeService = BadgeService(ref);
    _refreshBadges();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshBadges();
  }

  void _refreshBadges() {
    setState(() {
      _badgesFuture = _badgeService.getBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync =
        ref.watch(userProvider("44284448-20a1-70c0-c877-9a00834002d3"));

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Image.asset(
          'assets/uplift_black.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        actions: [
          // Adding a SizedBox with the same width as the leading icon
          SizedBox(width: 48)
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerWidget(),
      body: userAsync.when(
        data: (user) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.baseBlue
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     Theme.of(context).primaryColor,
                    //     Theme.of(context).primaryColor.withOpacity(0.8),
                    //   ],
                    // ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome, ${user?.email?.split('@')[0] ?? 'User'}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Make a difference in someone's life today",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                // Badges Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: const Text(
                        "Your Badges",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    FutureBuilder<List<DonorBadge>>(
                      future: _badgesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        final badges = snapshot.data ?? [];
                        return SizedBox(
                          height: 200, // Fixed height for the carousel
                          child: CarouselSlider.builder(
                            itemCount: badges.length,
                            itemBuilder: (context, index, realIndex) {
                              final badge = badges[index];
                              return _buildBadgeCard(badge);
                            },
                            options: CarouselOptions(
                              height: 200,
                              aspectRatio: 1.0,
                              viewportFraction: 0.4,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: false,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.2,
                              scrollDirection: Axis.horizontal,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // Call to Action Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ready to Make a Difference?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "Your support can help provide essential resources to those in need. Start by selecting causes that matter to you.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                context.pushNamed('/donor_questionnaire');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'Start Helping',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Statistics Grid
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "The Impact of Poverty",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.2,
                        children: [
                          _buildStatCard(
                            "37.9M",
                            "Americans live in poverty",
                            Icons.people_outline,
                            Colors.blue,
                          ),
                          _buildStatCard(
                            "1 in 6",
                            "Children face hunger",
                            Icons.child_care,
                            Colors.orange,
                          ),
                          _buildStatCard(
                            "34M",
                            "People are food insecure",
                            Icons.restaurant,
                            Colors.red,
                          ),
                          _buildStatCard(
                            "5.6M",
                            "Seniors face hunger",
                            Icons.elderly,
                            Colors.purple,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                

                // Info Cards
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        "Food Insecurity",
                        "Many Americans struggle to put food on the table. Your donation can provide meals to families in need.",
                        Icons.restaurant_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        "Housing Crisis",
                        "Rising costs have left many unable to afford basic housing. Help provide shelter and stability.",
                        Icons.home_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatCard(
      String number, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String description, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeCard(DonorBadge badge) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: badge.isUnlocked
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: badge.isUnlocked
                ? AppColors.baseBlue.withOpacity(1.0)
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              badge.icon,
              size: 40,
              color: badge.isUnlocked
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: badge.isUnlocked
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge.description,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
