// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_size_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSizeDto _$ProductSizeDtoFromJson(Map<String, dynamic> json) =>
    ProductSizeDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      amountReal: (json['amount_real'] as num?)?.toInt(),
      show: json['show'] as bool?,
      barcode: json['barcode'] as String?,
      subscribe: json['subscribe'] as bool?,
    );

Map<String, dynamic> _$ProductSizeDtoToJson(ProductSizeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'amount_real': instance.amountReal,
      'show': instance.show,
      'barcode': instance.barcode,
      'subscribe': instance.subscribe,
    };
