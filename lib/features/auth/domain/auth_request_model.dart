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

  const RegisterRequest({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
      };
}

class CheckAvailabilityRequest implements ApiBody {
  final String email;
  final String? phone;

  const CheckAvailabilityRequest({required this.email, this.phone});

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        if (phone != null && phone!.isNotEmpty) 'phone': phone,
      };
}

class VerifyOtpRequest implements ApiBody {
  final String email;
  final String otp;

  const VerifyOtpRequest({required this.email, required this.otp});

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
      };
}

class ResendOtpRequest implements ApiBody {
  final String email;

  const ResendOtpRequest({required this.email});

  @override
  Map<String, dynamic> toJson() => {'email': email};
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
