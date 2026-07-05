import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/model/product_model.dart';
import 'package:portfolio/model/review_model.dart';

class ProductController extends BaseController {
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
      await Future.delayed(const Duration(milliseconds: 400));
      selectedProduct.value = _getDummyProduct(id);
      selectedImageIndex.value = 0;
      selectedSize.value = '';
      selectedColor.value = '';
      quantity.value = 1;
      if (selectedProduct.value != null) {
        selectedSize.value = selectedProduct.value!.sizes.isNotEmpty
            ? selectedProduct.value!.sizes.first
            : '';
        selectedColor.value = selectedProduct.value!.colors.isNotEmpty
            ? selectedProduct.value!.colors.first
            : '';
        _loadRelatedProducts(selectedProduct.value!.categoryId);
        _loadReviews(id);
      }
    });
  }

  Future<void> loadProductsByCategory(String categoryId) async {
    await executeWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      products.value = _getDummyProductsByCategory(categoryId);
    });
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

  void _loadRelatedProducts(String categoryId) {
    relatedProducts.value = _getDummyProductsByCategory(categoryId)
        .where((p) => p.id != selectedProduct.value?.id)
        .take(6)
        .toList();
  }

  void _loadReviews(String productId) {
    reviews.value = [
      ReviewModel(
        id: 'r1',
        userId: 'u1',
        userName: 'Priya S.',
        userAvatar: 'https://i.pravatar.cc/100?img=1',
        productId: productId,
        rating: 4.5,
        comment: 'Great quality! My baby loves it. Very soft and comfortable.',
        images: [],
        createdAt: '2024-01-15',
      ),
      ReviewModel(
        id: 'r2',
        userId: 'u2',
        userName: 'Rahul M.',
        userAvatar: 'https://i.pravatar.cc/100?img=2',
        productId: productId,
        rating: 5.0,
        comment: 'Excellent product. Fast delivery and exactly as described.',
        images: [],
        createdAt: '2024-01-10',
      ),
      ReviewModel(
        id: 'r3',
        userId: 'u3',
        userName: 'Anita K.',
        userAvatar: 'https://i.pravatar.cc/100?img=3',
        productId: productId,
        rating: 4.0,
        comment: 'Good value for money. Would recommend to other parents.',
        images: [],
        createdAt: '2024-01-05',
      ),
    ];
  }

  ProductModel _getDummyProduct(String id) {
    return ProductModel(
      id: id,
      name: 'Organic Cotton Baby Onesie',
      description:
          'Premium organic cotton baby onesie, perfect for sensitive skin. '
          'Made with 100% GOTS certified organic cotton. Features snap buttons '
          'for easy diaper changes. Machine washable and gets softer with each wash.',
      shortDescription: 'Soft organic cotton onesie for babies',
      price: 899,
      mrp: 1299,
      discountPercent: 31,
      images: [
        'https://picsum.photos/400/400?random=1',
        'https://picsum.photos/400/400?random=2',
        'https://picsum.photos/400/400?random=3',
      ],
      thumbnail: 'https://picsum.photos/400/400?random=1',
      categoryId: 'cat1',
      categoryName: 'Clothing',
      brand: 'Shutku Baby',
      rating: 4.6,
      reviewCount: 128,
      inStock: true,
      stockQty: 25,
      sizes: ['0-3M', '3-6M', '6-9M', '9-12M'],

      colors: ['#FF0000', '#0000FF', '#00FF00', '#FFFF00'],

      tags: ['organic', 'cotton', 'newborn'],
      specifications: {
        'Material': '100% Organic Cotton',
        'Care': 'Machine wash cold',
        'Origin': 'India',
      },
      isFeatured: true,
      isPopular: true,
      isNewArrival: true,
    );
  }

  List<ProductModel> _getDummyProductsByCategory(String categoryId) {
    return [
      ProductModel(
        id: 'p1',
        name: 'Organic Cotton Baby Onesie',
        shortDescription: 'Soft organic cotton',
        price: 899,
        mrp: 1299,
        discountPercent: 31,
        thumbnail: 'https://picsum.photos/400/400?random=1',
        categoryId: categoryId,
        categoryName: 'Clothing',
        brand: 'Shutku',
        rating: 4.6,
        reviewCount: 128,
        sizes: ['0-3M', '3-6M'],
        colors: ['#FF0000', '#0000FF'],
      ),
      ProductModel(
        id: 'p2',
        name: 'Baby Feeding Bottle Set',
        shortDescription: 'BPA-free bottles',
        price: 599,
        mrp: 799,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/400/400?random=4',
        categoryId: categoryId,
        categoryName: 'Feeding',
        brand: 'Shutku',
        rating: 4.8,
        reviewCount: 256,
        isNewArrival: true,
      ),
      ProductModel(
        id: 'p3',
        name: 'Soft Baby Blanket',
        shortDescription: 'Ultra-soft blanket',
        price: 999,
        mrp: 1299,
        discountPercent: 23,
        thumbnail: 'https://picsum.photos/400/400?random=5',
        categoryId: categoryId,
        categoryName: 'Bedding',
        brand: 'Shutku',
        rating: 4.6,
        reviewCount: 89,
      ),
      ProductModel(
        id: 'p4',
        name: 'Baby Diaper Bag',
        shortDescription: 'Spacious & stylish',
        price: 1499,
        mrp: 1999,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/400/400?random=6',
        categoryId: categoryId,
        categoryName: 'Accessories',
        brand: 'Shutku',
        rating: 4.4,
        reviewCount: 67,
      ),
      ProductModel(
        id: 'p5',
        name: 'Baby Rattle Toy',
        shortDescription: 'Safe & colorful',
        price: 299,
        mrp: 399,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/400/400?random=7',
        categoryId: categoryId,
        categoryName: 'Toys',
        brand: 'Shutku',
        rating: 4.9,
        reviewCount: 312,
        isPopular: true,
      ),
      ProductModel(
        id: 'p6',
        name: 'Baby Moisturizer',
        shortDescription: 'Hypoallergenic',
        price: 449,
        mrp: 549,
        discountPercent: 18,
        thumbnail: 'https://picsum.photos/400/400?random=8',
        categoryId: categoryId,
        categoryName: 'Skincare',
        brand: 'Shutku',
        rating: 4.7,
        reviewCount: 145,
      ),
    ];
  }
}
