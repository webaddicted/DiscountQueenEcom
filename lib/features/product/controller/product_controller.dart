import 'package:get/get.dart';
import 'package:portfolio/features/home/data/catalog_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/product/domain/product_model.dart';
import 'package:portfolio/features/product/domain/review_model.dart';

class ProductController extends BaseController {
  final _catalog = Get.find<CatalogRepository>();

  final selectedProduct = Rx<ProductModel?>(null);
  final products = <ProductModel>[].obs;
  final relatedProducts = <ProductModel>[].obs;
  final reviews = <ReviewModel>[].obs;
  final selectedImageIndex = 0.obs;
  final selectedSize = ''.obs;
  final selectedColor = ''.obs;
  final quantity = 1.obs;

  @override
  void onControllerInit() {}

  Future<void> loadProduct(String id) async {
    await executeWithLoading(() async {
      selectedProduct.value = await _catalog.getProductDetail(id);
      selectedImageIndex.value = 0;
      selectedSize.value = '';
      selectedColor.value = '';
      quantity.value = 1;
      final p = selectedProduct.value;
      if (p != null) {
        if (p.sizes.isNotEmpty) selectedSize.value = p.sizes.first;
        if (p.colors.isNotEmpty) selectedColor.value = p.colors.first;
        await _loadRelatedProducts(p.categoryId, p.id);
        await _loadReviews(id);
      }
    });
  }

  Future<void> loadProductsByCategory(dynamic args) async {
    await executeWithLoading(() async {
      if (args is Map && args['filter'] != null) {
        products.value = await _loadByFilter(args['filter'] as String);
        return;
      }
      final categoryId = args?.toString() ?? '';
      if (categoryId.isEmpty || categoryId.startsWith('cat_')) {
        products.value = await _catalog.getProducts();
      } else if (categoryId.contains('-')) {
        products.value = await _catalog.getProducts(categoryId: categoryId);
      } else {
        products.value = await _catalog.getProducts(category: categoryId);
      }
    });
  }

  Future<List<ProductModel>> _loadByFilter(String filter) async {
    switch (filter) {
      case 'featured':
        return _catalog.getFeaturedProducts();
      case 'popular':
        return _catalog.getPopularProducts();
      case 'new':
        return _catalog.getNewArrivals();
      default:
        return _catalog.getProducts();
    }
  }

  void incrementQty() {
    final p = selectedProduct.value;
    if (p != null && quantity.value < (p.stockQty > 0 ? p.stockQty : 99)) {
      quantity.value++;
    }
  }

  void decrementQty() {
    if (quantity.value > 1) quantity.value--;
  }

  void selectSize(String size) => selectedSize.value = size;
  void selectColor(String color) => selectedColor.value = color;

  Future<void> _loadRelatedProducts(String categoryId, String excludeId) async {
    if (categoryId.isEmpty) {
      relatedProducts.clear();
      return;
    }
    final list = await _catalog.getProducts(categoryId: categoryId, limit: 8);
    relatedProducts.value =
        list.where((p) => p.id != excludeId).take(6).toList();
  }

  Future<void> _loadReviews(String productId) async {
    reviews.value = await _catalog.getProductReviews(productId);
  }

  Future<void> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    await executeWithLoading(() async {
      await _catalog.addReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      await _loadReviews(productId);
    });
  }
}
