import 'package:json_annotation/json_annotation.dart';

part 'get_category_product_list_request_dto.g.dart';

@JsonSerializable()
class GetCategoryProductListRequestDto {
  const GetCategoryProductListRequestDto({
    required this.category,
    required this.page,
    this.shop = 2,
    this.lang = 1,
    this.limit = 12,
  });

  final int shop;
  final int lang;
  final String category;
  final int limit;
  final int page;

  factory GetCategoryProductListRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$GetCategoryProductListRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GetCategoryProductListRequestDtoToJson(this);
}
