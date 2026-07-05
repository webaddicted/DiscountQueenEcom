class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;
  final String gender;
  final String dateOfBirth;
  final String createdAt;
  final bool isAdmin;
  final bool isBlocked;
  final String? blockReason;

  UserModel({
    required this.id,
    this.name = '',
    this.email = '',
    this.phone = '',
    this.photoUrl = '',
    this.gender = '',
    this.dateOfBirth = '',
    this.createdAt = '',
    this.isAdmin = false,
    this.isBlocked = false,
    this.blockReason,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        photoUrl: json['photo_url'] ?? json['avatar'] ?? '',
        gender: json['gender'] ?? '',
        dateOfBirth: json['date_of_birth'] ?? '',
        createdAt: json['created_at'] ?? '',
        isAdmin: json['is_admin'] == true,
        isBlocked: json['is_blocked'] == true,
        blockReason: json['block_reason'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'photo_url': photoUrl,
        'gender': gender,
        'date_of_birth': dateOfBirth,
        'created_at': createdAt,
        'is_admin': isAdmin,
        'is_blocked': isBlocked,
        'block_reason': blockReason,
      };

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? gender,
    String? dateOfBirth,
    bool? isAdmin,
    bool? isBlocked,
    String? blockReason,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        photoUrl: photoUrl ?? this.photoUrl,
        gender: gender ?? this.gender,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        createdAt: createdAt,
        isAdmin: isAdmin ?? this.isAdmin,
        isBlocked: isBlocked ?? this.isBlocked,
        blockReason: blockReason ?? this.blockReason,
      );
}
