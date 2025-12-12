import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';

class ShoppingBag extends StatelessWidget {
  const ShoppingBag({
    super.key,
    this.color,
    this.numOfItem,
  });

  final Color? color;
  final int? numOfItem;

  @override
  Widget build(BuildContext context) {
    final int count = numOfItem ?? 0;
    final bool showBadge = count > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: color ?? blackColor5,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/icons/Bag.svg",
            height: 22,
            colorFilter: ColorFilter.mode(
              Theme.of(context).iconTheme.color ?? blackColor80,
              BlendMode.srcIn,
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              height: 18,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? primaryColor
                    : primaryColor,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 1.2,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                count > 99 ? "99+" : "$count",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
