import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';

class HelpSupportPage extends BaseStatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.helpSupportTitle,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: AppTextStyle.titleMedium,
            ),
            const SizedBox(height: DesignTokens.spacing8),
            Text(
              'Email: ${AppConstant.supportEmail}',
              style: AppTextStyle.bodyMedium,
            ),
            Text(
              'WhatsApp: ${AppConstant.whatsappNumber}',
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
