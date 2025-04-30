import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uplift/models/recipient_model.dart';
import 'dart:math';

class PlaceholderData {
  final Map<String, dynamic> animal;
  final Color color;
  final Color secondaryColor;

  PlaceholderData({
    required this.animal,
    required this.color,
    required this.secondaryColor,
  });

  static final List<Map<String, dynamic>> animals = [
    {'icon': Icons.pets, 'name': 'Dog'},
    {'icon': Icons.catching_pokemon, 'name': 'Cat'},
    {'icon': Icons.emoji_nature, 'name': 'Bird'},
    {'icon': Icons.cruelty_free, 'name': 'Rabbit'},
  ];

  static final List<Color> colors = [
    const Color(0xFFFF7B9C), // Pink
    const Color(0xFF7ED3B2), // Mint
    const Color(0xFFFFB367), // Orange
    const Color(0xFF7B9CFF), // Blue
    const Color(0xFFB367FF), // Purple
    const Color(0xFFFF67B3), // Rose
  ];

  static PlaceholderData generate() {
    final random = Random();
    final animal = animals[random.nextInt(animals.length)];
    final color = colors[random.nextInt(colors.length)];
    return PlaceholderData(
      animal: animal,
      color: color,
      secondaryColor: color.withOpacity(0.7),
    );
  }

  Widget build({double height = 200}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, secondaryColor],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            right: -50,
            bottom: -50,
            child: Icon(
              animal['icon'] as IconData,
              size: height,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          // Centered animal icon
          Center(
            child: Icon(
              animal['icon'] as IconData,
              size: height * 0.4,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipientListCard extends StatelessWidget {
  final Recipient recipient;
  late final PlaceholderData placeholderData;

  RecipientListCard({super.key, required this.recipient}) {
    placeholderData = PlaceholderData.generate();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed('/recipient_detail', extra: {
        'recipient': recipient,
        'placeholderData': placeholderData,
      }),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Hero(
                      tag: recipient.id ?? 'unknown',
                      child: recipient.imageURL != null
                          ? Image.network(
                              recipient.imageURL!,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : placeholderData.build(),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          recipient.nickname ?? 'Anonymous',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.lastAboutMe ?? 'No description available',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (recipient.city != null && recipient.state != null)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${recipient.city}, ${recipient.state}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
