import 'package:json_annotation/json_annotation.dart';

part 'product_size_dto.g.dart';

@JsonSerializable()
class ProductSizeDto {
  const ProductSizeDto({this.rus});

  final String? rus;

  factory ProductSizeDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSizeDtoToJson(this);
}
