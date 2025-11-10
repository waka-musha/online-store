import 'package:dio/dio.dart';

import '../models/category_dto.dart';
import '../models/get_category_detail_request_dto.dart';
import '../models/get_category_product_list_request_dto.dart';
import '../models/product_dto.dart';

part 'api_params.dart';

sealed class CatalogApi {
  factory CatalogApi(Dio dio) = _CatalogApiImpl;

  const CatalogApi._();

  Future<Map<String, Object?>> getCategoryDetail(
    GetCategoryDetailRequestDto dto,
  );

  Future<Map<String, Object?>> getCategoryProductList(
    GetCategoryProductListRequestDto dto,
  );

  List<CategoryDto> parseCategories(Map<String, Object?> json) {
    final raw = json['result'];
    if (raw is! List) {
      throw const FormatException("Expected 'result' as List for categories");
    }
    return raw
        .whereType<Map<String, Object?>>()
        .map(CategoryDto.fromJson)
        .toList(growable: false);
  }

  List<ProductDto> parseProducts(Map<String, Object?> json) {
    final raw = json['result'];
    if (raw is! List) {
      throw const FormatException("Expected 'result' as List for products");
    }
    return raw
        .whereType<Map<String, Object?>>()
        .map(ProductDto.fromJson)
        .toList(growable: false);
  }
}

final class _CatalogApiImpl extends CatalogApi {
  final Dio _dio;

  _CatalogApiImpl(this._dio) : super._();

  @override
  Future<Map<String, Object?>> getCategoryDetail(
    GetCategoryDetailRequestDto dto,
  ) async {
    final res = await _dio.post<Map<String, Object?>>(
      _ApiParams.categoryDetail,
      data: dto.toJson(),
    );
    final data = res.data;
    if (data == null) {
      throw const FormatException('Empty body for get_category_detail');
    }
    return data;
  }

  @override
  Future<Map<String, Object?>> getCategoryProductList(
    GetCategoryProductListRequestDto dto,
  ) async {
    final res = await _dio.post<Map<String, Object?>>(
      _ApiParams.categoryProductList,
      data: dto.toJson(),
    );
    final data = res.data;
    if (data == null) {
      throw const FormatException('Empty body for get_category_product_list');
    }
    return data;
  }
}
