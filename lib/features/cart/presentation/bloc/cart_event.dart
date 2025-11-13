part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {
  const CartEvent();
}

final class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

final class AddCartItemEvent extends CartEvent {
  const AddCartItemEvent({
    required this.product,
    this.sizeName,
  });

  final Product product;
  final String? sizeName;
}

final class IncrementCartItemQuantityEvent extends CartEvent {
  const IncrementCartItemQuantityEvent(this.item);

  final CartItem item;
}

final class DecrementCartItemQuantityEvent extends CartEvent {
  const DecrementCartItemQuantityEvent(this.item);

  final CartItem item;
}

final class RemoveCartItemEvent extends CartEvent {
  const RemoveCartItemEvent(this.item);

  final CartItem item;
}

final class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}
