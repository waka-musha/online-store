import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required int price,
    @Default(<String>[]) List<String> imageUrls,
    @Default(<ProductSize>[]) List<ProductSize> sizes,
  }) = _Product;

  bool get hasSizes => sizes.isNotEmpty;
}

@freezed
abstract class ProductSize with _$ProductSize {
  const ProductSize._();

  const factory ProductSize({
    required String name,
    @Default(true) bool isAvailable,
  }) = _ProductSize;
}
