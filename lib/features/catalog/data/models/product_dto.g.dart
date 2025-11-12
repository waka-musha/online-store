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
  images: json['photos'] as List<dynamic>?,
  sizeDetails: json['size_details'] as List<dynamic>?,
);

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'final_price': instance.finalPrice,
      'photos': instance.images,
      'size_details': instance.sizeDetails,
    };
