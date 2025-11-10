import 'package:json_annotation/json_annotation.dart';

part 'get_category_detail_request_dto.g.dart';

@JsonSerializable()
class GetCategoryDetailRequestDto {
  const GetCategoryDetailRequestDto({
    required this.category,
    this.shop = 2,
    this.lang = 1,
  });

  final int shop;
  final int lang;
  final String category;

  factory GetCategoryDetailRequestDto.fromJson(Map<String, dynamic> json) =>
      _$GetCategoryDetailRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetCategoryDetailRequestDtoToJson(this);
}
