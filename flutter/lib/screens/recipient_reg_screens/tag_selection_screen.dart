/// tag_selection_screen.dart
/// 
/// screen made for user to select tags when they register
/// includes:
/// - _toggleTag
/// - _sortTagsByWeight
/// - _submit


import 'package:flutter/material.dart';
import 'package:uplift/components/match_color_legend.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/tag_model.dart';
import 'package:uplift/components/tag_card.dart'; 

class TagSelection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final VoidCallback onSubmit;
  final VoidCallback onBack;
  final List<Tag> availableTags;


  const TagSelection({
    required this.formData,
    required this.onSubmit,
    required this.onBack,
    required this.availableTags,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TagSelectionState createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelection> {
  final int maxTagChoices = 10;
  final List<Tag> selectedTags = [];

  @override
  void initState() {
    super.initState();

    // rebuild selectedTags from any tags already marked as selected
    selectedTags.addAll(
      widget.availableTags.where((tag) => tag.selected),
    );
  }

  /// sets state of tags based on user selection
  void _toggleTag(Tag tag) {
    setState(() {
      tag.selected = !tag.selected;

      if (tag.selected) {
          if (selectedTags.length < maxTagChoices) {
            selectedTags.add(tag);
          } else {
            tag.selected = false; // revert if max reached
          }
        } else {
          selectedTags.remove(tag);
        }
    });
  }

  /// submits user choices of tags to update their profile
  void _submit() {
    final selectedTags = widget.availableTags
      .where((tag) => tag.selected)
      .toList();

    if (selectedTags.isNotEmpty) {
      widget.formData["tags"] = selectedTags;
      widget.onSubmit();
    }
  }

  /// sorts tags by matching weight
  void _sortTagsByWeight() {
    setState(() {
      widget.availableTags.sort((a, b) => b.weight.compareTo(a.weight));
    });
  }

  @override
  Widget build(BuildContext context) {
    _sortTagsByWeight(); // sorting all tags when page is built
    return Column(
      children: [
        const Text(
          "Select up to 10 tags",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text("${selectedTags.length} of $maxTagChoices selected",
        style: TextStyle(fontSize: 15)),
        // const SizedBox(height: 20),
        const MatchColorLegend(), 
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: widget.availableTags.map((tag) {
                final isSelected = tag.selected;
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.baseGreen,
                foregroundColor: Colors.black,
              ),

              onPressed: selectedTags.isNotEmpty ? _submit : null,
              child: const Text("Submit"),
            ),
          ],
        )
      ],
    );
  }
}

