import 'package:portfolio/features/home/domain/banner_model.dart';
import 'package:portfolio/features/home/domain/category_model.dart';
import 'package:portfolio/features/notifications/domain/notification_broadcast_model.dart';
import 'package:portfolio/features/product/domain/product_model.dart';
import 'package:portfolio/model/api_body.dart';

class ProductAdminRequest implements ApiBody {
  final String name;
  final String description;
  final String shortDescription;
  final double price;
  final double mrp;
  final String? categoryId;
  final int stockQty;
  final String thumbnail;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final List<String> tags;
  final bool isFeatured;
  final bool isPopular;
  final bool isNewArrival;

  const ProductAdminRequest({
    required this.name,
    this.description = '',
    this.shortDescription = '',
    required this.price,
    this.mrp = 0,
    this.categoryId,
    this.stockQty = 0,
    this.thumbnail = '',
    this.images = const [],
    this.sizes = const [],
    this.colors = const [],
    this.tags = const [],
    this.isFeatured = false,
    this.isPopular = false,
    this.isNewArrival = false,
  });

  factory ProductAdminRequest.fromProduct(ProductModel product) => ProductAdminRequest(
        name: product.name,
        description: product.description,
        shortDescription: product.shortDescription,
        price: product.price,
        mrp: product.mrp,
        categoryId: product.categoryId.isNotEmpty ? product.categoryId : null,
        stockQty: product.stockQty,
        thumbnail: product.thumbnail,
        images: product.images,
        sizes: product.sizes,
        colors: product.colors,
        tags: product.tags,
        isFeatured: product.isFeatured,
        isPopular: product.isPopular,
        isNewArrival: product.isNewArrival,
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'short_description': shortDescription,
        'price': price,
        'mrp': mrp,
        if (categoryId != null && categoryId!.isNotEmpty) 'category_id': categoryId,
        'stock_qty': stockQty,
        'thumbnail': thumbnail,
        'images': images,
        'sizes': sizes,
        'colors': colors,
        'tags': tags,
        'is_featured': isFeatured,
        'is_popular': isPopular,
        'is_new_arrival': isNewArrival,
      };
}

class CategoryAdminRequest implements ApiBody {
  final String name;
  final String image;
  final String icon;
  final int sortOrder;
  final bool isActive;

  const CategoryAdminRequest({
    required this.name,
    this.image = '',
    this.icon = '',
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory CategoryAdminRequest.fromCategory(CategoryModel category) =>
      CategoryAdminRequest(
        name: category.name,
        image: category.image,
        icon: category.icon,
        sortOrder: category.sortOrder,
        isActive: category.isActive,
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'icon': icon,
        'sort_order': sortOrder,
        'is_active': isActive,
      };
}

class BannerAdminRequest implements ApiBody {
  final String title;
  final String subtitle;
  final String image;
  final String actionType;
  final String actionValue;
  final int sortOrder;
  final bool isActive;

  const BannerAdminRequest({
    this.title = '',
    this.subtitle = '',
    required this.image,
    this.actionType = 'none',
    this.actionValue = '',
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory BannerAdminRequest.fromBanner(BannerModel banner) => BannerAdminRequest(
        title: banner.title,
        subtitle: banner.subtitle,
        image: banner.image,
        actionType: banner.actionType,
        actionValue: banner.actionValue,
        sortOrder: banner.sortOrder,
        isActive: banner.isActive,
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'action_type': actionType,
        'action_value': actionValue,
        'sort_order': sortOrder,
        'is_active': isActive,
      };
}

class UserFlagsRequest implements ApiBody {
  final bool isAdmin;
  final bool isBlocked;
  final String? blockReason;

  const UserFlagsRequest({
    required this.isAdmin,
    required this.isBlocked,
    this.blockReason,
  });

  @override
  Map<String, dynamic> toJson() => {
        'is_admin': isAdmin,
        'is_blocked': isBlocked,
        if (blockReason != null) 'block_reason': blockReason,
      };
}

class BroadcastRequest implements ApiBody {
  final String title;
  final String body;

  const BroadcastRequest({required this.title, required this.body});

  factory BroadcastRequest.fromModel(NotificationBroadcastModel model) =>
      BroadcastRequest(title: model.title, body: model.body);

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };
}
