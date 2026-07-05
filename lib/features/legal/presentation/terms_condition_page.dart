import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';

class TermsConditionPage extends BaseStatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: StringConst.termsTitle,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Text(
          'Terms and conditions content goes here.',
          style: AppTextStyle.bodyMedium,
        ),
      ),
    );
  }
}
