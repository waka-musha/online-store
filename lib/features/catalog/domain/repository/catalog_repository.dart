import '../../../../core/paging/page_result.dart';
import '../../../../core/result/result.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract interface class CatalogRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<PageResult<Product>>> getProducts({
    required String categoryCode,
    required int page,
  });
}
