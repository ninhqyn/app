import 'dart:convert';

import 'package:address_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
class AddressApiClient{
  static const baseUrl = 'localhost:7205';
  final http.Client httpClient;

  AddressApiClient({http.Client ? httpClient}) : httpClient = httpClient ?? http.Client() ;

  Future<String> addAddress(Address address,String accessToken) async{
    final request = Uri.https(
      baseUrl,
      '/api/Address/AddAddress'
    );
    address.addressId = 0;
    //body json
    final Map<String,dynamic> addressJson = address.toJson();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await httpClient.post(
      request,
      headers: headers,
      body: json.encode(addressJson)
    );
    if (response.statusCode == 200) {
      return response.statusCode.toString();
    } else {
      throw Exception('Failed to add address: ${response.statusCode}');
    }
  }
  Future<String> updateAddress(Address address,String accessToken) async{
    final request = Uri.https(
        baseUrl,
        '/api/Address/UpdateAddress'
    );
    final Map<String,dynamic> addressJson = address.toJson();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await httpClient.put(
        request,
        headers: headers,
        body: json.encode(addressJson)
    );
    if (response.statusCode == 200) {
      return response.statusCode.toString();
    } else {
      throw Exception('Failed to update address: ${response.statusCode}');
    }
  }
  Future<String> deleteAddress(int addressId,String accessToken) async{
    final request = Uri.https(
        baseUrl,
        '/api/Address/RemoveAddress/$addressId'
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await httpClient.delete(
        request,
        headers: headers,
    );
    if (response.statusCode == 200) {
      return response.statusCode.toString();
    } else {
      throw Exception('Failed to delete address: ${response.statusCode}');
    }
  }
  Future<List<Address>> getAddAddress(String accessToken) async{
    final request = Uri.https(
        baseUrl,
        '/api/Address/GetAddresses'
    );
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    final response = await httpClient.get(
        request,
        headers: headers,
    );
    if (response.statusCode == 200) {

      List<dynamic> addressJson = jsonDecode(response.body);
      final address = addressJson.map((json){
        return Address.fromJson(json);
      }).toList();
      return address;
    } else {
      throw Exception('Failed to add address: ${response.statusCode}');
    }

  }

  void dispose(){
    httpClient.close();
  }
}