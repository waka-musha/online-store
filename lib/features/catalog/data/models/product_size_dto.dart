import 'package:json_annotation/json_annotation.dart';

part 'product_size_dto.g.dart';

@JsonSerializable()
class ProductSizeDto {
  const ProductSizeDto({
    this.id,
    this.name,
    this.amount,
    this.amountReal,
    this.show,
    this.barcode,
    this.subscribe,
  });

  final int? id;
  final String? name;
  final int? amount;

  @JsonKey(name: 'amount_real')
  final int? amountReal;

  final bool? show;
  final String? barcode;
  final bool? subscribe;

  bool get isAvailable => (show ?? false) && (amountReal ?? 0) > 0;

  factory ProductSizeDto.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSizeDtoToJson(this);
}
