import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:size_repository/size_repository.dart';
class SizeApiClient{
  static const _baseUrl = 'localhost:7205';
  final http.Client _httpClient;
  SizeApiClient({http.Client ? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<SizeProduct>> getAllSizeByProductId(int productId)async{
    final request = Uri.https(
      _baseUrl,
      '/api/Product/Sizes/$productId'
    );

    final response =await _httpClient.get(request);
    if(response.statusCode!=200){
      throw Exception('Error to fetch api colors');
    }
    print(request);
    final List<dynamic> sizesJson = jsonDecode(response.body);

    final results = sizesJson.map((json){
      return SizeProduct.fromJson(json);
    }).toList();

    return results;

  }

  Future<List<SizeProduct>> getAllSize()async{
    final request = Uri.https(
        _baseUrl,
        '/api/Size'
    );

    final response =await _httpClient.get(request);
    if(response.statusCode!=200){
      throw Exception('Error to fetch api colors');
    }
    print(request);
    final List<dynamic> sizesJson = jsonDecode(response.body);

    final results = sizesJson.map((json){
      return SizeProduct.fromJson(json);
    }).toList();

    return results;

  }
}