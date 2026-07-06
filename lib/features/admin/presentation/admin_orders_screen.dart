import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends BaseStatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  BaseState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends BaseState<AdminOrdersScreen> {
  final _repo = Get.find<AdminRepository>();
  List<OrderModel> _list = [];
  var _loading = true;

  static const _statuses = [
    'pending',
    'confirmed',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  late final NumberFormat _money =
      NumberFormat.currency(symbol: AppConstant.currency, decimalDigits: 0);
  late final DateFormat _dt = DateFormat.yMMMd().add_jm();

  @override
  void initUIState() {
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.allOrdersForAdmin();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changeStatus(OrderModel o) async {
    String? next;
    await Get.dialog<void>(
      AlertDialog(
        title: const Text('Order status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _statuses.map((s) {
            return ListTile(
              title: Text(s),
              onTap: () {
                next = s;
                Get.back();
              },
            );
          }).toList(),
        ),
      ),
    );
    if (next == null || next == o.status) return;
    await _repo.updateOrderStatus(o.id, next!);
    showSuccess('Status: $next', title: 'Updated');
    _load();
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Orders',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Orders'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _list.isEmpty
                ? Center(
                    child: Text(
                      'No orders yet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(DesignTokens.spacing16),
                    itemCount: _list.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final o = _list[i];
                      final created = DateTime.tryParse(o.createdAt);
                      return AdminTheme.card(
                        context: context,
                        child: ListTile(
                          title: Text(
                            _money.format(o.total),
                            style: AppTextStyle.titleMedium.copyWith(
                          fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            '${o.status} · ${created != null ? _dt.format(created) : o.createdAt}\n'
                            '${o.paymentRef.isNotEmpty ? o.paymentRef : "—"} · ${o.userId.isNotEmpty ? o.userId : "—"}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _changeStatus(o),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
