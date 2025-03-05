

import 'package:product_api/product_api.dart';

class ProductRepository {
  final ProductApiClient productApiClient;
  ProductRepository({required this.productApiClient});
  Future<List<Product>> getAllProduct() async {
    try {
      print('call apiClient');
      final products = await productApiClient.getAllProduct();
      return products;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error fetching products: $e");
      throw Exception('Failed to load products');
    }
  }
  Future<List<ProductImage>> getAllProductImage(int productId) async {
    try {
      print('call apiClient');
      final productImages = await productApiClient.getAllProductImageByProductId(productId);
      return productImages;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error fetching productImages: $e");
      throw Exception('Failed to load productImages');
    }
  }

  Future<Product> getProductById(int productId) async{
    try{
      final product = await productApiClient.getProductById(productId);
      return product;
    }catch(e){
      print("Error fetching product: $e");
      throw Exception('Failed to load products');
    }
  }
  Future<List<Brand>> getAllBrand() async{
    try{
      final brands = await productApiClient.getAllBrand();
      return brands;
    }catch(e){
      throw Exception('Failed to load products');
    }
  }
  Future<List<Product>> getAllProductFilter({
    double? minPrice,
    double? maxPrice,
    List<int>? sizes,
    List<int>? colors,
    List<String>? brands,
    int? typeId,
    String? sortBy,
  }) async {
    try {
      final filteredProducts = await productApiClient.getAllProductFilter(
        minPrice: minPrice,
        maxPrice: maxPrice,
        sizes: sizes,
        colors: colors,
        brands: brands,
        typeId: typeId,
        sortBy: sortBy,
      );
      return filteredProducts;
    } catch (e) {
      // Nếu có lỗi, in thông báo lỗi ra và ném exception
      print("Error fetching filtered products: $e");
      throw Exception('Failed to load filtered products');
    }
  }
  Future<List<Product>> getAllProductFavorite(String accessToken) async{
    print(accessToken);
    try{
      final products = await productApiClient.getAllFavorite(accessToken);
      return products;

    }catch(e){
      throw Exception(e.toString());
    }


  }
  void dispose(){
    productApiClient.dispose();
  }
}