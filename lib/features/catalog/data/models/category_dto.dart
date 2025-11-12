import 'package:json_annotation/json_annotation.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.title,
    required this.code,
  });

  final String id;

  @JsonKey(name: 'name')
  final String title;

  @JsonKey(name: 'url')
  final String code;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}
