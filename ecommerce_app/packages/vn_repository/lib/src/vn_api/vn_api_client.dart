import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vn_repository/src/models/district.dart';
import 'package:vn_repository/src/models/models.dart';

import '../models/province.dart';
class VnApiClient {

  static const baseUrl = 'provinces.open-api.vn';
  final http.Client httpClient;
  VnApiClient({http.Client? httpClient}): httpClient = httpClient ?? http.Client();

  Future<List<Province>> getAllProvince() async {
    final request = Uri.https(
        baseUrl,
        '/api/p'
    );
    final response = await httpClient.get(request);

    if(response.statusCode != 200){
      throw Exception('Error to fetch Province');
    }

    // Sử dụng utf8.decode với response.bodyBytes thay vì response.body trực tiếp
    String decodedBody = utf8.decode(response.bodyBytes);
    List<dynamic> provinceJson = jsonDecode(decodedBody);

    final provinces = provinceJson.map((json){
      return Province.fromJson(json);
    }).toList();
    return provinces;
  }
  Future<List<District>> getDistrictByCode(int code) async {
    final queryParameters = {'depth': '2'};
    final request = Uri.https(
      baseUrl,
      '/api/p/$code',
      queryParameters,
    );
    final response = await httpClient.get(request);
    if (response.statusCode != 200) {
      throw Exception('Lỗi khi lấy quận theo mã tỉnh');
    }
    String decodedBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseJson = jsonDecode(decodedBody);
    if (responseJson.containsKey('districts') && responseJson['districts'] is List) {
      // Chuyển đổi danh sách JSON thành danh sách đối tượng District
      final districts = (responseJson['districts'] as List).map((json) {
        return District.fromJson(json);
      }).toList();

      return districts;
    } else {
      throw Exception('Không tìm thấy thông tin quận trong phản hồi');
    }
  }
  Future<List<Ward>> getWardByCode(int code) async {
    final queryParameters = {'depth': '2'};
    final request = Uri.https(
      baseUrl,
      '/api/d/$code',
      queryParameters,
    );
    print(request);
    final response = await httpClient.get(request);
    if (response.statusCode != 200) {
      throw Exception('Lỗi khi lấy quận theo mã tỉnh');
    }
    String decodedBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> responseJson = jsonDecode(decodedBody);
    if (responseJson.containsKey('wards') && responseJson['wards'] is List) {
      final wards = (responseJson['wards'] as List).map((json) {
        return Ward.fromJson(json);
      }).toList();

      return wards;
    } else {
      throw Exception('Không tìm thấy thông tin quận trong phản hồi');
    }
  }




}