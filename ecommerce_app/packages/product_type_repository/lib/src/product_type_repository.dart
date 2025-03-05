


import 'package:product_type_repository/src/models/models.dart';
import 'package:product_type_repository/src/product_type_api/product_type_api_client.dart';

class ProductTypeRepository{
  final ProductTypeApiClient apiClient;

  ProductTypeRepository({required this.apiClient});

  Future<List<ProductType>> getAllProductTypeByParent(int categoryId) async{
    try{
      final productTypes = await apiClient.getAllProductTypeByCategoryId(categoryId);
      return productTypes;
    }catch(e){
      throw Exception('fail to fetch category');
    }

  }
  Future<List<ProductType>> getAllProductType() async{
    try{
      final productTypes = await apiClient.getAllProductType();
      return productTypes;
    }catch(e){
      //throw Exception('fail to fetch category');
      print('error');
      List<ProductType> list = [];
      return list;
    }

  }
}