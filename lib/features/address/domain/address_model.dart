class AddressModel {
  final String id;
  final String name;
  final String phone;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String landmark;
  final String type;
  final bool isDefault;

  AddressModel({
    required this.id,
    this.name = '',
    this.phone = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.landmark = '',
    this.type = 'home',
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        addressLine1: json['address_line_1'] ?? '',
        addressLine2: json['address_line_2'] ?? '',
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        pincode: json['pincode'] ?? '',
        landmark: json['landmark'] ?? '',
        type: json['type'] ?? 'home',
        isDefault: json['is_default'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2,
        'city': city,
        'state': state,
        'pincode': pincode,
        'landmark': landmark,
        'type': type,
        'is_default': isDefault,
      };

  String get fullAddress {
    final parts = <String>[];
    if (addressLine1.isNotEmpty) parts.add(addressLine1);
    if (addressLine2.isNotEmpty) parts.add(addressLine2);
    if (landmark.isNotEmpty) parts.add(landmark);
    if (city.isNotEmpty) parts.add(city);
    if (state.isNotEmpty) parts.add(state);
    if (pincode.isNotEmpty) parts.add(pincode);
    return parts.join(', ');
  }

  AddressModel copyWith({
    String? name,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    String? type,
    bool? isDefault,
  }) =>
      AddressModel(
        id: id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        addressLine1: addressLine1 ?? this.addressLine1,
        addressLine2: addressLine2 ?? this.addressLine2,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        landmark: landmark ?? this.landmark,
        type: type ?? this.type,
        isDefault: isDefault ?? this.isDefault,
      );
}
