
import 'package:address_repository/src/address_api/address_api_client.dart';
import 'package:address_repository/src/models/models.dart';

class AddressRepository {
  final AddressApiClient addressApiClient;

  AddressRepository({required this.addressApiClient});

  // Method to add address
  Future<String> addAddress(Address address, String accessToken) async {
    try {
      // Call the API client method to add address
      return await addressApiClient.addAddress(address, accessToken);
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  // Method to update address
  Future<String> updateAddress(Address address, String accessToken) async {
    try {
      // Call the API client method to update address
      return await addressApiClient.updateAddress(address, accessToken);
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  // Method to delete address
  Future<String> deleteAddress(int addressId, String accessToken) async {
    try {
      // Call the API client method to delete address
      return await addressApiClient.deleteAddress(addressId, accessToken);
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  // Method to get addresses
  Future<List<Address>> getAddresses(String accessToken) async {
    try {
      // Call the API client method to get addresses
      return await addressApiClient.getAddAddress(accessToken);
    } catch (e) {
      throw Exception('Failed to fetch addresses: $e');
    }
  }
  void dispose(){
    addressApiClient.dispose();
  }
}
