// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_category_product_list_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCategoryProductListRequestDto _$GetCategoryProductListRequestDtoFromJson(
  Map<String, dynamic> json,
) => GetCategoryProductListRequestDto(
  category: json['category'] as String,
  page: (json['page'] as num).toInt(),
  shop: (json['shop'] as num?)?.toInt() ?? 2,
  lang: (json['lang'] as num?)?.toInt() ?? 1,
  limit: (json['limit'] as num?)?.toInt() ?? 12,
);

Map<String, dynamic> _$GetCategoryProductListRequestDtoToJson(
  GetCategoryProductListRequestDto instance,
) => <String, dynamic>{
  'shop': instance.shop,
  'lang': instance.lang,
  'category': instance.category,
  'limit': instance.limit,
  'page': instance.page,
};
