import 'package:flutter/material.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart'; 
import 'package:go_router/go_router.dart';

// TODO sort all tags by heat

class TagSelection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const TagSelection({
    required this.formData,
    required this.onSubmit,
    required this.onBack,
    super.key,
  });

  @override
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  final int maxTagChoices = 10;

  final List<Tag> availableTags = [
    const Tag(name: "Tech", weight: 0.92),
    const Tag(name: "Education", weight: 0.81),
    const Tag(name: "Music", weight: 0.67),
    const Tag(name: "Mental Health", weight: 0.74),
    const Tag(name: "Food Access", weight: 0.33),
    const Tag(name: "Housing", weight: 0.58),
    const Tag(name: "Transportation", weight: 0.46),
    const Tag(name: "LGBTQ+ Support", weight: 0.88),
    const Tag(name: "Parenting", weight: 0.52),
    const Tag(name: "Women’s Health", weight: 0.77),
    const Tag(name: "Disability", weight: 0.35),
    const Tag(name: "Art", weight: 0.61),
    const Tag(name: "Sports", weight: 0.44),
    const Tag(name: "Gaming", weight: 0.70),
    const Tag(name: "Environment", weight: 0.50),
    const Tag(name: "Science", weight: 0.66),
    const Tag(name: "Business", weight: 0.39),
    const Tag(name: "Startups", weight: 0.82),
    const Tag(name: "Healthcare", weight: 0.79),
    const Tag(name: "Immigration", weight: 0.47),
    const Tag(name: "Youth Programs", weight: 0.73),
    const Tag(name: "Scholarships", weight: 0.68),
    const Tag(name: "Books", weight: 0.54),
    const Tag(name: "Film", weight: 0.62),
    const Tag(name: "Culture", weight: 0.31),
    const Tag(name: "Fashion", weight: 0.48),
    const Tag(name: "Social Justice", weight: 0.85),
    const Tag(name: "Climate", weight: 0.53),
    const Tag(name: "Coding", weight: 0.90),
    const Tag(name: "Community", weight: 0.76),
  ];


  // TODO dont need list of tags need only list of tag.names for submission
  final List<Tag> selectedTags = [];

  void _toggleTag(Tag tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        if (selectedTags.length < maxTagChoices) {
          selectedTags.add(tag);
        }
      }
    });
  }

  void _submit() {
    if (selectedTags.isNotEmpty) {
      widget.formData["tags"] = selectedTags;
      widget.onSubmit();
      // context.goNamed('/recipient_home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Select up to 10 interests"),
        const SizedBox(height: 8),
        Text("${selectedTags.length} of $maxTagChoices selected"),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: availableTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => _toggleTag(tag),
                  child: TagCard(tag: tag, isSelected: isSelected),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // OutlinedButton(onPressed: widget.onBack, child: const Text("Back")),
            ElevatedButton(
              // TODO implement submit logic here
              onPressed: selectedTags.isNotEmpty ? _submit : null,
              child: const Text("Next"),
            ),
          ],
        )
      ],
    );
  }
}
