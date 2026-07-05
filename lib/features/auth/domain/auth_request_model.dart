import 'package:portfolio/model/api_body.dart';

class LoginRequest implements ApiBody {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RegisterRequest implements ApiBody {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? userId;

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.userId,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
        if (userId != null && userId!.isNotEmpty) 'user_id': userId,
      };
}

class ProfileUpdateRequest implements ApiBody {
  final String? name;
  final String? phone;
  final String? photoUrl;
  final String? gender;
  final String? dateOfBirth;

  const ProfileUpdateRequest({
    this.name,
    this.phone,
    this.photoUrl,
    this.gender,
    this.dateOfBirth,
  });

  @override
  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (photoUrl != null) 'photo_url': photoUrl,
        if (gender != null) 'gender': gender,
        if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      };
}
