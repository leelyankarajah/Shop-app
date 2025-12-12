// lib/screens/auth/views/offers_screen.dart
import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/components/skleton/others/offers_skelton.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<_Offer> offers = [
      _Offer(
        title: "Weekend sale",
        description: "Up to 30% off on dairy products.",
        tag: "Top deal",
      ),
      _Offer(
        title: "Buy 2 get 1 free",
        description: "Snacks & drinks selected items.",
        tag: "Limited time",
      ),
      _Offer(
        title: "Free delivery",
        description: "For orders above ₪150.",
        tag: "Today only",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        centerTitle: true,
      ),
      body: offers.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: OffersSkelton(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(defaultPadding),
              itemCount: offers.length,
              itemBuilder: (context, index) {
                final o = offers[index];
                return Container(
                  margin:
                      const EdgeInsets.only(bottom: defaultPadding * 0.75),
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      defaultBorderRadious * 1.4,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.06),
                        primaryColor.withOpacity(0.12),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              o.tag.toUpperCase(),
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              o.title,
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              o.description,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(
                                color: blackColor60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Offer "${o.title}" applied (demo only)',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text('Use'),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _Offer {
  final String title;
  final String description;
  final String tag;

  _Offer({
    required this.title,
    required this.description,
    required this.tag,
  });
}
