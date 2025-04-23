import 'package:flutter/material.dart';
import 'package:uplift/api/recipient_api.dart';
import 'package:uplift/models/donation_model.dart';
import 'package:uplift/models/user_model.dart';

class SendThankYouScreen extends StatefulWidget {
  final User profile;
  final Donation donation;

  const SendThankYouScreen({super.key, required this.donation, required this.profile});

  @override
  State<SendThankYouScreen> createState() => _SendThankYouScreenState();
}

class _SendThankYouScreenState extends State<SendThankYouScreen> {
  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
  
  Future<void> _handleSendThankYou(int donationId, String message) async {

    print("thank you sending don id ${donationId}, msg: $message");
    if (message.trim().isEmpty) return;

    final success = await RecipientApi.sendThankYouMessage(
      // userId: widget.profile.id!,
      donationId: donationId,
      message: message.trim(),
    );

    if (success) {
      print("Thank You Message Sent!");
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to send thank you message")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Thank You"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false), // Back to history detail page
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Write a Thank You Message", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type your thank you message here...",
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO insert send thank you API call
                  _handleSendThankYou(widget.donation.id, messageController.text);
                  // print("Thank You Message Sent: ${messageController.text}"); // Placeholder for sending logic
                  // Navigator.pop(context, true); // Close the Thank You page
                },
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text("Send", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// TODO implement logic for sending the message on the donation object to the api