import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';

class TagCard extends StatelessWidget{
  final Tag tag;
  const TagCard({super.key, required this.tag});
  
  Color _backgroundColorByWeight(double weight) {
    return Color.lerp(Colors.red.shade900, Colors.red.shade200, weight)!;
  }
  // gpt generated tag cards
  // 🔹 Creates a full-width tag box
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // Space between tags
      child: Card(
        color: _backgroundColorByWeight(tag.weight),
        // elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            tag.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        )
        // child: ListTile(
        //   title: Center(
        //     child: Text(tag.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        //   ),
        // ),
      ),
    );
  }
}
