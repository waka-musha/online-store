import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';

@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String title,
    required int price,
    @Default(<String>[]) List<String> imageUrls,
    @Default(<String>[]) List<String> sizes,
  }) = _Product;

  bool get hasSizes => sizes.isNotEmpty;
}
