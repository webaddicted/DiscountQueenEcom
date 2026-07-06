import 'package:get/get.dart';
import 'package:portfolio/features/home/data/catalog_repository.dart';
import 'package:portfolio/features/main/controller/main_controller.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/features/home/domain/banner_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class HomeController extends BaseController {
  final _catalog = Get.find<CatalogRepository>();

  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> popularProducts = <ProductModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxBool isLoaded = false.obs;
  bool _loaded = false;

  RxBool get isLoadedRx => isLoaded;

  bool get hasAnyContent =>
      banners.isNotEmpty ||
      featuredProducts.isNotEmpty ||
      popularProducts.isNotEmpty ||
      newArrivals.isNotEmpty;

  Future<void> loadHomeData({bool force = false}) async {
    if (_loaded && !force) return;
    showLoading();
    clearError();

    try {
      final results = await Future.wait([
        _safeLoad(() => _catalog.getBanners()),
        _safeLoad(() => _catalog.getFeaturedProducts()),
        _safeLoad(() => _catalog.getPopularProducts()),
        _safeLoad(() => _catalog.getNewArrivals()),
      ]);

      banners.assignAll(results[0] as List<BannerModel>);
      featuredProducts.assignAll(results[1] as List<ProductModel>);
      popularProducts.assignAll(results[2] as List<ProductModel>);
      newArrivals.assignAll(results[3] as List<ProductModel>);
      _loaded = true;
      isLoaded.value = true;
    } catch (e) {
      setError(e.toString());
    } finally {
      hideLoading();
    }
  }

  Future<List<T>> _safeLoad<T>(Future<List<T>> Function() loader) async {
    try {
      return await loader();
    } catch (_) {
      return <T>[];
    }
  }

  /// Backward-compatible alias for pull-to-refresh on home.
  Future<void> loadData({bool force = true}) => loadHomeData(force: force);

  void onBannerTap(BannerModel banner) {
    if (banner.actionType == 'category' && banner.actionValue.isNotEmpty) {
      toNamed(RoutersConst.productList, arguments: banner.actionValue);
    } else if (banner.actionType == 'collection' && banner.actionValue == 'new') {
      toNamed(RoutersConst.productList, arguments: {'filter': 'new'});
    }
  }

  void onViewAllCategories() {
    if (Get.isRegistered<MainController>()) {
      Get.find<MainController>().navigateToTab(1);
    } else {
      toNamed(RoutersConst.categories);
    }
  }

  void onProductTap(ProductModel product) {
    toNamed(RoutersConst.productDetail, arguments: product.id);
  }

  void onViewAllFeatured() {
    toNamed(RoutersConst.productList, arguments: {'filter': 'featured'});
  }

  void onViewAllPopular() {
    toNamed(RoutersConst.productList, arguments: {'filter': 'popular'});
  }

  void onViewAllNewArrivals() {
    toNamed(RoutersConst.productList, arguments: {'filter': 'new'});
  }

  void onSearchTap() => toNamed(RoutersConst.search);
}
