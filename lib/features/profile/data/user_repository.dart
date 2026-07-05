import 'package:portfolio/global/apiutils/api_result_ext.dart';
import 'package:portfolio/global/base/base_repository.dart';
import 'package:portfolio/global/constant/api_const.dart';
import 'package:portfolio/features/address/domain/address_model.dart';
import 'package:portfolio/features/address/domain/address_request_model.dart';
import 'package:portfolio/features/auth/domain/auth_request_model.dart';
import 'package:portfolio/features/auth/domain/user_model.dart';

class UserRepository extends BaseRepository {
  Future<UserModel> getProfile() => get<UserModel>(
        url: ApiConstant.userProfile,
        parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
      ).unwrap();

  Future<UserModel> updateProfile({
    String? name,
    String? phone,
    String? photoUrl,
    String? gender,
    String? dateOfBirth,
  }) =>
      post<UserModel>(
        url: ApiConstant.updateProfile,
        parser: (d) => UserModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: ProfileUpdateRequest(
          name: name,
          phone: phone,
          photoUrl: photoUrl,
          gender: gender,
          dateOfBirth: dateOfBirth,
        ),
      ).unwrap();

  Future<List<AddressModel>> getAddresses() => getList<AddressModel>(
        url: ApiConstant.addresses,
        itemParser: (e) => AddressModel.fromJson(Map<String, dynamic>.from(e as Map)),
      ).unwrap();

  Future<AddressModel> addAddress(AddressModel address) => post<AddressModel>(
        url: ApiConstant.addAddress,
        parser: (d) => AddressModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: AddressRequest.fromModel(address),
      ).unwrap();

  Future<AddressModel> updateAddress(AddressModel address) => post<AddressModel>(
        url: ApiConstant.updateAddress,
        params: {'address_id': address.id},
        parser: (d) => AddressModel.fromJson(Map<String, dynamic>.from(d as Map)),
        data: AddressRequest.fromModel(address),
      ).unwrap();

  Future<void> deleteAddress(String addressId) async {
    await postAction(
      url: ApiConstant.deleteAddress,
      params: {'address_id': addressId},
    ).unwrap();
  }
}
