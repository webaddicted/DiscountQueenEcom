import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/sp/sp_manager.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class AdminUsersScreen extends BaseStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  BaseState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends BaseState<AdminUsersScreen> {
  final _repo = Get.find<AdminRepository>();
  List<UserModel> _list = [];
  var _loading = true;

  @override
  void initUIState() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listUsers();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Users',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Users'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(DesignTokens.spacing16),
                itemCount: _list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final u = _list[i];
                  return _UserCard(
                    user: u,
                    onSaved: _load,
                    repo: _repo,
                  );
                },
              ),
      ),
    );
  }
}

class _UserCard extends BaseStatefulWidget {
  const _UserCard({
    required this.user,
    required this.onSaved,
    required this.repo,
  });

  final UserModel user;
  final VoidCallback onSaved;
  final AdminRepository repo;

  @override
  BaseState<_UserCard> createState() => _UserCardState();
}

class _UserCardState extends BaseState<_UserCard> {
  late bool _admin;
  late bool _blocked;
  late final TextEditingController _reason;
  var _saving = false;

  @override
  void initUIState() {
    _admin = widget.user.isAdmin;
    _blocked = widget.user.isBlocked;
    _reason = TextEditingController(text: widget.user.blockReason ?? '');
    if (kDebugMode && _reason.text.trim().isEmpty) {
      _reason.text = 'Policy verification pending';
    }
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.repo.updateUserFlags(
        widget.user.id,
        isAdmin: _admin,
        isBlocked: _blocked,
        blockReason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
      );
      if (widget.user.id == SPManager.getUserId()) {
        await SPManager.setUserAdmin(_admin);
      }
      showSuccess('User updated', title: 'Saved');
      widget.onSaved();
    } catch (e) {
      showError('$e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminTheme.card(
      context: context,
      padding: const EdgeInsets.all(DesignTokens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AdminTheme.accentMint.withValues(alpha: 0.15),
                child: Text(
                  widget.user.name.isNotEmpty ? widget.user.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AdminTheme.accentMint,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name.isNotEmpty ? widget.user.name : '—',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      widget.user.email.isNotEmpty
                          ? widget.user.email
                          : widget.user.phone,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignTokens.spacing12),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Admin'),
            value: _admin,
            onChanged: (v) => setState(() => _admin = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Blocked'),
            value: _blocked,
            onChanged: (v) => setState(() => _blocked = v),
          ),
          TextField(
            controller: _reason,
            decoration: const InputDecoration(
              labelText: 'Block reason',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: DesignTokens.spacing12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
