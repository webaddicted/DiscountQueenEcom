import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/home/domain/banner_model.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';
import 'package:portfolio/features/product/domain/review_model.dart';
import 'package:portfolio/features/product/domain/review_request_model.dart';

class CatalogRepository extends BaseRepository with Cacheable {
  Future<List<BannerModel>> getBanners() => cached(
        key: 'banners',
        fetcher: () => getList<BannerModel>(
          url: ApiConstant.banners,
          itemParser: (e) => BannerModel.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      ).then((r) => r.unwrap());

  Future<List<CategoryModel>> getCategories() => cached(
        key: 'categories',
        fetcher: () => getList<CategoryModel>(
          url: ApiConstant.categories,
          itemParser: (e) => CategoryModel.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      ).then((r) => r.unwrap());

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? category,
    int limit = 50,
    int offset = 0,
  }) =>
      getList<ProductModel>(
        url: ApiConstant.products,
        params: {
          if (categoryId != null && categoryId.isNotEmpty) 'category_id': categoryId,
          if (category != null && category.isNotEmpty) 'category': category,
          'limit': limit,
          'offset': offset,
        },
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<List<ProductModel>> getFeaturedProducts() => cached(
        key: 'featured',
        fetcher: () => getList<ProductModel>(
          url: ApiConstant.featuredProducts,
          itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      ).then((r) => r.unwrap());

  Future<List<ProductModel>> getPopularProducts() => cached(
        key: 'popular',
        fetcher: () => getList<ProductModel>(
          url: ApiConstant.popularProducts,
          itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      ).then((r) => r.unwrap());

  Future<List<ProductModel>> getNewArrivals() => cached(
        key: 'new_arrivals',
        fetcher: () => getList<ProductModel>(
          url: ApiConstant.newArrivals,
          itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
        ),
      ).then((r) => r.unwrap());

  Future<List<ProductModel>> searchProducts(String query) => getList<ProductModel>(
        url: ApiConstant.searchProducts,
        params: {'q': query},
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<ProductModel> getProductDetail(String productId) => get<ProductModel>(
        url: '${ApiConstant.products}/$productId',
        parser: (d) => ProductModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<List<ReviewModel>> getProductReviews(String productId) => getList<ReviewModel>(
        url: '${ApiConstant.products}/reviews/$productId',
        itemParser: (e) => ReviewModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<ReviewModel> addReview({
    required String productId,
    required double rating,
    String comment = '',
    List<String> images = const [],
  }) =>
      post<ReviewModel>(
        url: ApiConstant.addReview,
        parser: (d) => ReviewModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: ReviewRequest(
          productId: productId,
          rating: rating,
          comment: comment,
          images: images,
        ),
      ).unwrap();
}
