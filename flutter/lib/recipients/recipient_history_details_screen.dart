import 'package:flutter/material.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/user_model.dart';
import 'recipient_send_thank_you_screen.dart';


// combo of chatgpt and me
class HistoryDetailScreen extends StatefulWidget {
  // final Map<String, String> item; // Receive history item data
  final Donation item;
  final User profile;

  const HistoryDetailScreen({super.key, required this.item, required this.profile});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  // late Donation donation;
  late Donation _donation;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _donation = widget.item;
  }

  Future<void> _refreshDonation() async {
    setState(() {
      _loading = true;
    });

    final updated = await RecipientApi.fetchDonation(_donation.id.toString());
    if (updated != null) {
      setState(() {
        _donation = updated;
      });
    }

    setState(() {
      _loading = false;
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    bool hasThankYou = widget.item.thankYouMessage != null && widget.item.thankYouMessage!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text("Donation from: ${_donation.donorName}"), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date received: ${_donation.formattedDate}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 16),
            Text("Amount received: ${_donation.formattedAmount}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            hasThankYou
              ? _buildThankYou(_donation.thankYouMessage!)
              : _buildSendThankYou(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThankYou(String message) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          "Thank You Message: \n$message",
          // style: const TextStyle((fontsize:16, fontStyle: FontStyle.italic)),
        ) 
      )
    );
  }

  Widget _buildSendThankYou(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendThankYouScreen(
                donation: _donation,
                profile: widget.profile,
              ),
            ),
          );

          // ✅ If thank you was successfully sent, go back to main history screen
          if (result == true) {
            await _refreshDonation();
          }
        },
        icon: const Icon(Icons.favorite, color: Colors.white,),
        label: const Text("Send Thank You"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
        )
      ),
    );
  }
}
// TODO format look and which content is required