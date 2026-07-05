import 'package:get/get.dart';
import 'package:portfolio/features/home/data/catalog_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class ShopSearchController extends BaseController {
  final _catalog = Get.find<CatalogRepository>();

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

  Future<void> search(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query);
      if (recentSearches.length > 10) recentSearches.removeLast();
    }
    await executeWithLoading(() async {
      searchResults.value = await _catalog.searchProducts(query);
    });
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
}
