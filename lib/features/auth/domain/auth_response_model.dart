import 'package:portfolio/features/auth/domain/user_model.dart';
import 'package:portfolio/model/api_envelope.dart';

class AvailabilityModel {
  final bool emailAvailable;
  final bool phoneAvailable;

  const AvailabilityModel({
    required this.emailAvailable,
    required this.phoneAvailable,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) => AvailabilityModel(
        emailAvailable: json['email_available'] != false,
        phoneAvailable: json['phone_available'] != false,
      );
}

class RegisterPendingModel {
  final String email;
  final String message;

  const RegisterPendingModel({
    required this.email,
    this.message = '',
  });

  factory RegisterPendingModel.fromJson(Map<String, dynamic> json) => RegisterPendingModel(
        email: json['email']?.toString() ?? '',
        message: json['message']?.toString() ?? '',
      );
}

class AvailabilityResponse extends ApiEnvelope<AvailabilityModel> {
  const AvailabilityResponse({
    super.message,
    super.success,
    super.data,
  });

  factory AvailabilityResponse.parse(dynamic raw) {
    final envelope = ApiEnvelope.parse<AvailabilityModel>(
      raw,
      (d) => AvailabilityModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );
    return AvailabilityResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }
}

class RegisterResponse extends ApiEnvelope<RegisterPendingModel> {
  const RegisterResponse({
    super.message,
    super.success,
    super.data,
  });

  factory RegisterResponse.parse(dynamic raw) {
    final envelope = ApiEnvelope.parse<RegisterPendingModel>(
      raw,
      (d) => RegisterPendingModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );
    return RegisterResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }
}

class LoginResponse extends ApiEnvelope<UserModel> {
  const LoginResponse({
    super.message,
    super.success,
    super.data,
  });

  bool get needsVerification =>
      isFailure && message.toLowerCase().contains('verify');

  factory LoginResponse.parse(dynamic raw) {
    final envelope = ApiEnvelope.parse<UserModel>(
      raw,
      (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
    );
    return LoginResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }
}

class MessageResponse extends ApiEnvelope<dynamic> {
  const MessageResponse({
    super.message,
    super.success,
    super.data,
  });

  factory MessageResponse.parse(dynamic raw) {
    final envelope = ApiEnvelope.parse<dynamic>(raw, null);
    return MessageResponse(
      message: envelope.message,
      success: envelope.success,
      data: envelope.data,
    );
  }
}

enum LoginStatus { success, notVerified, failed }

class LoginResult {
  final LoginStatus status;
  final UserModel? user;
  final String message;

  const LoginResult({
    required this.status,
    this.user,
    this.message = '',
  });

  factory LoginResult.fromResponse(LoginResponse response) {
    if (response.isSuccess && response.data != null) {
      return LoginResult(
        status: LoginStatus.success,
        user: response.data,
        message: response.message,
      );
    }
    if (response.needsVerification) {
      return LoginResult(
        status: LoginStatus.notVerified,
        message: response.message,
      );
    }
    return LoginResult(
      status: LoginStatus.failed,
      message: response.message,
    );
  }
}
