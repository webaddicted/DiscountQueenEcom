import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/data/repositories/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/constant/app_constant.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/global/utils/dialog_utils.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/model/product_model.dart';
import 'package:intl/intl.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final _repo = Get.find<AdminRepository>();
  List<ProductModel> _list = [];
  var _loading = true;

  late final NumberFormat _money =
      NumberFormat.currency(symbol: AppConstant.currency, decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _list = await _repo.listProducts();
      _list.sort((a, b) => a.name.compareTo(b.name));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _delete(ProductModel p) async {
    showConfirmDialog(
      title: 'Delete product?',
      message: p.name,
      positiveText: 'Delete',
      negativeText: 'Cancel',
      onPositive: () async {
        await _repo.deleteProduct(p.id);
        showSuccess('Removed from catalog', title: 'Deleted');
        _load();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminAccessGate(
      title: 'Products',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: const Text('Products'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded)),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Get.toNamed(RoutersConst.adminProductForm);
            _load();
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add'),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                itemCount: _list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final p = _list[i];
                  return AdminTheme.card(
                    context: context,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        p.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        '${_money.format(p.price)} · stock ${p.stockQty}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () async {
                              await Get.toNamed(
                                RoutersConst.adminProductForm,
                                arguments: p.id,
                              );
                              _load();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _delete(p),
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
