import 'package:portfolio/global/constant/string_const.dart';

class ValidationUtils {
  ValidationUtils._();

  static String? required(String? value, {String? message}) =>
      (value == null || value.trim().isEmpty) ? (message ?? StringConst.fieldRequired) : null;

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
      return StringConst.invalidEmail;
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8, bool requireStrong = false}) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (value.length < minLength) return 'Password must be at least $minLength characters';
    if (requireStrong) {
      if (!RegExp(r'[A-Z]').hasMatch(value)) return 'Must contain uppercase letter';
      if (!RegExp(r'[a-z]').hasMatch(value)) return 'Must contain lowercase letter';
      if (!RegExp(r'[0-9]').hasMatch(value)) return 'Must contain a digit';
      if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) return 'Must contain special character';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (!RegExp(r'^\+?[\d\s\-]{10,}$').hasMatch(value)) {
      return StringConst.invalidPhone;
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    final error = required(value);
    if (error != null) return error;
    if (value != original) return StringConst.passwordMismatch;
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (value.trim().length < 2) return 'Name must be at least 2 characters';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Name can only contain letters';
    return null;
  }

  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    if (!RegExp(r'^https?://[\w\-]+(\.[\w\-]+)+[/#?]?.*$').hasMatch(value)) {
      return 'Please enter a valid URL';
    }
    return null;
  }

  static String? otp(String? value, {int length = 6}) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (!RegExp('^[0-9]{$length}\$').hasMatch(value)) return 'OTP must be $length digits';
    return null;
  }

  static String? minLength(String? value, int min) {
    if (value == null || value.trim().isEmpty) return StringConst.fieldRequired;
    if (value.length < min) return 'Minimum $min characters required';
    return null;
  }

  static String? maxLength(String? value, int max) {
    if (value != null && value.length > max) return 'Maximum $max characters allowed';
    return null;
  }
}
