import 'package:dio/dio.dart';

import '../../../../core/failure/failure.dart';
import '../../../../core/paging/page_result.dart';
import '../../../../core/result/result.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repository/catalog_repository.dart';

import '../api/catalog_api.dart';
import '../mappers/category_mapper.dart';
import '../mappers/product_mapper.dart';
import '../models/category_dto.dart';
import '../models/product_dto.dart';

final class CatalogRepositoryImpl implements CatalogRepository {
  static const String _rootCategoryCode = 'clothes';
  static const int _pageSize = 12;

  final CatalogApi _api;

  const CatalogRepositoryImpl({required CatalogApi api}) : _api = api;

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final request = CategoryMapper.toDetailRequest(_rootCategoryCode);
      final body = await _api.getCategoryDetail(request);

      final apiData = body['api_data'];
      if (apiData is! Map<String, dynamic>) {
        return const Result.failure(
          failure: Failure.parsing(message: 'api_data not found'),
        );
      }

      final list = apiData['aMenu'];
      if (list is! List) {
        return const Result.success(data: <Category>[]);
      }

      final dtos = list
          .whereType<Map<String, dynamic>>()
          .map((m) => CategoryDto.fromJson(m.cast<String, dynamic>()))
          .toList(growable: false);

      final categories = dtos
          .map(CategoryMapper.toDomain)
          .toList(growable: false);

      return Result.success(data: categories);
    } on DioException catch (err, st) {
      return Result.failure(failure: _mapDioToFailure(err, st));
    } on FormatException catch (err) {
      return Result.failure(failure: Failure.parsing(message: err.message));
    } on Object catch (err, st) {
      return Result.failure(
        failure: Failure.unknown(error: err, stackTrace: st),
      );
    }
  }

  @override
  Future<Result<PageResult<Product>>> getProducts({
    required String categoryCode,
    required int page,
  }) async {
    try {
      final request = ProductMapper.toProductListRequestFromCode(
        categoryCode: categoryCode,
        page: page,
      );
      final body = await _api.getCategoryProductList(request);

      final apiData = body['api_data'];
      if (apiData is! Map<String, dynamic>) {
        return const Result.failure(
          failure: Failure.parsing(message: 'api_data not found'),
        );
      }

      final list = apiData['aProduct'];
      if (list is! List) {
        return Result.success(
          data: PageResult<Product>(
            items: const [],
            page: page,
            hasMore: false,
          ),
        );
      }

      final productDtos = list
          .whereType<Map<String, dynamic>>()
          .map((m) => ProductDto.fromJson(m.cast<String, dynamic>()))
          .toList(growable: false);

      final products = productDtos
          .map(ProductMapper.toDomain)
          .toList(growable: false);

      final hasNextPage = products.length == _pageSize;

      return Result.success(
        data: PageResult<Product>(
          items: products,
          page: page,
          hasMore: hasNextPage,
        ),
      );
    } on DioException catch (err, st) {
      return Result.failure(failure: _mapDioToFailure(err, st));
    } on FormatException catch (err) {
      return Result.failure(failure: Failure.parsing(message: err.message));
    } on Object catch (err, st) {
      return Result.failure(
        failure: Failure.unknown(error: err, stackTrace: st),
      );
    }
  }

  Failure _mapDioToFailure(DioException err, StackTrace st) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return Failure.network(
          statusCode: err.response?.statusCode,
          message: err.message,
        );
      case DioExceptionType.badResponse:
        return Failure.api(
          statusCode: err.response?.statusCode,
          message: err.message,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return Failure.unknown(error: err, stackTrace: st);
    }
  }
}
