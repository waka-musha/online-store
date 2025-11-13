import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../catalog/domain/entities/product.dart';

part 'cart_item.freezed.dart';

@freezed
abstract class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({
    required Product product,
    String? sizeName,
    @Default(1) int quantity,
  }) = _CartItem;

  int get totalPrice => product.price * quantity;

  bool get hasSize => sizeName != null && sizeName!.isNotEmpty;
}
