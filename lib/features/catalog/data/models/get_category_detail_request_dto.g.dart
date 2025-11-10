// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_detail_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCategoryDetailRequestDto _$GetCategoryDetailRequestDtoFromJson(
  Map<String, dynamic> json,
) => GetCategoryDetailRequestDto(
  category: json['category'] as String,
  shop: (json['shop'] as num?)?.toInt() ?? 2,
  lang: (json['lang'] as num?)?.toInt() ?? 1,
);

Map<String, dynamic> _$GetCategoryDetailRequestDtoToJson(
  GetCategoryDetailRequestDto instance,
) => <String, dynamic>{
  'shop': instance.shop,
  'lang': instance.lang,
  'category': instance.category,
};
