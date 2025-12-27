// lib/screens/auth/views/offers_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/constants.dart';
import 'package:shop/models/product_model.dart';
import 'package:shop/providers/owner_provider.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  bool _isProductOnOffer(ProductModel p) {
    final hasPercent =
        p.dicountpercent != null && p.dicountpercent! > 0;
    final hasDiscountPrice =
        p.priceAfetDiscount != null &&
            p.priceAfetDiscount! > 0 &&
            p.priceAfetDiscount! < p.price;
    return hasPercent || hasDiscountPrice;
  }

  @override
  Widget build(BuildContext context) {
    final owner = context.watch<OwnerProvider>();
    final theme = Theme.of(context);

    final List<ProductModel> offers = owner.products
        .where(_isProductOnOffer)
        .toList();

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        elevation: 0,
        title: const Text(
          'Offers',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: offers.isEmpty
          ? Center(
              child: Text(
                'No active offers right now.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: blackColor60,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(defaultPadding),
              itemCount: offers.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: defaultPadding / 1.5),
              itemBuilder: (context, index) {
                final p = offers[index];

                final double oldPrice = p.price;
                final double currentPrice =
                    p.priceAfetDiscount != null &&
                            p.priceAfetDiscount! > 0 &&
                            p.priceAfetDiscount! < p.price
                        ? p.priceAfetDiscount!
                        : p.price;
                final int discountPercent = p.dicountpercent ??
                    (((1 - (currentPrice / oldPrice)) * 100)
                            .round())
                        .clamp(0, 90);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadious * 1.4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          defaultBorderRadious * 1.4,
                        ),
                        child: Image.network(
                          p.image,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 90,
                            width: 90,
                            color: blackColor5,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.image_outlined,
                              color: blackColor40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: defaultPadding),

                      // Text content
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: defaultPadding / 1.4,
                          ),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                p.brandName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: blackColor60,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '₪${currentPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '₪${oldPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: blackColor40,
                                      decoration: TextDecoration
                                          .lineThrough,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF1F1),
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '-$discountPercent%',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFFFF4D4D),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                p.stock > 0
                                    ? 'In stock: ${p.stock}'
                                    : 'Out of stock',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: p.stock > 0
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
