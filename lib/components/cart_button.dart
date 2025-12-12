import 'package:flutter/material.dart';

import '../constants.dart';

class CartButton extends StatelessWidget {
  const CartButton({
    super.key,
    required this.price,
    this.title = "Add to cart",
    this.subTitle = "Total price",
    required this.press,
  });

  final double price;
  final String title;
  final String subTitle;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(defaultBorderRadious * 2),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.35),
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          // Price section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₪${price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),

          const SizedBox(width: defaultPadding),

          // Action button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: press,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.4,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(defaultBorderRadious * 1.4),
                ),
                elevation: 0,
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
