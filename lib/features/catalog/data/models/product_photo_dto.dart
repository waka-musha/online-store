import 'package:json_annotation/json_annotation.dart';

part 'product_photo_dto.g.dart';

@JsonSerializable()
class ProductPhotoDto {
  const ProductPhotoDto({
    this.big,
    this.webp,
    this.small,
  });

  final String? big;
  final String? webp;
  final String? small;

  factory ProductPhotoDto.fromJson(Map<String, dynamic> json) =>
      _$ProductPhotoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPhotoDtoToJson(this);
}
