import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/theme/app_theme.dart';

class _AdminEntry {
  const _AdminEntry({
    required this.icon,
    required this.label,
    required this.route,
    required this.accent,
  });

  final IconData icon;
  final String label;
  final String route;
  final Color accent;
}

class AdminShellScreen extends StatelessWidget {
  const AdminShellScreen({super.key});

  static const _entries = <_AdminEntry>[
    _AdminEntry(
      icon: Icons.dashboard_rounded,
      label: 'Dashboard',
      route: RoutersConst.adminDashboard,
      accent: Color(0xFF0D9488),
    ),
    _AdminEntry(
      icon: Icons.people_outline_rounded,
      label: 'Users',
      route: RoutersConst.adminUsers,
      accent: Color(0xFF6366F1),
    ),
    _AdminEntry(
      icon: Icons.inventory_2_outlined,
      label: 'Products',
      route: RoutersConst.adminProducts,
      accent: Color(0xFF059669),
    ),
    _AdminEntry(
      icon: Icons.category_outlined,
      label: 'Categories',
      route: RoutersConst.adminCategories,
      accent: Color(0xFFEA580C),
    ),
    _AdminEntry(
      icon: Icons.receipt_long_outlined,
      label: 'Orders',
      route: RoutersConst.adminOrders,
      accent: Color(0xFF2563EB),
    ),
    _AdminEntry(
      icon: Icons.payments_outlined,
      label: 'Payments',
      route: RoutersConst.adminPayments,
      accent: Color(0xFF7C3AED),
    ),
    _AdminEntry(
      icon: Icons.rate_review_outlined,
      label: 'Reviews',
      route: RoutersConst.adminReviews,
      accent: Color(0xFFDB2777),
    ),
    _AdminEntry(
      icon: Icons.image_outlined,
      label: 'Banners',
      route: RoutersConst.adminBanners,
      accent: Color(0xFF0891B2),
    ),
    _AdminEntry(
      icon: Icons.local_offer_outlined,
      label: 'Coupons',
      route: RoutersConst.adminCoupons,
      accent: Color(0xFFE11D48),
    ),
    _AdminEntry(
      icon: Icons.notifications_active_outlined,
      label: 'Push drafts',
      route: RoutersConst.adminNotifications,
      accent: Color(0xFFC026D3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AdminAccessGate(
      title: 'Admin',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        body: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              floating: false,
              pinned: true,
              expandedHeight: 128,
              backgroundColor: AdminTheme.surface(context),
              surfaceTintColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Text(
                  'Store admin',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                ),
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 56, 16, 0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Manage catalog, orders, and campaigns',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final e = _entries[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            BorderRadius.circular(DesignTokens.radius16),
                        onTap: () => Get.toNamed(e.route),
                        child: Ink(
                          decoration: AdminTheme.cardDecoration(context),
                          child: Padding(
                            padding: const EdgeInsets.all(DesignTokens.spacing16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    gradient:
                                        AdminTheme.softAccentGradient(mint: index.isEven),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(e.icon, color: e.accent, size: 26),
                                ),
                                const Spacer(),
                                Text(
                                  e.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Icon(Icons.arrow_forward_ios_rounded,
                                    size: 12, color: cs.outline),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: _entries.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
