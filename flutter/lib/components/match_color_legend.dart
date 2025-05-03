/// chatgpt generated legend bar for use in describing tag heat

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

class MatchColorLegend extends StatelessWidget {
  const MatchColorLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            const Text(
              "Strong Match",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.baseRed,
                      AppColors.baseOrange,
                      AppColors.warmWhite,
                    ],
                    stops: [0.0, 0.2, 1.0],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "Weaker Match",
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}
