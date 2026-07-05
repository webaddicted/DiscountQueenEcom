class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String actionType;
  final String actionValue;
  final int sortOrder;
  final bool isActive;

  BannerModel({
    required this.id,
    this.title = '',
    this.subtitle = '',
    this.image = '',
    this.actionType = '',
    this.actionValue = '',
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        subtitle: json['subtitle'] ?? '',
        image: json['image'] ?? '',
        actionType: json['action_type'] ?? '',
        actionValue: json['action_value'] ?? '',
        sortOrder: json['sort_order'] ?? 0,
        isActive: json['is_active'] ?? true,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'image': image,
        'action_type': actionType,
        'action_value': actionValue,
        'sort_order': sortOrder,
        'is_active': isActive,
      };
}
