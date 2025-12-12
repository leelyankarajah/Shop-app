import 'package:flutter/material.dart';

import '../constants.dart';

class OrderProgress extends StatelessWidget {
  const OrderProgress({
    super.key,
    required this.orderStatus,
    required this.processingStatus,
    required this.packedStatus,
    required this.shippedStatus,
    required this.deliveredStatus,
    this.isCanceled = false,
  });

  final OrderProcessStatus orderStatus,
      processingStatus,
      packedStatus,
      shippedStatus,
      deliveredStatus;
  final bool isCanceled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProcessDotWithLine(
            isShowLeftLine: false,
            title: "Ordered",
            status: orderStatus,
            nextStatus: processingStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Processing",
            status: processingStatus,
            nextStatus: packedStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Packed",
            status: packedStatus,
            nextStatus: shippedStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            title: "Shipped",
            status: shippedStatus,
            nextStatus: deliveredStatus,
          ),
        ),
        Expanded(
          child: ProcessDotWithLine(
            isShowRightLine: false,
            title: isCanceled ? "Canceled" : "Delivered",
            status: isCanceled ? OrderProcessStatus.canceled : deliveredStatus,
          ),
        ),
      ],
    );
  }
}

class ProcessDotWithLine extends StatelessWidget {
  const ProcessDotWithLine({
    super.key,
    this.isShowLeftLine = true,
    this.isShowRightLine = true,
    required this.status,
    required this.title,
    this.nextStatus,
    this.isActive = false,
  });

  final bool isShowLeftLine, isShowRightLine;
  final OrderProcessStatus status;
  final OrderProcessStatus? nextStatus;
  final String title;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bool done = status == OrderProcessStatus.done;
    final bool processing = status == OrderProcessStatus.processing;
    final bool error =
        status == OrderProcessStatus.error || status == OrderProcessStatus.canceled;

    final Color dotBgColor = error
        ? errorColor
        : done || processing || isActive
            ? successColor
            : Theme.of(context).cardColor;

    final Color borderColor = error
        ? errorColor
        : done || processing || isActive
            ? successColor
            : Theme.of(context).dividerColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (isShowLeftLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: lineColor(context, status),
                ),
              )
            else
              const Spacer(),
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: dotBgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor,
                  width: 1.4,
                ),
              ),
              alignment: Alignment.center,
              child: _buildInnerIcon(context),
            ),
            if (isShowRightLine)
              Expanded(
                child: Container(
                  height: 2,
                  color: nextStatus != null
                      ? lineColor(context, nextStatus!)
                      : successColor,
                ),
              )
            else
              const Spacer(),
          ],
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight:
                    (done || processing || isActive) ? FontWeight.w600 : FontWeight.w400,
                color: error
                    ? errorColor
                    : (done || processing || isActive)
                        ? successColor
                        : blackColor60,
              ),
        ),
      ],
    );
  }

  Widget _buildInnerIcon(BuildContext context) {
    switch (status) {
      case OrderProcessStatus.done:
        return const Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        );
      case OrderProcessStatus.processing:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      case OrderProcessStatus.error:
      case OrderProcessStatus.canceled:
        return const Icon(
          Icons.close,
          size: 16,
          color: Colors.white,
        );
      case OrderProcessStatus.notDoneYeat:
      default:
        return Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: blackColor20,
          ),
        );
    }
  }
}

enum OrderProcessStatus { done, processing, notDoneYeat, error, canceled }

Widget statusWidget(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.processing:
      return CircleAvatar(
        radius: 12,
        backgroundColor: successColor.withOpacity(0.12),
        child: const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(successColor),
          ),
        ),
      );

    case OrderProcessStatus.done:
      return const CircleAvatar(
        radius: 12,
        backgroundColor: successColor,
        child: Icon(
          Icons.check,
          size: 16,
          color: Colors.white,
        ),
      );

    case OrderProcessStatus.error:
    case OrderProcessStatus.canceled:
      return const CircleAvatar(
        radius: 12,
        backgroundColor: errorColor,
        child: Icon(
          Icons.close,
          size: 16,
          color: Colors.white,
        ),
      );

    case OrderProcessStatus.notDoneYeat:
    default:
      return CircleAvatar(
        radius: 12,
        backgroundColor: Theme.of(context).cardColor,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).dividerColor,
          ),
        ),
      );
  }
}

Color lineColor(BuildContext context, OrderProcessStatus status) {
  switch (status) {
    case OrderProcessStatus.notDoneYeat:
      return Theme.of(context).dividerColor;
    case OrderProcessStatus.error:
    case OrderProcessStatus.canceled:
      return errorColor;
    default:
      return successColor;
  }
}
