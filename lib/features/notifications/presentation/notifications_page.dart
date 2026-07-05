import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:portfolio/global/constant/string_const.dart';
import 'package:portfolio/global/widgets/app_bar_widget.dart';
import 'package:portfolio/global/widgets/empty_widget.dart';

class NotificationsPage extends BaseStatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget initBuild(BuildContext context) {
    return const Scaffold(
      appBar: AppBarWidget(
        title: StringConst.notificationsTitle,
        showBack: true,
      ),
      body: EmptyWidget(
        message: 'No notifications yet',
        subtitle: 'Your notifications will appear here',
        icon: Icons.notifications_none_outlined,
      ),
    );
  }
}
