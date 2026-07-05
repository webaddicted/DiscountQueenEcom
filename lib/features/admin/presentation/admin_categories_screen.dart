import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/utils/dialog_utils.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/features/home/domain/category_model.dart';

class AdminCategoriesScreen extends BaseStatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  BaseState<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends BaseState<AdminCategoriesScreen> {
  final _repo = Get.find<AdminRepository>();
  List<CategoryModel> _list = [];
  var _loading = true;

  @override
  void initUIState() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listCategoriesAdmin();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([CategoryModel? existing]) async {
    final name = TextEditingController(text: existing?.name ?? '');
    final image = TextEditingController(text: existing?.image ?? '');
    final sort = TextEditingController(
      text: '${existing?.sortOrder ?? _list.length}',
    );
    var active = existing?.isActive ?? true;
    if (existing == null && kDebugMode) {
      name.text = 'Boys Fashion';
      image.text =
          'https://images.unsplash.com/photo-1518831959646-742c3a14ebf7';
      sort.text = '${_list.length}';
    }
    final ok = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setSt) {
          return AlertDialog(
            title: Text(existing == null ? 'New category' : 'Edit category'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: image,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: sort,
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
    final id = existing?.id ?? _repo.generateCategoryId();
    final so = int.tryParse(sort.text.trim()) ?? 0;
    final c = CategoryModel(
      id: id,
      name: name.text.trim(),
      image: image.text.trim(),
      sortOrder: so,
      isActive: active,
    );
    await _repo.saveCategory(c, existingId: existing?.id);
    showSuccess('Category saved', title: 'Saved');
    _load();
  }

  Future<void> _delete(CategoryModel c) async {
    showConfirmDialog(
      title: 'Delete category?',
      message: c.name,
      positiveText: 'Delete',
      negativeText: 'Cancel',
      onPositive: () async {
        await _repo.deleteCategory(c.id);
        showSuccess('Removed', title: 'Deleted');
        _load();
      },
    );
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Categories',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Categories'),
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
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final c = _list[i];
                  return AdminTheme.card(
                    context: context,
                    child: ListTile(
                      title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        'Order ${c.sortOrder} · ${c.isActive ? "active" : "hidden"}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _openForm(c),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(c),
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
