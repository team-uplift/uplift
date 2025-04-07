import 'package:flutter/material.dart';
import 'package:uplift/models/donation_model.dart';
import 'recipient_send_thank_you_screen.dart';


// combo of chatgpt and me
class HistoryDetailScreen extends StatelessWidget {
  // final Map<String, String> item; // Receive history item data
  final Donation item;
  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    bool hasThankYou = item.thankYouMessage != null && item.thankYouMessage!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text("Donation from: ${item.donorName}"), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date received: ${item.formattedDate}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 16),
            Text("Amount received: ${item.formattedAmount}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            if (hasThankYou) 
              _buildThankYou(item.thankYouMessage!)
            else 
              _buildSendThankYou(context),
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SendThankYouScreen(donation: item),
            )
          );
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