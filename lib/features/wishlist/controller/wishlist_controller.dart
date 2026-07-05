import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/features/product/domain/product_model.dart';

class WishlistController extends BaseController {
  final wishlistItems = <ProductModel>[].obs;

  @override
  void onControllerInit() {
    wishlistItems.value = _getDummyProducts();
  }

  void toggleWishlist(ProductModel product) {
    final idx = wishlistItems.indexWhere((p) => p.id == product.id);
    if (idx >= 0) {
      wishlistItems.removeAt(idx);
    } else {
      wishlistItems.add(product);
    }
  }

  bool isInWishlist(String productId) {
    return wishlistItems.any((p) => p.id == productId);
  }

  void removeFromWishlist(String productId) {
    wishlistItems.removeWhere((p) => p.id == productId);
  }

  List<ProductModel> _getDummyProducts() {
    return [
      ProductModel(
        id: 'w1',
        name: 'Baby Cotton Onesie - Soft & Breathable',
        description: 'Premium cotton onesie for your little one',
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
        id: 'w2',
        name: 'Soft Baby Blanket - Organic',
        description: '100% organic cotton baby blanket',
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
        id: 'w3',
        name: 'Baby Feeding Bottle Set - BPA Free',
        description: 'Set of 3 feeding bottles with anti-colic design',
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
        id: 'w4',
        name: 'Baby Diaper Pack - Premium',
        description: 'Ultra-absorbent diapers for all-day comfort',
        price: 449,
        mrp: 549,
        discountPercent: 18,
        thumbnail: 'https://picsum.photos/200?random=4',
        images: ['https://picsum.photos/200?random=4'],
        rating: 4.4,
        reviewCount: 312,
        inStock: true,
      ),
    ];
  }
}
