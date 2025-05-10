import 'package:flutter/material.dart';
import 'package:uplift/providers/donation_notifier_provider.dart';
import 'package:uplift/constants/constants.dart';

class DonationDetailScreen extends StatelessWidget {
  final Donation donation;

  const DonationDetailScreen({super.key, required this.donation});

  String _formatDate(DateTime date) {
    try {
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Details'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Amount
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: const BoxDecoration(
                color: AppColors.baseBlue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Donation Amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${donation.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipient Information
                  const Text(
                    'Recipient',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline,
                        color: AppColors.baseBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        donation.recipient?.nickname ?? 'Anonymous',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.baseBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Donation Date
                  const Text(
                    'Donation Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppColors.baseBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(donation.createdAt),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.baseBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Thank You Message Section
                  const Text(
                    'Thank You Message',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        donation.thankYouMessage?.isNotEmpty == true
                            ? Icons.message_outlined
                            : Icons.message_outlined,
                        color: AppColors.baseBlue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          donation.thankYouMessage?.isNotEmpty == true
                              ? donation.thankYouMessage!
                              : 'No messages for this donation',
                          style: TextStyle(
                            fontSize: 16,
                            color: donation.thankYouMessage?.isNotEmpty == true
                                ? AppColors.baseBlue
                                : Colors.grey,
                          ),
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
    );
  }
}
