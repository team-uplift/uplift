/// recipient_history_details_screen.dart
///
/// used to display donation details for recipient
/// Includes:
/// - _handleSendThankYou
///
///
library;

import 'package:flutter/material.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/components/bottom_nav_bar.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/user_model.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Donation item;
  final User profile;

  const HistoryDetailScreen({
    super.key,
    required this.item,
    required this.profile,
  });

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  late Donation _donation;
  bool _thankYouSent = false;
  final TextEditingController _controller = TextEditingController();
  final api = RecipientApi();

  @override
  void initState() {
    super.initState();
    _donation = widget.item;
  }

  /// used to send thank you messages and attach them to donation object on
  /// back end
  void _handleSendThankYou() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    final success = await api.sendThankYouMessage(
      donationId: _donation.id,
      message: message,
    );

    if (success != null) {
      if (!mounted) return;
      setState(() {
        _donation = success;
        _thankYouSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thank you sent!")),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send thank you")),
      );
    }
  }

  /// builds main look of detail screen and determines if thank you message
  /// displayed or if text field displayed
  @override
  Widget build(BuildContext context) {
    bool hasThankYou = _donation.thankYouMessage != null &&
        _donation.thankYouMessage!.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.baseYellow,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.baseGreen,
          title: SizedBox(
              height: 40,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Image.asset('assets/uplift_black.png'),
              )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, _thankYouSent);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDonationInfoCard(),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child
                ),
                child: hasThankYou
                    ? _buildThankYouCard(_donation.thankYouMessage!)
                    : _buildSendThankYou(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedItem: 1,
        onItemTapped: (index) {
          Navigator.pop(context);
        },
      ),
    );
  }

  /// builds donation info cards for display
  Widget _buildDonationInfoCard() {
    return Container(
      width: double.infinity,
      child: Card(
        color: AppColors.warmWhite,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.lavender, width: 1.5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _donation.donorName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Date: ${_donation.formattedDate}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                "Amount: ${_donation.formattedAmount}",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// creates a card that contains a thank you message
  Widget _buildThankYouCard(String message) {
    return SizedBox(
      width: double.infinity,
      child: Card(
          elevation: 5,
          color: AppColors.warmWhite,
          shape:
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: AppColors.lavender, width: 1.5)
              ),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: const Text(
                      "Your Thank You Message",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.baseGreen.withAlpha(70),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Text(message,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black,
                        )),
                  )
                ],
              ))),
    );
  }

  /// builds a text field and button for sending a thank you
  Widget _buildSendThankYou() {
    return Card(
      color: AppColors.warmWhite,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Write a Thank You Message:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.baseRed.withAlpha(150),
                    width: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: _handleSendThankYou,
                icon: const Icon(Icons.send, color: AppColors.warmWhite),
                label: const Text(
                  "Send",
                  style: TextStyle(color: AppColors.warmWhite),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.baseRed,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
