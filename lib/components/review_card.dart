import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.rating,
    required this.numOfReviews,
    this.numOfFiveStar = 0,
    this.numOfFourStar = 0,
    this.numOfThreeStar = 0,
    this.numOfTwoStar = 0,
    this.numOfOneStar = 0,
  });

  final double rating;
  final int numOfReviews;
  final int numOfFiveStar,
      numOfFourStar,
      numOfThreeStar,
      numOfTwoStar,
      numOfOneStar;

  int get totalWithBreakdown =>
      numOfFiveStar +
      numOfFourStar +
      numOfThreeStar +
      numOfTwoStar +
      numOfOneStar;

  double _ratio(int value) {
    final total = totalWithBreakdown;
    if (total == 0) return 0;
    return value / total;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayRating =
        rating.isNaN || rating.isInfinite ? 0.0 : rating.clamp(0.0, 5.0);

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top summary
          Row(
            children: [
              // Rating number + stars
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayRating.toStringAsFixed(1),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RatingBarIndicator(
                    rating: displayRating,
                    itemBuilder: (context, _) => SvgPicture.asset(
                      "assets/icons/Star.svg",
                      colorFilter: const ColorFilter.mode(
                        warningColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    unratedColor: primaryMaterialColor.shade100,
                    itemSize: 18.0,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$numOfReviews reviews",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: blackColor60,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: defaultPadding * 1.5),

              // Bars
              Expanded(
                child: Column(
                  children: [
                    _buildBarRow(context, 5, numOfFiveStar),
                    _buildBarRow(context, 4, numOfFourStar),
                    _buildBarRow(context, 3, numOfThreeStar),
                    _buildBarRow(context, 2, numOfTwoStar),
                    _buildBarRow(context, 1, numOfOneStar),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarRow(BuildContext context, int star, int value) {
    final theme = Theme.of(context);
    final ratio = _ratio(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            "$star",
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(width: 4),
          SvgPicture.asset(
            "assets/icons/Star.svg",
            height: 12,
            colorFilter: const ColorFilter.mode(
              warningColor,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: ratio,
                backgroundColor:
                    theme.textTheme.bodyLarge?.color?.withOpacity(0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 26,
            child: Text(
              "$value",
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                color: blackColor60,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
