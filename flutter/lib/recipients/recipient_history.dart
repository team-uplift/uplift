import 'package:flutter/material.dart';
import 'recipient_history_details.dart';


// combo of chatgpt and me
class RecipientHistory extends StatefulWidget {
  const RecipientHistory({super.key});

  @override
  State<RecipientHistory> createState() => _RecipientHistoryState();
}

class _RecipientHistoryState extends State<RecipientHistory> {

  List<Map<String, String>> historyItems = [
    {"title": "Donation 1", "date": "date", "details": "You received \$50"},
    {"title": "Donation 2", "date": "date", "details": "You received \$25", "thankYou": "I really appreciate the help!"},
    {"title": "Donation 3", "date": "date", "details": "You received \$10."},
  ];

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: historyItems.map((item) => _buildHistoryCard(context, item)).toList(),
        ),
      ),
    );
  }


  // 🔹 Creates a clickable history item card
  Widget _buildHistoryCard(BuildContext context, Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(item["title"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(item["date"]!, style: TextStyle(color: Colors.grey[700])),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryDetailScreen(item: item), // Pass item to details page
              ),
            );
          },
        ),
      ),
    );
  }
}

// TODO format and clean up
// TODO functionality to process incoming history items --> refresh maybe?
// TODO ensure API is hooked up to bring in variable amount of history items
