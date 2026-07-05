import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/features/admin/domain/coupon_model.dart';

class AdminCouponsScreen extends BaseStatefulWidget {
  const AdminCouponsScreen({super.key});

  @override
  BaseState<AdminCouponsScreen> createState() => _AdminCouponsScreenState();
}

class _AdminCouponsScreenState extends BaseState<AdminCouponsScreen> {
  final _repo = Get.find<AdminRepository>();
  List<CouponModel> _list = [];
  var _loading = true;

  @override
  void initUIState() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listCouponsAdmin();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openForm([CouponModel? existing]) async {
    final code = TextEditingController(text: existing?.code ?? '');
    final pct = TextEditingController(text: '${existing?.discountPercent ?? 10}');
    final max = TextEditingController(text: existing?.maxDiscount.toStringAsFixed(0) ?? '500');
    var expiry = existing?.expiry ?? DateTime.now().add(const Duration(days: 30));
    var active = existing?.active ?? true;
    if (existing == null && kDebugMode) {
      code.text = 'WELCOME10';
      pct.text = '10';
      max.text = '500';
    }
    final ok = await Get.dialog<bool>(
      StatefulBuilder(
        builder: (context, setSt) {
          return AlertDialog(
            title: Text(existing == null ? 'New coupon' : 'Edit coupon'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: code,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Code *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pct,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Discount %',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: max,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max discount (${AppConstant.currency})',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Expiry'),
                    subtitle: Text(expiry.toString().split(' ').first),
                    trailing: const Icon(Icons.calendar_today_rounded),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: expiry,
                        firstDate: DateTime.now().subtract(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                      );
                      if (d != null) setSt(() => expiry = d);
                    },
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
    final id = existing?.id ?? _repo.generateCouponId();
    final c = CouponModel(
      id: id,
      code: code.text.trim(),
      discountPercent: int.tryParse(pct.text.trim()) ?? 0,
      maxDiscount: double.tryParse(max.text.trim()) ?? 0,
      expiry: expiry,
      active: active,
    );
    await _repo.saveCoupon(c);
    showSuccess('Coupon saved', title: 'Saved');
    _load();
  }

  Future<void> _delete(CouponModel c) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete coupon?'),
        content: Text(c.code),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await _repo.deleteCoupon(c.id);
    _load();
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Coupons',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Coupons'),
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
                      title: Text(
                        c.code,
                        style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.2),
                      ),
                      subtitle: Text(
                        '${c.discountPercent}% off · max ${AppConstant.currency}${c.maxDiscount.toStringAsFixed(0)} · ${c.active ? "active" : "off"}',
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
