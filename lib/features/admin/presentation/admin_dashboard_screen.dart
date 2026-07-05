import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/theme/app_theme.dart';

class AdminDashboardScreen extends BaseStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  BaseState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends BaseState<AdminDashboardScreen> {
  final _repo = Get.find<AdminRepository>();
  var _loading = true;

  @override
  void initUIState() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      await _repo.loadDashboard();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget initBuild(BuildContext context) {
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
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
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
                            value: '${_repo.userCount}',
                            icon: Icons.people_outline_rounded,
                            gradient: AdminTheme.softAccentGradient(mint: true),
                            iconColor: AdminTheme.accentMint,
                          ),
                          _StatCard(
                            label: 'Orders',
                            value: '${_repo.orderCount}',
                            icon: Icons.receipt_long_outlined,
                            gradient: AdminTheme.softAccentGradient(mint: false),
                            iconColor: AdminTheme.accentRose,
                          ),
                          _StatCard(
                            label: 'Revenue',
                            value:
                                '${AppConstant.currency}${_repo.revenueTotal.toStringAsFixed(0)}',
                            icon: Icons.currency_rupee_rounded,
                            gradient: AdminTheme.softAccentGradient(mint: true),
                            iconColor: const Color(0xFF059669),
                          ),
                          _StatCard(
                            label: 'Today',
                            value: '${_repo.ordersToday}',
                            icon: Icons.today_outlined,
                            gradient: AdminTheme.softAccentGradient(mint: false),
                            iconColor: const Color(0xFF6366F1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
