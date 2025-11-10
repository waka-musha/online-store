import '../../domain/entities/category.dart';
import '../models/category_dto.dart';
import '../models/get_category_detail_request_dto.dart';
import '../models/get_category_product_list_request_dto.dart';

abstract final class CategoryMapper {
  static Category toDomain(CategoryDto dto) => Category(
    id: dto.id,
    title: dto.title,
    code: dto.code,
  );

  static GetCategoryDetailRequestDto toDetailRequest(String rootCategoryCode) =>
      GetCategoryDetailRequestDto(category: rootCategoryCode.trim());

  static GetCategoryProductListRequestDto toProductListRequestFromCategory({
    required Category category,
    required int page,
  }) => GetCategoryProductListRequestDto(
    category: category.code.trim(),
    page: page,
  );
}
