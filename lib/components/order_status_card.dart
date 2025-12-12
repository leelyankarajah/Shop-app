import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import 'order_process.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.orderId,
    required this.placedOn,
    this.products,
    required this.orderStatus,
    required this.processingStatus,
    required this.packedStatus,
    required this.shippedStatus,
    required this.deliveredStatus,
    this.press,
    this.isCancled = false,
  });

  final String orderId, placedOn;
  final List<Widget>? products;
  final OrderProcessStatus orderStatus,
      processingStatus,
      packedStatus,
      shippedStatus,
      deliveredStatus;
  final VoidCallback? press;
  final bool isCancled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius:
          const BorderRadius.all(Radius.circular(defaultBorderRadious)),
      onTap: press,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(defaultBorderRadious * 1.4),
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
                // Header
                Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: blackColor5,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    "Order",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: defaultPadding / 2),
                                  Text(
                                    "#$orderId",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                height: defaultPadding / 2),
                            Text(
                              "Placed on $placedOn",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: blackColor60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/miniRight.svg",
                        height: 24,
                        width: 24,
                        colorFilter: ColorFilter.mode(
                          theme.dividerColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Progress
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: defaultPadding,
                    horizontal: defaultPadding,
                  ),
                  child: OrderProgress(
                    orderStatus: orderStatus,
                    processingStatus: processingStatus,
                    packedStatus: packedStatus,
                    shippedStatus: shippedStatus,
                    deliveredStatus: deliveredStatus,
                    isCanceled: isCancled,
                  ),
                ),

                if (products != null && products!.isNotEmpty) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                        vertical: defaultPadding),
                    child: Column(
                      children: products!,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
