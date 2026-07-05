import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/features/orders/domain/order_model.dart';
import 'package:intl/intl.dart';

/// Read-only payment references from orders (Razorpay-style ids when present).
class AdminPaymentsScreen extends BaseStatefulWidget {
  const AdminPaymentsScreen({super.key});

  @override
  BaseState<AdminPaymentsScreen> createState() => _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends BaseState<AdminPaymentsScreen> {
  final _repo = Get.find<AdminRepository>();
  List<OrderModel> _list = [];
  var _loading = true;

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
      _list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Payments',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Payments'),
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
                ? const Center(child: Text('No payment records'))
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
                          leading: CircleAvatar(
                            backgroundColor:
                                AdminTheme.accentMint.withValues(alpha: 0.12),
                            child: const Icon(Icons.payment_rounded, size: 22),
                          ),
                          title: Text(
                            o.paymentRef.isNotEmpty ? o.paymentRef : '—',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${_money.format(o.total)} · ${created != null ? _dt.format(created) : ""}\n'
                            'User: ${o.userId.isNotEmpty ? o.userId : "—"}',
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
