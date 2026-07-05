class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String productId;
  final double rating;
  final String comment;
  final List<String> images;
  final String createdAt;

  ReviewModel({
    required this.id,
    this.userId = '',
    this.userName = '',
    this.userAvatar = '',
    this.productId = '',
    this.rating = 0,
    this.comment = '',
    this.images = const [],
    this.createdAt = '',
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        userName: json['user_name'] ?? '',
        userAvatar: json['user_avatar'] ?? '',
        productId: json['product_id']?.toString() ?? '',
        rating: (json['rating'] ?? 0).toDouble(),
        comment: json['comment'] ?? '',
        images: List<String>.from(json['images'] ?? []),
        createdAt: json['created_at'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'user_name': userName,
        'user_avatar': userAvatar,
        'product_id': productId,
        'rating': rating,
        'comment': comment,
        'images': images,
        'created_at': createdAt,
      };
}
