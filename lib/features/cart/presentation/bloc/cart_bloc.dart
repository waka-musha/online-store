import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../catalog/domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_event.dart';

part 'cart_state.dart';

final class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc()
    : super(
        const CartLoadedState(items: <CartItem>[]),
      ) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddCartItemEvent>(_onAddCartItem);
    on<IncrementCartItemQuantityEvent>(_onIncrementQuantity);
    on<DecrementCartItemQuantityEvent>(_onDecrementQuantity);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final currentItems = state is CartLoadedState
        ? (state as CartLoadedState).items
        : const <CartItem>[];

    emit(const CartLoadingState());

    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      emit(
        CartLoadedState(
          items: currentItems,
        ),
      );
    } on Object catch (_) {
      emit(
        const CartErrorState(
          message: 'Не удалось загрузить корзину',
        ),
      );
    }
  }

  void _onAddCartItem(
    AddCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (current is! CartLoadedState) return;

    final items = List<CartItem>.from(current.items);

    final index = items.indexWhere(
      (item) =>
          item.product.id == event.product.id &&
          item.sizeName == event.sizeName,
    );

    if (index == -1) {
      items.add(
        CartItem(
          product: event.product,
          sizeName: event.sizeName,
        ),
      );
    } else {
      final existing = items[index];
      items[index] = existing.copyWith(
        quantity: existing.quantity + 1,
      );
    }

    emit(current.copyWith(items: items));
  }

  void _onIncrementQuantity(
    IncrementCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (current is! CartLoadedState) return;

    final items = List<CartItem>.from(current.items);

    final index = items.indexWhere(
      (item) =>
          item.product.id == event.item.product.id &&
          item.sizeName == event.item.sizeName,
    );

    if (index == -1) return;

    final existing = items[index];
    items[index] = existing.copyWith(
      quantity: existing.quantity + 1,
    );

    emit(current.copyWith(items: items));
  }

  void _onDecrementQuantity(
    DecrementCartItemQuantityEvent event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (current is! CartLoadedState) return;

    final items = List<CartItem>.from(current.items);

    final index = items.indexWhere(
      (item) =>
          item.product.id == event.item.product.id &&
          item.sizeName == event.item.sizeName,
    );

    if (index == -1) return;

    final existing = items[index];

    if (existing.quantity <= 1) {
      return;
    }

    items[index] = existing.copyWith(
      quantity: existing.quantity - 1,
    );

    emit(current.copyWith(items: items));
  }

  void _onRemoveCartItem(
    RemoveCartItemEvent event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (current is! CartLoadedState) return;

    final items = current.items
        .where(
          (item) =>
              item.product.id != event.item.product.id ||
              item.sizeName != event.item.sizeName,
        )
        .toList();

    emit(current.copyWith(items: items));
  }

  void _onClearCart(
    ClearCartEvent event,
    Emitter<CartState> emit,
  ) {
    final current = state;
    if (current is! CartLoadedState) return;
    if (current.items.isEmpty) return;

    emit(const CartLoadedState(items: <CartItem>[]));
  }
}
