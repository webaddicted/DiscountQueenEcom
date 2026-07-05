class ProductModel {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final double mrp;
  final int discountPercent;
  final List<String> images;
  final String thumbnail;
  final String categoryId;
  final String categoryName;
  final String brand;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final int stockQty;
  final List<String> sizes;
  final List<String> colors;
  final List<String> tags;
  final Map<String, String> specifications;
  final bool isFeatured;
  final bool isPopular;
  final bool isNewArrival;
  final String createdAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description = '',
    this.shortDescription = '',
    required this.price,
    this.mrp = 0,
    this.discountPercent = 0,
    this.images = const [],
    this.thumbnail = '',
    this.categoryId = '',
    this.categoryName = '',
    this.brand = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.inStock = true,
    this.stockQty = 0,
    this.sizes = const [],
    this.colors = const [],
    this.tags = const [],
    this.specifications = const {},
    this.isFeatured = false,
    this.isPopular = false,
    this.isNewArrival = false,
    this.createdAt = '',
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        shortDescription: json['short_description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        mrp: (json['mrp'] ?? 0).toDouble(),
        discountPercent: json['discount_percent'] ?? 0,
        images: List<String>.from(json['images'] ?? []),
        thumbnail: json['thumbnail'] ?? '',
        categoryId: json['category_id']?.toString() ?? '',
        categoryName: json['category_name'] ?? '',
        brand: json['brand'] ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['review_count'] ?? 0,
        inStock: json['in_stock'] ?? true,
        stockQty: json['stock_qty'] ?? 0,
        sizes: List<String>.from(json['sizes'] ?? []),
        colors: List<String>.from(json['colors'] ?? []),
        tags: List<String>.from(json['tags'] ?? []),
        specifications:
            Map<String, String>.from(json['specifications'] ?? {}),
        isFeatured: json['is_featured'] ?? false,
        isPopular: json['is_popular'] ?? false,
        isNewArrival: json['is_new_arrival'] ?? false,
        createdAt: json['created_at'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'short_description': shortDescription,
        'price': price,
        'mrp': mrp,
        'discount_percent': discountPercent,
        'images': images,
        'thumbnail': thumbnail,
        'category_id': categoryId,
        'category_name': categoryName,
        'brand': brand,
        'rating': rating,
        'review_count': reviewCount,
        'in_stock': inStock,
        'stock_qty': stockQty,
        'sizes': sizes,
        'colors': colors,
        'tags': tags,
        'specifications': specifications,
        'is_featured': isFeatured,
        'is_popular': isPopular,
        'is_new_arrival': isNewArrival,
        'created_at': createdAt,
      };

  String get displayImage => thumbnail.isNotEmpty
      ? thumbnail
      : images.isNotEmpty
          ? images.first
          : '';

  bool get hasDiscount => discountPercent > 0 || mrp > price;

  int get calculatedDiscount =>
      discountPercent > 0 ? discountPercent : (mrp > 0 ? ((mrp - price) / mrp * 100).round() : 0);

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? mrp,
    int? discountPercent,
    List<String>? images,
    String? thumbnail,
    String? categoryId,
    String? categoryName,
    String? brand,
    double? rating,
    int? reviewCount,
    bool? inStock,
    int? stockQty,
    bool? isFeatured,
    bool? isPopular,
    bool? isNewArrival,
  }) =>
      ProductModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        shortDescription: shortDescription,
        price: price ?? this.price,
        mrp: mrp ?? this.mrp,
        discountPercent: discountPercent ?? this.discountPercent,
        images: images ?? this.images,
        thumbnail: thumbnail ?? this.thumbnail,
        categoryId: categoryId ?? this.categoryId,
        categoryName: categoryName ?? this.categoryName,
        brand: brand ?? this.brand,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
        inStock: inStock ?? this.inStock,
        stockQty: stockQty ?? this.stockQty,
        sizes: sizes,
        colors: colors,
        tags: tags,
        specifications: specifications,
        isFeatured: isFeatured ?? this.isFeatured,
        isPopular: isPopular ?? this.isPopular,
        isNewArrival: isNewArrival ?? this.isNewArrival,
        createdAt: createdAt,
      );
}
