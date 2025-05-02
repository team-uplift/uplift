/// tag_card.dart
///
/// Creates cards to display tag information. The individual cards are
/// generated from tag objects and are also passed a function in case they
/// need to be used with clicks during registration.
/// Includes:
/// - _backgroundColorByWeight
/// - _shadowByWeight
/// - _textColor
///

import 'package:flutter/material.dart';
import 'package:uplift/constants/constants.dart';
import 'package:uplift/models/tag_model.dart';

class TagCard extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final VoidCallback? onTap;

  const TagCard({
    super.key,
    required this.tag,
    this.isSelected = false,
    this.onTap,
  });

  /// determines a background color based on a provided weight between 0 and 1
  ///
  /// returns the color
  Color _backgroundColorByWeight(double weight) {
    if (weight < 0.8) {
      return Color.lerp(
          AppColors.warmWhite, AppColors.baseOrange, weight / 0.8)!;
    } else {
      return Color.lerp(
          AppColors.baseOrange, AppColors.baseRed, (weight - 0.8) / 0.2)!;
    }
  }

  /// determines a shadow color based on a provided weight between 0 and 1
  ///
  /// returns the box shadow object
  BoxShadow _shadowByWeight(double weight) {
    final Color lowShadow =
        Colors.black.withAlpha(100); 
    final Color highShadow =
        Color(AppColors.baseOrange.toARGB32()).withAlpha(200);

    final Color shadowColor = Color.lerp(
      lowShadow,
      highShadow,
      weight,
    )!;

    return BoxShadow(
      color: shadowColor,
      blurRadius: 3 + (10 * weight), 
      offset: Offset(0, 4 + (2 * weight)),
    );
  }

  /// determines color of text based on luminance of background color
  ///
  /// currently unused but might be helpful in future
  ///
  /// returns black or white color
  Color _textColor(Color background) {
    final double luminance = background.computeLuminance();
    return luminance > 0.2 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {

    final bgColor = _backgroundColorByWeight(tag.weight);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.baseBlue : bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            _shadowByWeight(tag.weight),
          ],
        ),
        child: Text(
          tag.tagName,
          style: TextStyle(
            color: isSelected ? AppColors.warmWhite : Colors.black,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
