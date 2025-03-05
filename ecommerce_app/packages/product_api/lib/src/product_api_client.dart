import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../product_api.dart';  // Giả sử bạn có lớp Product tại đây

class ProductApiClient {
  final http.Client _httpClient;

  ProductApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const _baseUrlProduct = 'localhost:7205';

  Future<List<Product>> getAllProduct() async {
    try {
      final productRequest = Uri.https(
        _baseUrlProduct,
        '/api/Product',
      );
      final productResponse = await _httpClient.get(
        productRequest,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timed out');
          throw TimeoutException('The connection has timed out');
        },
      );
      if (productResponse.statusCode != 200) {
        throw Exception('Failed to load products');
      }
      final List<dynamic> productJson = jsonDecode(productResponse.body);
      final products = productJson.map((json) {
        return Product.fromJson(json);
      }).toList();
      return products; // Đảm bảo luôn có return ở đây

    } catch (e) {
      print('Error in ProductApiClient: $e');
      throw Exception('Failed to fetch products: $e');
    }
  }

  Future<Product> getProductById(int productId) async {
    try {
      print('Fetching product ID: $productId');
      final productRequest = Uri.https(
        _baseUrlProduct,
        '/api/Product/$productId',
      );

      final productResponse = await _httpClient.get(
        productRequest,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );
      if (productResponse.statusCode != 200) {
        throw Exception('Lỗi khi tải sản phẩm: ${productResponse.statusCode}');
      }
      final productJson = jsonDecode(productResponse.body) as Map<String, dynamic>;
      return Product.fromJson(productJson);

    } catch (e) {
      print('Lỗi trong ProductApiClient: $e');
      throw Exception('Không thể lấy thông tin sản phẩm: $e');
    }
  }

  //Get all image by productId
  Future<List<ProductImage>> getAllProductImageByProductId(int productId) async{
    final imageRequest = Uri.https(
        _baseUrlProduct,
        '/api/Product/Images/$productId'
    );

    final responseRequest = await http.get(imageRequest);
    if(responseRequest.statusCode!=200){
      throw Exception('Lỗi khi image: ${responseRequest.statusCode}');
    }
    final List<dynamic> imageJson = jsonDecode(responseRequest.body);
    final productImages = imageJson.map((json) {
      return ProductImage.fromJson(json);
    }).toList();
    return productImages;

  }
  Future<List<Brand>> getAllBrand() async{
    final imageRequest = Uri.https(
        _baseUrlProduct,
        '/api/Product/Brands'
    );

    final responseRequest = await http.get(imageRequest);
    if(responseRequest.statusCode!=200){
      throw Exception('Lỗi khi image: ${responseRequest.statusCode}');
    }
    final List<dynamic> brandJson = jsonDecode(responseRequest.body);
    final brands = brandJson.map((json) {
      return Brand.fromJson(json);
    }).toList();
    return brands;

  }

  Future<Product> getProductByTypeId(int productTypeId) async {
    try {
      final productRequest = Uri.https(
        _baseUrlProduct,
        '/api/Product/ByType/$productTypeId',
      );

      final productResponse = await _httpClient.get(
        productRequest,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('The connection has timed out');
        },
      );
      if (productResponse.statusCode != 200) {
        throw Exception('Lỗi khi tải sản phẩm: ${productResponse.statusCode}');
      }
      final productJson = jsonDecode(productResponse.body) as Map<String, dynamic>;
      return Product.fromJson(productJson);

    } catch (e) {
      print('Lỗi trong ProductApiClient: $e');
      throw Exception('Không thể lấy thông tin sản phẩm: $e');
    }
  }
  Future<List<Product>> getAllProductFilter({
    double? minPrice,
    double? maxPrice,
    List<int>? sizes, // Nhận vào danh sách int cho Size ID
    List<int>? colors, // Nhận vào danh sách int cho Color ID
    List<String>? brands, // Nhận vào danh sách String cho Brand
    int? typeId,
    String? sortBy,
  }) async {
    try {
      // Xây dựng tham số truy vấn
      final queryParams = <String, dynamic>{};

      if (minPrice != null) {
        queryParams['minPrice'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['maxPrice'] = maxPrice.toString();
      }

      // Xử lý sizes - lưu trữ dưới dạng danh sách
      if (sizes != null && sizes.isNotEmpty) {
        queryParams['sizes'] = sizes.map((size) => size.toString()).toList();
      }

      // Xử lý colors - lưu trữ dưới dạng danh sách
      if (colors != null && colors.isNotEmpty) {
        queryParams['colors'] = colors.map((color) => color.toString()).toList();
      }

      // Xử lý brands - lưu trữ dưới dạng danh sách
      if (brands != null && brands.isNotEmpty) {
        queryParams['brands'] = brands;
      }

      if (typeId != null) {
        queryParams['typeId'] = typeId.toString();
      }
      if (sortBy != null && sortBy.isNotEmpty) {
        queryParams['sortBy'] = sortBy;
      }

      // Tạo URI thủ công
      final uri = _buildUri(queryParams);
      print(uri);

      final filterResponse = await _httpClient.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Request timed out');
          throw TimeoutException('The connection has timed out');
        },
      );

      if (filterResponse.statusCode != 200) {
        throw Exception('Failed to load filtered products: ${filterResponse.statusCode}');
      }

      final List productJson = jsonDecode(filterResponse.body);
      final products = productJson.map((json) {
        return Product.fromJson(json);
      }).toList();

      return products;
    } catch (e) {
      print('Error in ProductApiClient filter: $e');
      throw Exception('Failed to fetch filtered products: $e');
    }
  }

  // Hàm tạo URI thủ công - chuyển ra ngoài phương thức getAllProductFilter
  Uri _buildUri(Map<String, dynamic> queryParams) {
    final buffer = StringBuffer();
    buffer.write('https://$_baseUrlProduct/api/Product/Filter');
    bool isFirstParam = true;

    // Thêm các tham số theo thứ tự mong muốn
    final orderedParams = [
      'minPrice',
      'maxPrice',
      'sizes',
      'colors',
      'brands',
      'typeId',
      'sortBy'
    ];

    for (final paramName in orderedParams) {
      if (queryParams.containsKey(paramName)) {
        final value = queryParams[paramName];

        if (value is List) {
          // Xử lý đúng cho danh sách
          for (final item in value) {
            if (isFirstParam) {
              buffer.write('?');
              isFirstParam = false;
            } else {
              buffer.write('&');
            }
            buffer.write('$paramName=${Uri.encodeComponent(item.toString())}');
          }
        } else {
          if (isFirstParam) {
            buffer.write('?');
            isFirstParam = false;
          } else {
            buffer.write('&');
          }
          buffer.write('$paramName=${Uri.encodeComponent(value.toString())}');
        }
      }
    }

    return Uri.parse(buffer.toString());
  }


  Future<List<Product>> getAllFavorite(String accessToken) async {
    try {
      final url = Uri.https(_baseUrlProduct, '/api/Product/Favorite');

      final response = await _httpClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseJson = jsonDecode(response.body);
        if (responseJson['success'] == true) {
          List<Product> products = (responseJson['data'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();
          return products;
        } else {
          throw Exception('Failed to load products');
        }
      } else {
        throw Exception('401 Unauthorized');
      }
    } catch (e) {
      throw Exception('Failed to get data: $e');
    }
  }
  void dispose(){
    _httpClient.close();
  }


}
