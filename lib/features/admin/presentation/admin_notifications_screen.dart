import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/data/repositories/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/model/notification_broadcast_model.dart';
import 'package:intl/intl.dart';

/// Draft broadcast messages (tracking only — push requires backend).
class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({super.key});

  @override
  State<AdminNotificationsScreen> createState() =>
      _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _repo = Get.find<AdminRepository>();
  List<NotificationBroadcastModel> _list = [];
  var _loading = true;

  late final DateFormat _dt = DateFormat.yMMMd().add_jm();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listBroadcasts();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([NotificationBroadcastModel? existing]) async {
    final title = TextEditingController(text: existing?.title ?? '');
    final body = TextEditingController(text: existing?.body ?? '');
    if (existing == null && kDebugMode) {
      title.text = 'Weekend Sale Alert';
      body.text = 'Get up to 50% off on selected kids wear this weekend.';
    }
    var sent = existing?.sent ?? false;
    final ok = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setSt) {
          return AlertDialog(
            title: Text(existing == null ? 'New draft' : 'Edit draft'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'Title *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: body,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Body *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Marked as sent'),
                    subtitle: const Text('For your records only'),
                    value: sent,
                    onChanged: (v) => setSt(() => sent = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
              FilledButton(onPressed: () => Get.back(result: true), child: const Text('Save')),
            ],
          );
        },
      ),
    );
    if (ok != true) return;
    final id = existing?.id ?? _repo.generateBroadcastId();
    final m = NotificationBroadcastModel(
      id: id,
      title: title.text.trim(),
      body: body.text.trim(),
      createdAt: existing?.createdAt ?? DateTime.now(),
      sent: sent,
    );
    await _repo.saveBroadcast(m);
    showSuccess('Draft saved', title: 'Saved');
    _load();
  }

  Future<void> _delete(NotificationBroadcastModel m) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete draft?'),
        content: Text(m.title),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteBroadcast(m.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return AdminAccessGate(
      title: 'Notifications',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Push drafts'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openForm(),
          child: const Icon(Icons.add_rounded),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                itemCount: _list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final m = _list[i];
                  return AdminTheme.card(
                    context: context,
                    child: ListTile(
                      title: Text(m.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        '${m.body}\n${_dt.format(m.createdAt)} · ${m.sent ? "sent" : "draft"}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openForm(m),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(m),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
