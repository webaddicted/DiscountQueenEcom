/// Marker for typed API request bodies (POST/PUT payloads).
abstract class ApiBody {
  Map<String, dynamic> toJson();
}
