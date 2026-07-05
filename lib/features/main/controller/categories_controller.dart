import 'package:get/get.dart';
import 'package:portfolio/features/home/data/catalog_repository.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/features/home/domain/category_model.dart';

class CategoriesController extends BaseController {
  final _catalog = Get.find<CatalogRepository>();

  final categories = <CategoryModel>[].obs;
  bool _loaded = false;

  Future<void> loadCategories({bool force = false}) async {
    if (_loaded && !force) return;
    await executeWithLoading(() async {
      categories.value = await _catalog.getCategories();
      _loaded = true;
    });
  }

  void onCategoryTap(CategoryModel category) {
    toNamed(RoutersConst.productList, arguments: category.id);
  }
}
