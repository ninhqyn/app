import 'dart:async';
import 'dart:convert';
import 'package:category_repository/src/models/category.dart';
import 'package:http/http.dart' as http;
class CategoryApiClient{
  final http.Client _httpClient;

  CategoryApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'localhost:7205';

  Future<List<Category>> getAllCategoryParent() async{

    final request = Uri.https(
      _baseUrl,
      '/api/Category/parent'
    );
    final response = await _httpClient.get(request);
    if(response.statusCode != 200){
      throw Exception('Failed to load products');
    }
    print('call success');
    print(request);
    final List<dynamic> categoryJson = jsonDecode(response.body);

    final results = categoryJson.map((json){
      return Category.fromJson(json);
    }).toList();

    return results;

  }
  Future<List<Category>> getAllCategoryByParentId(int parentId) async{

    final request = Uri.https(
        _baseUrl,
        '/api/Category/byParent/$parentId'
    );
    final response = await _httpClient.get(request);
    print(request);
    if(response.statusCode != 200){
      throw Exception('Failed to load category');
    }
    print('code = 200');
    final List<dynamic> categoryJson = jsonDecode(response.body);
    final results = categoryJson.map((json){
      return Category.fromJson(json);
    }).toList();
    return results;
  }

}