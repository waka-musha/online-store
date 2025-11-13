// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: ProductDto._idToString(json['id']),
  name: json['name'] as String?,
  price: (json['price'] as num?)?.toInt(),
  finalPrice: (json['final_price'] as num?)?.toInt(),
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => ProductPhotoDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ProductPhotoDto>[],
  sizes: json['sizes'] == null
      ? const <ProductSizeDto>[]
      : ProductDto._sizesFromJson(json['sizes']),
);

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'final_price': instance.finalPrice,
      'photos': instance.photos,
      'sizes': instance.sizes,
    };
