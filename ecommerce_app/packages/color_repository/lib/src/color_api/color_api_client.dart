import 'dart:convert';
import 'dart:io';

import 'package:color_repository/src/models/models.dart';
import 'package:http/http.dart' as http;
class ColorApiClient{
  static const _baseUrl = 'localhost:7205';
  final http.Client _httpClient;
  ColorApiClient({http.Client ? httpClient}) : _httpClient = httpClient ?? http.Client();

  Future<List<ColorProduct>> getAllColorByProductId(int productId)async{
    final request = Uri.https(
      _baseUrl,
      '/api/Product/Colors/$productId'
    );

    final response =await _httpClient.get(request);
    if(response.statusCode!=200){
      throw Exception('Error to fetch api colors');
    }
    print(request);
    final List<dynamic> colorsJson = jsonDecode(response.body);

    final results = colorsJson.map((json){
      return ColorProduct.fromJson(json);
    }).toList();

    return results;

  }
  Future<List<ColorProduct>> getAllColor()async{
    final request = Uri.https(
        _baseUrl,
        '/api/Color'
    );
    final response =await _httpClient.get(request);
    if(response.statusCode!=200){
      throw Exception('Error to fetch api colors');
    }
    print(request);
    final List<dynamic> colorsJson = jsonDecode(response.body);

    final results = colorsJson.map((json){
      return ColorProduct.fromJson(json);
    }).toList();

    return results;

  }
}