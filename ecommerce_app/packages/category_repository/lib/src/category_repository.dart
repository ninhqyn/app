
import 'package:category_repository/category_repository.dart';

class CategoryRepository{
  final CategoryApiClient categoryApiClient;

  CategoryRepository({required this.categoryApiClient});

  Future<List<Category>> getAllCategoryParent() async{
    try{
      final categories = await categoryApiClient.getAllCategoryParent();
      return categories;
    }catch(e){
      print(e.toString());
      throw Exception('fail to fetch category');
    }

  }
  Future<List<Category>> getAllCategoryByParentId(int parentId) async{
    try{
      final categories = await categoryApiClient.getAllCategoryByParentId(parentId);
      return categories;
    }catch(e){
      throw Exception('fail to fetch category by parentId');
    }

  }
}