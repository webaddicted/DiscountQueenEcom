import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/data/repositories/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/model/banner_model.dart';

class AdminBannersScreen extends StatefulWidget {
  const AdminBannersScreen({super.key});

  @override
  State<AdminBannersScreen> createState() => _AdminBannersScreenState();
}

class _AdminBannersScreenState extends State<AdminBannersScreen> {
  final _repo = Get.find<AdminRepository>();
  List<BannerModel> _list = [];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listBannersAdmin();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([BannerModel? existing]) async {
    final title = TextEditingController(text: existing?.title ?? '');
    final subtitle = TextEditingController(text: existing?.subtitle ?? '');
    final image = TextEditingController(text: existing?.image ?? '');
    final actionType =
        TextEditingController(text: existing?.actionType ?? 'category');
    final actionValue = TextEditingController(text: existing?.actionValue ?? '');
    final order = TextEditingController(text: '${existing?.sortOrder ?? _list.length}');
    var active = existing?.isActive ?? true;
    if (existing == null && kDebugMode) {
      title.text = 'Summer Collection';
      subtitle.text = 'Fresh styles for kids';
      image.text =
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8';
      actionType.text = 'category';
      actionValue.text = '';
      order.text = '${_list.length}';
    }
    final ok = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setSt) {
          return AlertDialog(
            title: Text(existing == null ? 'New banner' : 'Edit banner'),
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
                    controller: subtitle,
                    decoration: const InputDecoration(
                      labelText: 'Subtitle',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: image,
                    decoration: const InputDecoration(
                      labelText: 'Image URL *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: actionType,
                    decoration: const InputDecoration(
                      labelText: 'Action type',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: actionValue,
                    decoration: const InputDecoration(
                      labelText: 'Action value (e.g. category id)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: order,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sort order',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Active'),
                    value: active,
                    onChanged: (v) => setSt(() => active = v),
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
    final id = existing?.id ?? _repo.generateBannerId();
    final b = BannerModel(
      id: id,
      title: title.text.trim(),
      subtitle: subtitle.text.trim(),
      image: image.text.trim(),
      actionType: actionType.text.trim().isEmpty ? 'category' : actionType.text.trim(),
      actionValue: actionValue.text.trim(),
      sortOrder: int.tryParse(order.text.trim()) ?? 0,
      isActive: active,
    );
    await _repo.saveBanner(b);
    showSuccess('Banner saved', title: 'Saved');
    _load();
  }

  Future<void> _delete(BannerModel b) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete banner?'),
        content: Text(b.title),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteBanner(b.id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return AdminAccessGate(
      title: 'Banners',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Banners'),
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
                  final b = _list[i];
                  return AdminTheme.card(
                    context: context,
                    child: ListTile(
                      title: Text(b.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('Order ${b.sortOrder} · ${b.isActive ? "live" : "off"}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openForm(b),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(b),
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
