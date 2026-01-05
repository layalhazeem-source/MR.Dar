import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double? rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20.0,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    if (rating == null || rating == 0) {
      return Row(
        children: List.generate(
          5,
          (index) => Icon(Icons.star_border, size: size, color: inactiveColor),
        ),
      );
    }

    final int fullStars = rating!.floor();
    final bool hasHalfStar = (rating! - fullStars) >= 0.5;

    // التقريب حسب القاعدة المطلوبة
    final int roundedStars;
    if (rating! - fullStars >= 0.5) {
      roundedStars = fullStars + 1;
    } else {
      roundedStars = fullStars;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < roundedStars) {
          return Icon(Icons.star, size: size, color: activeColor);
        } else {
          return Icon(Icons.star_border, size: size, color: inactiveColor);
        }
      }),
    );
  }
}
