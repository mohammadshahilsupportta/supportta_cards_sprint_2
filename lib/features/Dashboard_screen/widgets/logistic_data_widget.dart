import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:taproot_admin/features/Dashboard_screen/data/dashboard_model.dart';
import 'package:taproot_admin/features/Dashboard_screen/widgets/logistic_tile_widget.dart';
import 'package:taproot_admin/features/Dashboard_screen/widgets/notify_chip_widget.dart';

import '../../../exporter/exporter.dart';

class LogisticDataWidget extends StatelessWidget {
  const LogisticDataWidget({
    super.key,
    required this.normalPadding,
    required this.tileWidgetBorderRadius,
    required this.data,
  });
  final DashboardModel data;
  final double normalPadding;

  final double tileWidgetBorderRadius;

  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    TextStyle supportingTextStyle = context.inter50016;
    int totalOrders = data.result.result.totalOrder;
    int cancelledOrders = data.result.result.cancelledOrder;
    int completedOrders = data.result.result.deliveredOrder;
    double refundStatusValue = data.result.result.refundAmount;

    return Expanded(
      child: Container(
        width: (620 / 1440) * MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(normalPadding),
        decoration: BoxDecoration(
          color: CustomColors.secondaryColor,
          borderRadius: BorderRadius.circular(
            tileWidgetBorderRadius + normalPadding,
          ),
        ),

        child: Column(
          spacing: normalPadding,
          children: [
            LogisticTileWidget(
              tileColor: CustomColors.greylight,
              trailingIcon: Icon(
                LucideIcons.package,
                color: CustomColors.totalOrderColor,
                size: iconSize,
              ),
              numericalColor: CustomColors.totalOrderColor,
              numericaldata: totalOrders,
              tileWidgetBorderRadius: tileWidgetBorderRadius,
              normalPadding: normalPadding,

              supportingWidget: Text(
                'orders',
                style: supportingTextStyle.copyWith(
                  color: CustomColors.totalOrderColor,
                ),
              ),
              title: 'Total Orders',
            ),
            LogisticTileWidget(
              numericalColor: CustomColors.totalOrdersCompleted,

              // isGapExist: true,
              tileColor: CustomColors.greylight,
              trailingIcon: Icon(
                LucideIcons.packageCheck,
                color: CustomColors.totalOrdersCompleted,
                size: iconSize,
              ),
              numericaldata: completedOrders,
              tileWidgetBorderRadius: tileWidgetBorderRadius,
              normalPadding: normalPadding,

              supportingWidget: Text(
                'Orders Completed',
                style: supportingTextStyle.copyWith(
                  color: CustomColors.totalOrdersCompleted,
                ),
              ),
              title: 'Total Orders Completed',
            ),

            LogisticTileWidget(
              // isGapExist: true,
              tileColor: CustomColors.greylight,
              trailingIcon: Icon(
                LucideIcons.packageX,
                color: CustomColors.totalOrdersCancelled,

                size: iconSize,
              ),
              numericaldata: cancelledOrders,
              tileWidgetBorderRadius: tileWidgetBorderRadius,
              normalPadding: normalPadding,
              numericalColor: CustomColors.totalOrdersCancelled,
              notifyTrailingWidget: NotifyChipWidget(
                refundStatusValue: refundStatusValue,
              ),
              supportingWidget: Text(
                'Cancelled Orders',
                style: supportingTextStyle.copyWith(
                  color: CustomColors.totalOrdersCancelled,
                ),
              ),
              title: 'Total Orders Cancelled',
            ),
          ],
        ),
      ),
    );
  }
}
