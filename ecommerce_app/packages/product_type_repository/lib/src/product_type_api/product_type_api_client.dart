import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_type_repository/src/models/models.dart';
class ProductTypeApiClient{
  final http.Client _httpClient;

  ProductTypeApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'localhost:7205';

  Future<List<ProductType>> getAllProductTypeByCategoryId(int categoryId) async{
    final request = Uri.https(
        _baseUrl,
        '/api/ProductType/GetAll/$categoryId'
    );
    final response = await _httpClient.get(request);
    if(response.statusCode != 200){
      throw Exception('Failed to load product type');
    }
    print(request);
    final List<dynamic> categoryJson = jsonDecode(response.body);

    final results = categoryJson.map((json){
      return ProductType.fromJson(json);
    }).toList();

    return results;

  }
  Future<List<ProductType>> getAllProductType() async{
    final request = Uri.https(
        _baseUrl,
        '/api/ProductType/GetAll'
    );
    final response = await _httpClient.get(request);
    if(response.statusCode != 200){
      throw Exception('Failed to load product type');
    }
    print(request);
    final List<dynamic> categoryJson = jsonDecode(response.body);

    final results = categoryJson.map((json){
      return ProductType.fromJson(json);
    }).toList();

    return results;

  }


}