import '../../domain/entities/product.dart';
import '../models/get_category_product_list_request_dto.dart';
import '../models/product_dto.dart';

abstract final class ProductMapper {
  static Product toDomain(ProductDto dto) {
    final imageUrls = dto.photos
        .map((p) => p.big ?? p.webp ?? p.small)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList(growable: false);

    final sizes = dto.sizeDetails
        .map((s) => s.rus)
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toSet()
        .toList(growable: false);

    return Product(
      id: dto.id,
      name: dto.name!.trim(),
      price: dto.price!,
      imageUrls: imageUrls,
      sizes: sizes,
    );
  }

  static GetCategoryProductListRequestDto toProductListRequestFromCode({
    required String categoryCode,
    required int page,
  }) => GetCategoryProductListRequestDto(
    category: categoryCode.trim(),
    page: page,
  );
}
