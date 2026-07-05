import 'package:portfolio/model/api_body.dart';

class ReviewRequest implements ApiBody {
  final String productId;
  final double rating;
  final String comment;
  final List<String> images;

  const ReviewRequest({
    required this.productId,
    required this.rating,
    this.comment = '',
    this.images = const [],
  });

  @override
  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'rating': rating,
        'comment': comment,
        'images': images,
      };
}
