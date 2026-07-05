import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateless_widget.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/theme/app_theme.dart';

class AdminDashboardScreen extends BaseStatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget initBuild(BuildContext context) {
    final repo = Get.find<AdminRepository>();
    final cs = Theme.of(context).colorScheme;

    return AdminAccessGate(
      title: 'Dashboard',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Dashboard'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(DesignTokens.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Overview',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: DesignTokens.spacing12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    _StatCard(
                      label: 'Users',
                      value: '${repo.userCount}',
                      icon: Icons.people_outline_rounded,
                      gradient: AdminTheme.softAccentGradient(mint: true),
                      iconColor: AdminTheme.accentMint,
                    ),
                    _StatCard(
                      label: 'Orders',
                      value: '${repo.orderCount}',
                      icon: Icons.receipt_long_outlined,
                      gradient: AdminTheme.softAccentGradient(mint: false),
                      iconColor: AdminTheme.accentRose,
                    ),
                    _StatCard(
                      label: 'Revenue',
                      value:
                          '${AppConstant.currency}${repo.revenueTotal.toStringAsFixed(0)}',
                      icon: Icons.currency_rupee_rounded,
                      gradient: AdminTheme.softAccentGradient(mint: true),
                      iconColor: const Color(0xFF059669),
                    ),
                    _StatCard(
                      label: 'Today',
                      value: '${repo.ordersToday}',
                      icon: Icons.today_outlined,
                      gradient: AdminTheme.softAccentGradient(mint: false),
                      iconColor: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DesignTokens.spacing8),
              Text(
                'Figures reflect local demo data until your API is connected.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.outline,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends BaseStatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Gradient gradient;
  final Color iconColor;

  @override
  Widget initBuild(BuildContext context) {
    return Container(
      decoration: AdminTheme.cardDecoration(context),
      child: Padding(
        padding: const EdgeInsets.all(DesignTokens.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const Spacer(),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
