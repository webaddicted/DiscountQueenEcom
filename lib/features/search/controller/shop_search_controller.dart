import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class ShopSearchController extends BaseController {
  final searchQuery = ''.obs;
  final searchResults = <ProductModel>[].obs;
  final recentSearches = <String>[].obs;
  final trendingSearches = <String>[
    'Baby Diapers',
    'Feeding Bottles',
    'Baby Clothes',
    'Strollers',
    'Baby Toys',
    'Cotton Onesies',
    'Baby Blankets',
    'Baby Care',
    'Nursing Pads',
    'Baby Wipes',
  ].obs;

  @override
  void onControllerInit() {
    recentSearches.value = ['Baby Diapers', 'Cotton Clothes', 'Feeding Set'];
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) recentSearches.removeLast();
    }
    searchResults.value = _filterProducts(query);
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  void removeRecentSearch(String query) {
    recentSearches.remove(query);
  }

  void clearRecentSearches() {
    recentSearches.clear();
  }

  List<ProductModel> _filterProducts(String query) {
    final all = _getDummyProducts();
    final q = query.toLowerCase();
    return all.where((p) => p.name.toLowerCase().contains(q)).toList();
  }

  List<ProductModel> _getDummyProducts() {
    return [
      ProductModel(
        id: 's1',
        name: 'Baby Cotton Onesie',
        price: 499,
        mrp: 699,
        discountPercent: 28,
        thumbnail: 'https://picsum.photos/200?random=1',
        images: ['https://picsum.photos/200?random=1'],
        rating: 4.5,
        reviewCount: 128,
        inStock: true,
      ),
      ProductModel(
        id: 's2',
        name: 'Soft Baby Blanket',
        price: 899,
        mrp: 999,
        discountPercent: 10,
        thumbnail: 'https://picsum.photos/200?random=2',
        images: ['https://picsum.photos/200?random=2'],
        rating: 4.8,
        reviewCount: 256,
        inStock: true,
      ),
      ProductModel(
        id: 's3',
        name: 'Baby Feeding Bottle Set',
        price: 599,
        mrp: 799,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/200?random=3',
        images: ['https://picsum.photos/200?random=3'],
        rating: 4.6,
        reviewCount: 89,
        inStock: true,
      ),
      ProductModel(
        id: 's4',
        name: 'Baby Diaper Pack',
        price: 449,
        mrp: 549,
        discountPercent: 18,
        thumbnail: 'https://picsum.photos/200?random=4',
        images: ['https://picsum.photos/200?random=4'],
        rating: 4.4,
        reviewCount: 312,
        inStock: true,
      ),
      ProductModel(
        id: 's5',
        name: 'Baby Clothes Set - 3 pcs',
        price: 999,
        mrp: 1299,
        discountPercent: 23,
        thumbnail: 'https://picsum.photos/200?random=5',
        images: ['https://picsum.photos/200?random=5'],
        rating: 4.7,
        reviewCount: 67,
        inStock: true,
      ),
      ProductModel(
        id: 's6',
        name: 'Baby Stroller - Lightweight',
        price: 4999,
        mrp: 5999,
        discountPercent: 16,
        thumbnail: 'https://picsum.photos/200?random=6',
        images: ['https://picsum.photos/200?random=6'],
        rating: 4.5,
        reviewCount: 45,
        inStock: true,
      ),
    ];
  }
}
