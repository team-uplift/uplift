/// donation_card.dart
///
/// A reusable card component that displays donation information including:
/// - Recipient name/nickname
/// - Donation date
/// - Donation amount
/// - Thank you message status
///
/// Used in donation history and tracking screens to show individual donation entries
/// with a consistent, clean design.

import 'package:flutter/material.dart';
import 'package:uplift/providers/donation_notifier_provider.dart';

class DonationCard extends StatefulWidget {
  final Donation donation;

  const DonationCard({super.key, required this.donation});

  @override
  State<DonationCard> createState() => _DonationCardState();
}

class _DonationCardState extends State<DonationCard> {
  String _formatDate(DateTime date) {
    try {
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.volunteer_activism,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.donation.recipient?.nickname ?? 'Anonymous',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(widget.donation.createdAt),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '\$${widget.donation.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.mail,
              color: widget.donation.thankYouMessage?.isNotEmpty == true
                  ? Theme.of(context).primaryColor
                  : Colors.grey[300],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
