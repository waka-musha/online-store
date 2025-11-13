part of 'cart_bloc.dart';

@immutable
sealed class CartState {
  const CartState();
}

final class CartLoadingState extends CartState {
  const CartLoadingState();
}

final class CartLoadedState extends CartState {
  const CartLoadedState({
    required this.items,
  });

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get totalItems => items.fold<int>(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      items.fold<int>(0, (sum, item) => sum + item.totalPrice);

  CartLoadedState copyWith({
    List<CartItem>? items,
  }) => CartLoadedState(
    items: items ?? this.items,
  );
}

final class CartErrorState extends CartState {
  const CartErrorState({required this.message});

  final String message;
}
