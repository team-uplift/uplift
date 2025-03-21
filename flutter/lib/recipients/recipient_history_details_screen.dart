import 'package:flutter/material.dart';
import 'recipient_send_thank_you_screen.dart';


// combo of chatgpt and me
class HistoryDetailScreen extends StatelessWidget {
  final Map<String, String> item; // Receive history item data

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {

    bool hasThankYou = item.containsKey("thankYou") && item["thankYou"]!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(item["title"]!), 
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.close, color: Colors.red),
        //     onPressed: () {
        //       Navigator.pop(context); // Close the page
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item["title"]!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Date: ${item["date"]}", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
            const SizedBox(height: 16),
            Text(item["details"]!, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),

            if (hasThankYou) 
              _buildThankYou(item["thankYou"]!)
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
              builder: (context) => SendThankYouScreen(historyItem: item,),
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