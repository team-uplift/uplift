import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';

class TagCard extends StatelessWidget{
  final Tag tag;
  final bool isSelected;
  final VoidCallback? onTap;

  const TagCard({
    super.key, 
    required this.tag,
    this.isSelected = false,
    this.onTap,
  });
  
  Color _backgroundColorByWeight(double weight) {
    final defaultColor = Color.lerp(Colors.red.shade900, Colors.red.shade100, weight)!;
    return isSelected ? Colors.blue : defaultColor;
  }

  Border _borderByWeight(double weight) {
    final borderColor = Color.lerp(Colors.blue, Colors.red, weight)!;
    return Border.all(
      color: borderColor,
      width: isSelected ? 2.0 : 1.0,
    );
  }
  // gpt generated tag cards
  // 🔹 Creates a full-width tag box
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 160,
          minWidth: 80,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Card(
            color: _backgroundColorByWeight(tag.weight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              // side: _borderByWeight(tag.weight),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                tag.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
