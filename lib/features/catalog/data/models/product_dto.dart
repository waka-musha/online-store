import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.price,
    this.imageUrls = const <String>[],
    this.sizes = const <String>[],
  });

  final String id;
  final String title;
  final int price;
  @JsonKey(name: 'image_urls')
  final List<String> imageUrls;
  final List<String> sizes;

  factory ProductDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);
}
