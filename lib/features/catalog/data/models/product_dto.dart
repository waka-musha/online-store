import 'package:json_annotation/json_annotation.dart';

import 'product_photo_dto.dart';
import 'product_size_dto.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    this.name,
    this.price,
    this.finalPrice,
    this.photos = const <ProductPhotoDto>[],
    this.sizes = const <ProductSizeDto>[],
  });

  @JsonKey(fromJson: _idToString)
  final String id;

  static String _idToString(Object? v) => v?.toString() ?? '';

  final String? name;

  final int? price;

  @JsonKey(name: 'final_price')
  final int? finalPrice;

  @JsonKey(name: 'photos')
  final List<ProductPhotoDto> photos;

  @JsonKey(name: 'sizes', fromJson: _sizesFromJson)
  final List<ProductSizeDto> sizes;

  static List<ProductSizeDto> _sizesFromJson(Object? raw) {
    if (raw is Map) {
      return raw.values
          .whereType<Map<String, dynamic>>()
          .map(ProductSizeDto.fromJson)
          .toList(growable: false);
    }
    return const <ProductSizeDto>[];
  }

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
