import 'package:flutter/material.dart';


// combo of chatgpt and me
class HistoryDetailScreen extends StatelessWidget {
  final Map<String, String> item; // Receive history item data

  const HistoryDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
          ],
        ),
      ),
    );
  }
}


// TODO format look and which content is required