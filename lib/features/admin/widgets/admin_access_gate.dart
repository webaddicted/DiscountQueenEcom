import 'package:flutter/material.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/theme/app_theme.dart';

/// Wraps admin screens: shows a friendly denial when not logged in as admin.
class AdminAccessGate extends StatelessWidget {
  const AdminAccessGate({
    super.key,
    required this.child,
    this.title = 'Admin',
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (!SPManager.isLoggedIn() || !SPManager.isUserAdmin()) {
      return Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: Text(title),
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(DesignTokens.spacing24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded,
                    size: 56, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: DesignTokens.spacing16),
                Text(
                  'Admin only',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: DesignTokens.spacing8),
                Text(
                  'Sign in with an admin email (starting with admin@) to manage the store.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return child;
  }
}
