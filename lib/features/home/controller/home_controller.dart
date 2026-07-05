import 'package:get/get.dart';
import 'package:portfolio/global/base/base_controller.dart';
import 'package:portfolio/global/constant/routers_const.dart';
import 'package:portfolio/model/banner_model.dart';
import 'package:portfolio/model/category_model.dart';
import 'package:portfolio/model/product_model.dart';

class HomeController extends BaseController {
  final RxList<BannerModel> banners = <BannerModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxList<ProductModel> popularProducts = <ProductModel>[].obs;
  final RxList<ProductModel> newArrivals = <ProductModel>[].obs;
  final RxInt currentBannerIndex = 0.obs;

  @override
  void onControllerInit() {
    loadData();
  }

  Future<void> loadData() async {
    await executeWithLoading(() async {
      await Future.delayed(const Duration(milliseconds: 800));
      _loadBanners();
      _loadCategories();
      _loadFeaturedProducts();
      _loadPopularProducts();
      _loadNewArrivals();
    });
  }

  void _loadBanners() {
    banners.assignAll([
      BannerModel(
        id: '1',
        title: 'Baby Essentials Sale',
        subtitle: 'Up to 40% off on diapers & wipes',
        image: 'https://picsum.photos/seed/baby1/800/400',
        actionType: 'category',
        actionValue: 'diapers',
      ),
      BannerModel(
        id: '2',
        title: 'New Arrivals',
        subtitle: 'Fresh collection for your little one',
        image: 'https://picsum.photos/seed/baby2/800/400',
        actionType: 'collection',
        actionValue: 'new',
      ),
      BannerModel(
        id: '3',
        title: 'Feeding & Nursing',
        subtitle: 'Premium bottles & accessories',
        image: 'https://picsum.photos/seed/baby3/800/400',
        actionType: 'category',
        actionValue: 'feeding',
      ),
    ]);
  }

  void _loadCategories() {
    categories.assignAll([
      CategoryModel(
        id: '1',
        name: 'Diapers',
        image: 'https://picsum.photos/seed/diapers/200/200',
        icon: '',
        productCount: 45,
      ),

      CategoryModel(
        id: '2',
        name: 'Clothing',
        image: 'https://picsum.photos/seed/babyclothes/200/200',
        icon: '',
        productCount: 128,
      ),
      CategoryModel(
        id: '3',
        name: 'Feeding',
        image: 'https://picsum.photos/seed/feeding/200/200',
        icon: '',
        productCount: 62,
      ),
      CategoryModel(
        id: '4',
        name: 'Toys',
        image: 'https://picsum.photos/seed/toys/200/200',
        icon: '',
        productCount: 89,
      ),
      CategoryModel(
        id: '5',
        name: 'Strollers',
        image: 'https://picsum.photos/seed/strollers/200/200',
        icon: '',
        productCount: 24,
      ),
      CategoryModel(
        id: '6',
        name: 'Skincare',
        image: 'https://picsum.photos/seed/skincare/200/200',
        icon: '',
        productCount: 38,
      ),
      CategoryModel(
        id: '7',
        name: 'Nursery',
        image: 'https://picsum.photos/seed/nursery/200/200',
        icon: '',
        productCount: 56,
      ),
      CategoryModel(
        id: '8',
        name: 'Safety',
        image: 'https://picsum.photos/seed/safety/200/200',
        icon: '',
        productCount: 42,
      ),
    ]);
  }

  void _loadFeaturedProducts() {
    featuredProducts.assignAll([
      ProductModel(
        id: '1',
        name: 'Pampers Premium Care Diapers',
        shortDescription: 'Premium soft diapers for newborns',
        price: 899,
        mrp: 1199,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p1/400/400',
        images: ['https://picsum.photos/seed/p1/400/400'],
        categoryId: '1',
        categoryName: 'Diapers',
        brand: 'Pampers',
        rating: 4.5,
        reviewCount: 2340,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
      ProductModel(
        id: '2',
        name: 'Chicco Baby Bottle Set',
        shortDescription: 'BPA-free feeding bottles',
        price: 649,
        mrp: 799,
        discountPercent: 19,
        thumbnail: 'https://picsum.photos/seed/p2/400/400',
        images: ['https://picsum.photos/seed/p2/400/400'],
        categoryId: '3',
        categoryName: 'Feeding',
        brand: 'Chicco',
        rating: 4.7,
        reviewCount: 1892,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
      ProductModel(
        id: '3',
        name: 'Soft Cotton Baby Romper',
        shortDescription: '100% organic cotton',
        price: 449,
        mrp: 599,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p3/400/400',
        images: ['https://picsum.photos/seed/p3/400/400'],
        categoryId: '2',
        categoryName: 'Clothing',
        brand: 'FirstCry',
        rating: 4.6,
        reviewCount: 892,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
      ProductModel(
        id: '4',
        name: 'Fisher-Price Rattle Set',
        shortDescription: 'Sensory development toys',
        price: 299,
        mrp: 399,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p4/400/400',
        images: ['https://picsum.photos/seed/p4/400/400'],
        categoryId: '4',
        categoryName: 'Toys',
        brand: 'Fisher-Price',
        rating: 4.8,
        reviewCount: 4521,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
      ProductModel(
        id: '5',
        name: 'Johnson\'s Baby Lotion',
        shortDescription: '24hr moisture',
        price: 199,
        mrp: 249,
        discountPercent: 20,
        thumbnail: 'https://picsum.photos/seed/p5/400/400',
        images: ['https://picsum.photos/seed/p5/400/400'],
        categoryId: '6',
        categoryName: 'Skincare',
        brand: 'Johnson\'s',
        rating: 4.4,
        reviewCount: 5678,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
      ProductModel(
        id: '6',
        name: 'Baby Stroller Compact',
        shortDescription: 'Lightweight travel stroller',
        price: 4999,
        mrp: 6499,
        discountPercent: 23,
        thumbnail: 'https://picsum.photos/seed/p6/400/400',
        images: ['https://picsum.photos/seed/p6/400/400'],
        categoryId: '5',
        categoryName: 'Strollers',
        brand: 'Pigeon',
        rating: 4.5,
        reviewCount: 234,
        inStock: true,
        isFeatured: true,
        isPopular: false,
        isNewArrival: false,
      ),
    ]);
  }

  void _loadPopularProducts() {
    popularProducts.assignAll([
      ProductModel(
        id: '7',
        name: 'Huggies Dry Diapers',
        shortDescription: '12hr dryness protection',
        price: 749,
        mrp: 999,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p7/400/400',
        images: ['https://picsum.photos/seed/p7/400/400'],
        categoryId: '1',
        categoryName: 'Diapers',
        brand: 'Huggies',
        rating: 4.6,
        reviewCount: 3200,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
      ProductModel(
        id: '8',
        name: 'Baby Wipes Sensitive',
        shortDescription: 'Hypoallergenic wipes',
        price: 129,
        mrp: 169,
        discountPercent: 24,
        thumbnail: 'https://picsum.photos/seed/p8/400/400',
        images: ['https://picsum.photos/seed/p8/400/400'],
        categoryId: '1',
        categoryName: 'Diapers',
        brand: 'Pampers',
        rating: 4.5,
        reviewCount: 4100,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
      ProductModel(
        id: '9',
        name: 'Baby Carrier Wrap',
        shortDescription: 'Ergonomic baby carrier',
        price: 1899,
        mrp: 2499,
        discountPercent: 24,
        thumbnail: 'https://picsum.photos/seed/p9/400/400',
        images: ['https://picsum.photos/seed/p9/400/400'],
        categoryId: '5',
        categoryName: 'Strollers',
        brand: 'BabyBjörn',
        rating: 4.7,
        reviewCount: 567,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
      ProductModel(
        id: '10',
        name: 'Teether Silicone Set',
        shortDescription: 'BPA-free teethers',
        price: 349,
        mrp: 449,
        discountPercent: 22,
        thumbnail: 'https://picsum.photos/seed/p10/400/400',
        images: ['https://picsum.photos/seed/p10/400/400'],
        categoryId: '4',
        categoryName: 'Toys',
        brand: 'Munchkin',
        rating: 4.6,
        reviewCount: 2100,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
      ProductModel(
        id: '11',
        name: 'Baby Crib Mobile',
        shortDescription: 'Musical crib mobile',
        price: 999,
        mrp: 1299,
        discountPercent: 23,
        thumbnail: 'https://picsum.photos/seed/p11/400/400',
        images: ['https://picsum.photos/seed/p11/400/400'],
        categoryId: '7',
        categoryName: 'Nursery',
        brand: 'Fisher-Price',
        rating: 4.5,
        reviewCount: 890,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
      ProductModel(
        id: '12',
        name: 'Safety Gate',
        shortDescription: 'Pressure-mounted baby gate',
        price: 2499,
        mrp: 3199,
        discountPercent: 22,
        thumbnail: 'https://picsum.photos/seed/p12/400/400',
        images: ['https://picsum.photos/seed/p12/400/400'],
        categoryId: '8',
        categoryName: 'Safety',
        brand: 'Summer',
        rating: 4.4,
        reviewCount: 456,
        inStock: true,
        isFeatured: false,
        isPopular: true,
        isNewArrival: false,
      ),
    ]);
  }

  void _loadNewArrivals() {
    newArrivals.assignAll([
      ProductModel(
        id: '13',
        name: 'Organic Cotton Onesies',
        shortDescription: 'New eco-friendly range',
        price: 599,
        mrp: 799,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p13/400/400',
        images: ['https://picsum.photos/seed/p13/400/400'],
        categoryId: '2',
        categoryName: 'Clothing',
        brand: 'FirstCry',
        rating: 4.8,
        reviewCount: 234,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
      ProductModel(
        id: '14',
        name: 'Smart Baby Monitor',
        shortDescription: 'HD video & night vision',
        price: 3999,
        mrp: 4999,
        discountPercent: 20,
        thumbnail: 'https://picsum.photos/seed/p14/400/400',
        images: ['https://picsum.photos/seed/p14/400/400'],
        categoryId: '7',
        categoryName: 'Nursery',
        brand: 'Motorola',
        rating: 4.6,
        reviewCount: 189,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
      ProductModel(
        id: '15',
        name: 'Silicone Bib Set',
        shortDescription: 'Easy-clean feeding bibs',
        price: 449,
        mrp: 599,
        discountPercent: 25,
        thumbnail: 'https://picsum.photos/seed/p15/400/400',
        images: ['https://picsum.photos/seed/p15/400/400'],
        categoryId: '3',
        categoryName: 'Feeding',
        brand: 'Chicco',
        rating: 4.7,
        reviewCount: 312,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
      ProductModel(
        id: '16',
        name: 'Baby Sunscreen SPF 50',
        shortDescription: 'Water-resistant formula',
        price: 399,
        mrp: 499,
        discountPercent: 20,
        thumbnail: 'https://picsum.photos/seed/p16/400/400',
        images: ['https://picsum.photos/seed/p16/400/400'],
        categoryId: '6',
        categoryName: 'Skincare',
        brand: 'Johnson\'s',
        rating: 4.5,
        reviewCount: 567,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
      ProductModel(
        id: '17',
        name: 'Stacking Blocks',
        shortDescription: 'Educational wooden blocks',
        price: 399,
        mrp: 499,
        discountPercent: 20,
        thumbnail: 'https://picsum.photos/seed/p17/400/400',
        images: ['https://picsum.photos/seed/p17/400/400'],
        categoryId: '4',
        categoryName: 'Toys',
        brand: 'Fisher-Price',
        rating: 4.6,
        reviewCount: 145,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
      ProductModel(
        id: '18',
        name: 'Corner Protectors',
        shortDescription: 'Soft foam furniture guards',
        price: 399,
        mrp: 499,
        discountPercent: 20,
        thumbnail: 'https://picsum.photos/seed/p18/400/400',
        images: ['https://picsum.photos/seed/p18/400/400'],
        categoryId: '8',
        categoryName: 'Safety',
        brand: 'Summer',
        rating: 4.4,
        reviewCount: 278,
        inStock: true,
        isFeatured: false,
        isPopular: false,
        isNewArrival: true,
      ),
    ]);
  }

  void onSearchTap() {
    toNamed(RoutersConst.search);
  }

  void onCategoryTap(CategoryModel category) {
    toNamed('/category/${category.id}', arguments: category);
  }

  void onProductTap(ProductModel product) {
    toNamed('/product/${product.id}', arguments: product);
  }

  void onViewAllFeatured() {
    toNamed('${RoutersConst.productList}?type=featured');
  }

  void onViewAllPopular() {
    toNamed('${RoutersConst.productList}?type=popular');
  }

  void onViewAllNewArrivals() {
    toNamed('${RoutersConst.productList}?type=new_arrivals');
  }

  void onViewAllCategories() {
    toNamed(RoutersConst.categories);
  }
}
