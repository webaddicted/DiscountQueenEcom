import 'package:portfolio/features/address/domain/address_model.dart';
import 'package:portfolio/model/api_body.dart';

class AddressRequest implements ApiBody {
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

  const AddressRequest({
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

  factory AddressRequest.fromModel(AddressModel model) => AddressRequest(
        name: model.name,
        phone: model.phone,
        addressLine1: model.addressLine1,
        addressLine2: model.addressLine2,
        city: model.city,
        state: model.state,
        pincode: model.pincode,
        landmark: model.landmark,
        type: model.type,
        isDefault: model.isDefault,
      );

  @override
  Map<String, dynamic> toJson() => {
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
}
