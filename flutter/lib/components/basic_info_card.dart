import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';

class BasicInfoCard extends StatelessWidget {
  final String? fullName;
  final String? address;
  final String? email;

  const BasicInfoCard({
    super.key,
    this.fullName,
    this.address,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.warmWhite,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.lavender, width: 1.5)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              fullName!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on, size: 20, color: AppColors.baseBlue,),
                const SizedBox(width: 6),
                Expanded(child: Text(address!)),
              ],
            ),
            const SizedBox(height: 8),

            // Email
            Row(
              children: [
                const Icon(Icons.email, size: 20, color: AppColors.baseBlue),
                const SizedBox(width: 6),
                Text(email!),
              ],
            ),
          ],
        ),
      ),
    );
  }
}