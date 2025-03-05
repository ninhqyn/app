import 'package:color_repository/src/color_api/color_api_client.dart';
import 'package:color_repository/src/models/models.dart';

class ColorRepository{

  final ColorApiClient colorApiClient;

  ColorRepository({required this.colorApiClient});

  Future<List<ColorProduct>> getAllColorByProductId(int productId) async{
    try{
      var results = await colorApiClient.getAllColorByProductId(productId);
      return results;
    }catch(e){
      throw Exception(e);
    }
  }
  Future<List<ColorProduct>> getAllColor() async{
    try{
      var results = await colorApiClient.getAllColor();
      return results;
    }catch(e){
      throw Exception(e);
    }
  }
}