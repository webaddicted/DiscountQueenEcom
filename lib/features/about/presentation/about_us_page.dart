import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';

class AboutUsPage extends BaseStatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: StringConst.aboutUsTitle,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstant.appName,
              style: AppTextStyle.headlineMedium,
            ),
            const SizedBox(height: DesignTokens.spacing8),
            Text(
              AppConstant.appTagline,
              style: AppTextStyle.bodyMedium.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: DesignTokens.spacing16),
            Text(
              AppConstant.appDescription,
              style: AppTextStyle.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
