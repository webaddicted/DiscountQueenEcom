/// Normalizes API JSON keys (camelCase from backend → snake_case for models).
class JsonUtils {
  JsonUtils._();

  static dynamic normalize(dynamic data) {
    if (data is Map) return camelToSnakeMap(Map<String, dynamic>.from(data));
    if (data is List) return data.map(normalize).toList();
    return data;
  }

  static Map<String, dynamic> camelToSnakeMap(Map<String, dynamic> json) {
    final result = <String, dynamic>{};
    json.forEach((key, value) {
      result[_camelToSnake(key)] = normalize(value);
    });
    return result;
  }

  static String _camelToSnake(String input) {
    if (!input.contains(RegExp(r'[A-Z]'))) return input;
    final buffer = StringBuffer();
    for (var i = 0; i < input.length; i++) {
      final char = input[i];
      if (char == char.toUpperCase() && char != char.toLowerCase() && i > 0) {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    }
    return buffer.toString();
  }
}
