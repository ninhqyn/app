
import 'models/models.dart';
import 'vn_api/vn_api_client.dart';

class VnRepository{
  final VnApiClient vnApiClient;

  VnRepository(this.vnApiClient);

  Future<List<Province>> getAllProvince() async{
    List<Province> result = [];
    result = await vnApiClient.getAllProvince();
    return result;
  }
  Future<List<District>> getAllDistrictByCode(int code) async{
    //List<District> result = [];
    final result = await vnApiClient.getDistrictByCode(code);
    return result;
  }
  Future<List<Ward>> getAllWardByCode(int code) async{
    //List<District> result = [];
    final result = await vnApiClient.getWardByCode(code);
    return result;
  }
}