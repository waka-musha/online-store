import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    this.name,
    this.price,
    this.finalPrice,
    this.images,
    this.sizeDetails,
  });

  @JsonKey(fromJson: _idToString)
  final String id;

  static String _idToString(Object? v) => v?.toString() ?? '';

  final String? name;

  final int? price;

  @JsonKey(name: 'final_price')
  final int? finalPrice;

  @JsonKey(name: 'photos')
  final List<dynamic>? images;

  @JsonKey(name: 'size_details')
  final List<dynamic>? sizeDetails;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
