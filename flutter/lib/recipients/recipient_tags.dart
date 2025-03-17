import 'package:flutter/material.dart';
import 'package:uplift/components/drawer_widget.dart';

class RecipientTags extends StatefulWidget {
  @override
  _RecipientTagsState createState() => _RecipientTagsState();
}

class _RecipientTagsState extends State<RecipientTags>{
  List<String> tags = ["A", "B", "C", "D"];

  void _regenAllTags() {
    setState(() {
      tags = ["1", "2", "3", "4"];
    });
    print("Regen Tags");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile Tags')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tags.map((tag) => _buildTagCard(tag)).toList(),
                ), 
              ),
            ),
            const SizedBox(height: 16,),
            ElevatedButton.icon(
              onPressed: _regenAllTags,
              label: const Text("Regenerate All Tags"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                backgroundColor: Colors.red,
                elevation: 4
              ),
            )
          ],
        ),
      ),
    );
  }

// gpt generated tag cards
 // 🔹 Creates a full-width tag box
  Widget _buildTagCard(String tag) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Space between tags
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Center(
            child: Text(tag, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () {
              print("Remove $tag (Functionality not yet implemented)");
            },
          ),
        ),
      ),
    );
  }
}


// TODO implement the tag removal functionality including removing it visually and from database
// TODO implement the regenerate all tags functionality with cooldown timer?