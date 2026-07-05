import 'package:flutter/material.dart';
import 'package:portfolio/global/base/base_stateful_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:portfolio/features/admin/data/admin_repository.dart';
import 'package:portfolio/features/admin/widgets/admin_access_gate.dart';
import 'package:portfolio/features/admin/widgets/admin_theme.dart';
import 'package:portfolio/global/theme/app_theme.dart';
import 'package:portfolio/global/utils/snackbar_utils.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class AdminProductFormScreen extends BaseStatefulWidget {
  const AdminProductFormScreen({super.key});

  @override
  BaseState<AdminProductFormScreen> createState() => _AdminProductFormScreenState();
}

class _AdminProductFormScreenState extends BaseState<AdminProductFormScreen> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _shortDesc = TextEditingController();
  final _price = TextEditingController();
  final _mrp = TextEditingController();
  final _discount = TextEditingController();
  final _stock = TextEditingController();
  final _images = TextEditingController();
  final _thumbnail = TextEditingController();
  final _brand = TextEditingController();
  final _sizes = TextEditingController();
  final _colors = TextEditingController();
  final _tags = TextEditingController();
  final _rating = TextEditingController();
  final _reviews = TextEditingController();

  List<CategoryModel> _cats = [];
  String? _selectedCategoryId;
  String? _productId;
  var _loading = true;
  var _saving = false;
  var _featured = false;
  var _popular = false;
  var _newArrival = false;

  @override
  void initUIState() {
    _productId = Get.arguments as String?;
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final repo = Get.find<AdminRepository>();
    _cats = await repo.listCategoriesAdmin();
    final id = _productId;
    if (id != null) {
      final list = await repo.listProducts();
      ProductModel? p;
      try {
        p = list.firstWhere((e) => e.id == id);
      } catch (_) {}
      if (p != null) {
        _name.text = p.name;
        _desc.text = p.description;
        _shortDesc.text = p.shortDescription;
        _price.text = p.price.toStringAsFixed(0);
        _mrp.text = p.mrp.toStringAsFixed(0);
        _discount.text = '${p.discountPercent}';
        _stock.text = '${p.stockQty}';
        _images.text = p.images.join(', ');
        _thumbnail.text = p.thumbnail;
        _brand.text = p.brand;
        _sizes.text = p.sizes.join(', ');
        _colors.text = p.colors.join(', ');
        _tags.text = p.tags.join(', ');
        _rating.text = '${p.rating}';
        _reviews.text = '${p.reviewCount}';
        _selectedCategoryId = p.categoryId;
        _featured = p.isFeatured;
        _popular = p.isPopular;
        _newArrival = p.isNewArrival;
      }
    } else {
      if (kDebugMode) {
        _name.text = 'Kids Cotton T-Shirt';
        _shortDesc.text = 'Soft and breathable cotton t-shirt for daily wear';
        _desc.text =
            'Comfortable cotton t-shirt for kids with skin-friendly fabric and regular fit.';
        _price.text = '799';
        _mrp.text = '999';
        _discount.text = '20';
        _stock.text = '25';
        _images.text =
            'https://images.unsplash.com/photo-1512436991641-6745cdb1723f, https://images.unsplash.com/photo-1521572163474-6864f9cf17ab';
        _thumbnail.text =
            'https://images.unsplash.com/photo-1512436991641-6745cdb1723f';
        _brand.text = 'Queen Kids';
        _sizes.text = '2-3Y, 4-5Y, 6-7Y';
        _colors.text = 'Blue, White, Yellow';
        _tags.text = 'kids, cotton, summer, casual';
        _rating.text = '4.5';
        _reviews.text = '12';
      } else {
        _stock.text = '10';
        _discount.text = '0';
        _rating.text = '4.5';
        _reviews.text = '0';
      }
      if (_cats.isNotEmpty) _selectedCategoryId = _cats.first.id;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _shortDesc.dispose();
    _price.dispose();
    _mrp.dispose();
    _discount.dispose();
    _stock.dispose();
    _images.dispose();
    _thumbnail.dispose();
    _brand.dispose();
    _sizes.dispose();
    _colors.dispose();
    _tags.dispose();
    _rating.dispose();
    _reviews.dispose();
    super.dispose();
  }

  List<String> _split(String s) => s
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  Future<void> _save() async {
    final repo = Get.find<AdminRepository>();
    if (_name.text.trim().isEmpty) {
      showWarning('Product name is required');
      return;
    }
    if (_selectedCategoryId == null || _selectedCategoryId!.isEmpty) {
      showWarning('Choose a category');
      return;
    }
    final cat = _cats.firstWhere((c) => c.id == _selectedCategoryId);
    final id = _productId ?? repo.generateProductId();
    final price = double.tryParse(_price.text.trim()) ?? 0;
    final mrp = double.tryParse(_mrp.text.trim()) ?? 0;
    final disc = int.tryParse(_discount.text.trim()) ?? 0;
    final stock = int.tryParse(_stock.text.trim()) ?? 0;
    final images = _split(_images.text);
    final thumb = _thumbnail.text.trim().isNotEmpty
        ? _thumbnail.text.trim()
        : (images.isNotEmpty ? images.first : '');

    setState(() => _saving = true);
    try {
      final p = ProductModel(
        id: id,
        name: _name.text.trim(),
        description: _desc.text.trim(),
        shortDescription: _shortDesc.text.trim(),
        price: price,
        mrp: mrp,
        discountPercent: disc,
        images: images,
        thumbnail: thumb,
        categoryId: cat.id,
        categoryName: cat.name,
        brand: _brand.text.trim(),
        rating: double.tryParse(_rating.text.trim()) ?? 0,
        reviewCount: int.tryParse(_reviews.text.trim()) ?? 0,
        stockQty: stock,
        sizes: _split(_sizes.text),
        colors: _split(_colors.text),
        tags: _split(_tags.text),
        isFeatured: _featured,
        isPopular: _popular,
        isNewArrival: _newArrival,
        inStock: stock > 0,
      );
      await repo.saveProduct(p, existingId: _productId);
      showSuccess('Product saved', title: 'Saved');
      Get.back();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget initBuild(BuildContext context) {
    return AdminAccessGate(
      title: 'Product',
      child: Scaffold(
        backgroundColor: AdminTheme.surface(context),
        appBar: AppBar(
          title: Text(_productId == null ? 'New product' : 'Edit product'),
          elevation: 0,
          backgroundColor: AdminTheme.surface(context),
          surfaceTintColor: Colors.transparent,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(DesignTokens.spacing20),
                children: [
                  TextField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Name *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _shortDesc,
                    decoration: const InputDecoration(
                      labelText: 'Short description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _desc,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Category *',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _cats.map((c) {
                      final sel = _selectedCategoryId == c.id;
                      return FilterChip(
                        label: Text(c.name),
                        selected: sel,
                        onSelected: (_) {
                          setState(() => _selectedCategoryId = c.id);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _price,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price *',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _mrp,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'MRP',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _discount,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Discount %',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _stock,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock qty',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _brand,
                    decoration: const InputDecoration(
                      labelText: 'Brand',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _images,
                    decoration: const InputDecoration(
                      labelText: 'Image URLs (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _thumbnail,
                    decoration: const InputDecoration(
                      labelText: 'Thumbnail URL (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _colors,
                    decoration: const InputDecoration(
                      labelText: 'Colors (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sizes,
                    decoration: const InputDecoration(
                      labelText: 'Sizes (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _tags,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _rating,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Rating',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _reviews,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Review count',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Featured'),
                    value: _featured,
                    onChanged: (v) => setState(() => _featured = v),
                  ),
                  SwitchListTile(
                    title: const Text('Popular'),
                    value: _popular,
                    onChanged: (v) => setState(() => _popular = v),
                  ),
                  SwitchListTile(
                    title: const Text('New arrival'),
                    value: _newArrival,
                    onChanged: (v) => setState(() => _newArrival = v),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save product'),
                  ),
                ],
              ),
      ),
    );
  }
}
