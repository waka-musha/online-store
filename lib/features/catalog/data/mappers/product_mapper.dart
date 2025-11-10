import '../../domain/entities/product.dart';
import '../models/get_category_product_list_request_dto.dart';
import '../models/product_dto.dart';

abstract final class ProductMapper {
  static Product toDomain(ProductDto dto) => Product(
    id: dto.id,
    title: dto.title,
    price: dto.price,
    imageUrls: dto.imageUrls,
    sizes: dto.sizes,
  );

  static GetCategoryProductListRequestDto toProductListRequestFromCode({
    required String categoryCode,
    required int page,
  }) => GetCategoryProductListRequestDto(
    category: categoryCode.trim(),
    page: page,
  );
}
