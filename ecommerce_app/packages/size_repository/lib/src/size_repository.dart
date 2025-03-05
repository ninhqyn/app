

import 'package:size_repository/src/models/models.dart';
import 'package:size_repository/src/size_api/size_api_client.dart';

class SizeRepository{

  final SizeApiClient sizeApiClient;

  SizeRepository({required this.sizeApiClient});

  Future<List<SizeProduct>> getAllSizeByProductId(int productId) async{
    try{
      var results = await sizeApiClient.getAllSizeByProductId(productId);
      return results;
    }catch(e){
      throw Exception(e);
    }
  }
  Future<List<SizeProduct>> getAllSize() async{
    try{
      var results = await sizeApiClient.getAllSize();
      return results;
    }catch(e){
      throw Exception(e);
    }
  }

}