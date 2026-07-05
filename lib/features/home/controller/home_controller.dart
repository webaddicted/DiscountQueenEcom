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
  bool _loaded = false;

  Future<void> loadHomeData({bool force = false}) async {
    if (_loaded && !force) return;
    await executeWithLoading(() async {
      final results = await Future.wait([
        _catalog.getBanners(),
        _catalog.getFeaturedProducts(),
        _catalog.getPopularProducts(),
        _catalog.getNewArrivals(),
      ]);
      banners.assignAll(results[0] as List<BannerModel>);
      featuredProducts.assignAll(results[1] as List<ProductModel>);
      popularProducts.assignAll(results[2] as List<ProductModel>);
      newArrivals.assignAll(results[3] as List<ProductModel>);
      _loaded = true;
    });
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
