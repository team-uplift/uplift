import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uplift/components/match_color_legend.dart';
import 'package:uplift/components/tag_card.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/tag_model.dart';

class ProfileTagsSection extends StatelessWidget {
  final List<Tag> tags;

  const ProfileTagsSection({Key? key, required this.tags}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rnd = Random();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      elevation: 5,
      color: AppColors.warmWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.lavender, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Your Tags",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const MatchColorLegend(),
            const SizedBox(height: 20),

            // Wrap instead of fixed‐column grid:
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: tags.map((tag) => TagCard(tag: tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
