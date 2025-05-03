/// recipient_history_screen.dart
///
/// used to display received donation cards that can be clicked on for more
/// details
/// Includes:
/// - _loadDaonations
/// - _buildHistoryCard widget
///
library;

import 'package:flutter/material.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/recipient_model.dart';
import 'package:uplift/models/user_model.dart';
import 'recipient_history_details_screen.dart';

class RecipientHistoryScreen extends StatefulWidget {
  final User profile;
  final Recipient recipient;
  final RecipientApi api;

  RecipientHistoryScreen({
    super.key,
    required this.profile,
    required this.recipient,
    RecipientApi? api,
  }) : api = api ?? RecipientApi(); // ← don’t forget to call super

  @override
  State<RecipientHistoryScreen> createState() => _RecipientHistoryScreenState();
}

class _RecipientHistoryScreenState extends State<RecipientHistoryScreen> {
  late final RecipientApi api;

  @override
  void initState() {
    super.initState();
    api = widget.api;
    _loadDonations();
  }

  List<Donation> unthankedItems = [];
  List<Donation> thankedItems = [];
  String msg = "";
  bool _isLoading = true;

  /// fetches all donation objects associated with user from api and stores them
  /// in two lists --> thanked and unthanked
  Future<void> _loadDonations() async {
    final donations = await api.fetchDonationsForRecipient(widget.profile.id!);
    final all = donations.$1;

    setState(() {
      unthankedItems = all
          .where((d) => d.thankYouMessage?.isEmpty ?? true)
          .toList()
        ..sort((a, b) =>
            b.formattedDate.compareTo(a.formattedDate)); // newest first
      thankedItems = all
          .where((d) => d.thankYouMessage?.isNotEmpty ?? false)
          .toList()
        ..sort((a, b) => b.formattedDate.compareTo(a.formattedDate));
      msg = donations.$2;
      _isLoading = false;
    });
  }

  /// build main portion of display but calls other widghet builders
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: (unthankedItems.isEmpty && thankedItems.isEmpty)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: AppColors.baseBlue),
                          const SizedBox(height: 16),
                          Text(
                            msg,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        // build unthanked list of donations
                        if (unthankedItems.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: AppColors.baseRed, width: 1.5),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.baseRed.withAlpha(40),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                      color: AppColors.baseRed, width: 5),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Needs Thank-You",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 8),
                                  ...unthankedItems.map((item) =>
                                      _buildHistoryCard(context, item)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // build thanked list of donations
                        if (thankedItems.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  color: AppColors.baseBlue, width: 1.5),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.baseBlue.withAlpha(50),
                                borderRadius: BorderRadius.circular(12),
                                border: Border(
                                  left: BorderSide(
                                      color: AppColors.baseBlue, width: 5),
                                ),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Thanked Donations",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  const SizedBox(height: 8),
                                  ...thankedItems.map((item) =>
                                      _buildHistoryCard(context, item)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                      ],
                    )),
    );
  }

  /// builds each individual card out of a donation for display
  Widget _buildHistoryCard(BuildContext context, Donation donation) {
    final bool hasThankYou = donation.thankYouMessage != null &&
        donation.thankYouMessage!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Card(
        color: AppColors.warmWhite,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: hasThankYou ? AppColors.baseBlue : AppColors.baseRed,
            width: 4,
          ),
        ),
        child: ListTile(
          title: Text("From ${donation.donorName}",
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(donation.formattedDate),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(donation.formattedAmount,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              if (!hasThankYou) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chat_bubble_outline, color: AppColors.baseRed)
              ]
            ],
          ),
          onTap: () async {
            final refresh = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryDetailScreen(
                    item: donation,
                    profile: widget.profile,
                  ),
                ));
            if (refresh == true) {
              await _loadDonations();
            }
          },
        ),
      ),
    );
  }
}
