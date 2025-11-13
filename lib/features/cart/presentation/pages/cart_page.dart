import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const Text('Корзина'),
      centerTitle: true,
    ),
    body: SafeArea(
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is! CartLoadedState) {
            return const _CenteredLoader();
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: state.isEmpty
                ? const _EmptyCartView()
                : _CartContent(state: state),
          );
        },
      ),
    ),
  );
}

class _CartContent extends StatelessWidget {
  final CartLoadedState state;

  const _CartContent({required this.state});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          itemCount: state.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = state.items[index];
            return _CartItemTile(
              item: item,
              onIncrement: () => context.read<CartBloc>().add(
                IncrementCartItemQuantityEvent(item),
              ),
              onDecrement: () => context.read<CartBloc>().add(
                DecrementCartItemQuantityEvent(item),
              ),
              onRemove: () => context.read<CartBloc>().add(
                RemoveCartItemEvent(item),
              ),
            );
          },
        ),
      ),
      const Divider(height: 1),
      _CartSummary(
        totalItems: state.totalItems,
        totalPrice: state.totalPrice,
      ),
    ],
  );
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = item.product;
    final images = product.imageUrls.isNotEmpty
        ? product.imageUrls
        : const [''];
    final priceText = _formatPrice(product.price);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CartItemImage(imageUrl: images.first),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (item.sizeName != null &&
                        item.sizeName!.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Размер ${item.sizeName}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      '$priceText руб.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _QuantityControl(
                          value: item.quantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.delete_outline_rounded),
                          tooltip: 'Удалить из корзины',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemImage extends StatelessWidget {
  final String imageUrl;

  const _CartItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 90,
        height: 120,
        child: imageUrl.isEmpty
            ? ColoredBox(color: placeholderColor)
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return ColoredBox(color: placeholderColor);
                },
                errorBuilder: (_, _, _) => ColoredBox(
                  color: placeholderColor,
                ),
              ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityControl({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDecrement = value > 1;

    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.remove,
          onPressed: canDecrement ? onDecrement : null,
        ),
        const SizedBox(width: 8),
        Text(
          '$value ед.',
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        _RoundIconButton(
          icon: Icons.add,
          onPressed: onIncrement,
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _RoundIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onPressed != null;

    final borderRadius = BorderRadius.circular(100);

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: theme.colorScheme.surface,
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.onSurface.withValues(
              alpha: isEnabled ? 1.0 : 0.4,
            ),
          ),
        ),
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final int totalItems;
  final int totalPrice;

  const _CartSummary({
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceText = _formatPrice(totalPrice);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Итого',
                style: theme.textTheme.titleMedium,
              ),
              const Spacer(),
              Text(
                '$priceText руб.',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '$totalItems товар(ов)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: totalItems > 0 ? () {} : null,
              child: const Text('Перейти к оформлению'),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'Ваша корзина пуста,\nно это можно исправить :)',
              textAlign: TextAlign.center,
              style: style,
            ),
          ],
        ),
      ),
    );
  }
}

class _CenteredLoader extends StatelessWidget {
  const _CenteredLoader();

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

String _formatPrice(int price) {
  final s = price.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final rev = s.length - i;
    buf.write(s[i]);
    if (rev > 1 && rev % 3 == 1) {
      buf.write(' ');
    }
  }
  return buf.toString();
}
