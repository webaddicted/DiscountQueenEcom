import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class WishlistRepository extends BaseRepository {
  Future<List<ProductModel>> getWishlist() => getList<ProductModel>(
        url: ApiConstant.wishlist,
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<List<ProductModel>> addToWishlist(String productId) => postList<ProductModel>(
        url: ApiConstant.addToWishlist,
        params: {'product_id': productId},
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<List<ProductModel>> removeFromWishlist(String productId) =>
      postList<ProductModel>(
        url: ApiConstant.removeFromWishlist,
        params: {'product_id': productId},
        itemParser: (e) => ProductModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();
}
