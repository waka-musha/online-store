import '../../domain/entities/product.dart';
import '../models/get_category_product_list_request_dto.dart';
import '../models/product_dto.dart';

abstract final class ProductMapper {
  static Product toDomain(ProductDto dto) {
    final name = (dto.name?.trim().isNotEmpty ?? false)
        ? dto.name!.trim()
        : 'Товар ${dto.id}';

    final price = dto.finalPrice ?? dto.price ?? 0;

    final imageUrls = _extractImages(dto.images);
    final sizes = _extractSizes(dto.sizeDetails);

    return Product(
      id: dto.id,
      name: name,
      price: price,
      imageUrls: imageUrls,
      sizes: sizes,
    );
  }

  static List<String> _extractImages(List<dynamic>? raw) {
    if (raw == null) return const <String>[];
    final out = <String>[];
    for (final elem in raw) {
      if (elem is String && elem.isNotEmpty) {
        out.add(elem);
      } else if (elem is Map) {
        final value =
            elem['big'] ??
            elem['webp'] ??
            elem['src'] ??
            elem['url'] ??
            elem['image'] ??
            elem['small'];
        if (value is String && value.isNotEmpty) out.add(value);
      }
    }
    final seen = <String>{};
    return out.where(seen.add).toList(growable: false);
  }

  static List<String> _extractSizes(List<dynamic>? raw) {
    if (raw == null) return const <String>[];
    final out = <String>[];
    for (final elem in raw) {
      if (elem is String && elem.isNotEmpty) out.add(elem);
      if (elem is Map) {
        final size =
            elem['rus'] ?? elem['name'] ?? elem['title'] ?? elem['size'];
        if (size is String && size.isNotEmpty) out.add(size);
      }
    }
    final seen = <String>{};
    return out.where(seen.add).toList(growable: false);
  }

  static GetCategoryProductListRequestDto toProductListRequestFromCode({
    required String categoryCode,
    required int page,
  }) => GetCategoryProductListRequestDto(
    category: categoryCode.trim(),
    page: page,
  );
}
