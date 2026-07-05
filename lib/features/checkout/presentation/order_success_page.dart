import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/color_const.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/gradient_button.dart';
import 'package:portfolio/model/order_model.dart';

class OrderSuccessPage extends BaseStatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final order = Get.arguments as OrderModel?;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorConst.primaryColor.withOpacity(0.15),
              ColorConst.secondaryColor.withOpacity(0.1),
              ColorConst.colorFF10B981.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(DesignTokens.spacing8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSuccessIcon(context),
                SizedBox(height: DesignTokens.spacing24),
                Text(
                  StringConst.orderPlaced,
                  style: AppTextStyle.headlineMedium.copyWith(
                    color: ColorConst.colorFF059669,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: DesignTokens.spacing8),
                Text(
                  StringConst.orderPlacedSubtitle,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: ColorConst.colorFF6B7280,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (order != null) ...[
                  SizedBox(height: DesignTokens.spacing24),
                  _buildOrderIdCard(context, order),
                ],
                const Spacer(),
                _buildButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConst.colorFF10B981,
                  ColorConst.colorFF059669,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorConst.colorFF10B981.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.check_rounded,
              size: 64,
              color: ColorConst.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderIdCard(BuildContext context, OrderModel order) {
    return Container(
      padding: EdgeInsets.all(DesignTokens.spacing8),
      decoration: BoxDecoration(
        color: ColorConst.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(DesignTokens.radius16),
        boxShadow: DesignTokens.shadowMedium,
      ),
      child: Column(
        children: [
          Text(
            StringConst.orderId,
            style: AppTextStyle.labelMedium.copyWith(
              color: ColorConst.colorFF6B7280,
            ),
          ),
          SizedBox(height: DesignTokens.spacing4),
          Text(
            order.orderNumber,
            style: AppTextStyle.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        GradientButton(
          onTap: () => Get.offAllNamed(RoutersConst.home),
          child: Text(
            StringConst.continueShopping,
            style: AppTextStyle.buttonText.copyWith(
              color: ColorConst.white,
            ),
          ),
        ),
        SizedBox(height: DesignTokens.spacing8),
        OutlinedButton(
          onPressed: () => Get.offAllNamed(RoutersConst.home),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            side: BorderSide(color: ColorConst.primaryColor),
          ),
          child: Text(
            StringConst.trackOrder,
            style: AppTextStyle.buttonText.copyWith(
              color: ColorConst.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
