class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String icon;
  final int productCount;
  final int sortOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.image = '',
    this.icon = '',
    this.productCount = 0,
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        image: json['image'] ?? '',
        icon: json['icon'] ?? '',
        productCount: json['product_count'] ?? 0,
        sortOrder: json['sort_order'] ?? 0,
        isActive: json['is_active'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'icon': icon,
        'product_count': productCount,
        'sort_order': sortOrder,
        'is_active': isActive,
      };

  CategoryModel copyWith({
    String? id,
    String? name,
    String? image,
    String? icon,
    int? productCount,
    int? sortOrder,
    bool? isActive,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        icon: icon ?? this.icon,
        productCount: productCount ?? this.productCount,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
}
