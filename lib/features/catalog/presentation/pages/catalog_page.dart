import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../bloc/catalog_bloc.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(const LoadCatalogEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    const threshold = 250;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;
    if (maxExtent - offset <= threshold) {
      context.read<CatalogBloc>().add(const LoadNextPageEvent());
    }
  }

  void _onProductAddedToCart(Product product) {
    _showCartBanner();
  }

  void _showCartBanner() {
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..hideCurrentMaterialBanner();

    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.black : Colors.white;

    messenger.showMaterialBanner(
      MaterialBanner(
        backgroundColor: backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: Center(
          child: Text(
            'Товар успешно добавлен в корзину',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
            ),
          ),
        ),
        actions: const [
          SizedBox.shrink(),
        ],
        overflowAlignment: OverflowBarAlignment.center,
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      messenger.hideCurrentMaterialBanner();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('Каталог товаров'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) {
              if (previous is! CartLoadedState || current is! CartLoadedState) {
                return previous.runtimeType != current.runtimeType;
              }
              return previous.totalItems != current.totalItems;
            },
            builder: (context, state) {
              final count = state is CartLoadedState ? state.totalItems : 0;

              return _CartPillButton(
                count: count,
                onPressed: () async {
                  await Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (_) => const CartPage(),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: BlocBuilder<CatalogBloc, CatalogState>(
        buildWhen: (previous, current) =>
            previous.runtimeType != current.runtimeType ||
            current is CatalogLoadedState,
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state) {
            CatalogInitialState() ||
            CatalogLoadingState() => const _CenteredLoader(),
            CatalogErrorState(failure: final failure) => _ErrorView(
              key: const ValueKey('catalog_error'),
              message: _failureToMessage(failure),
              onRetry: () =>
                  context.read<CatalogBloc>().add(const LoadCatalogEvent()),
            ),
            CatalogLoadedState() => _LoadedView(
              key: const ValueKey('catalog_loaded'),
              state: state,
              controller: _scrollController,
              onProductAdded: _onProductAddedToCart,
            ),
          },
        ),
      ),
    ),
  );

  static String _failureToMessage(Failure failure) => failure.when(
    network: (_, message) => message ?? 'Проблема с соединением',
    api: (_, message) => message ?? 'Ошибка сервера',
    parsing: (message) => message ?? 'Ошибка данных',
    empty: () => 'Пусто',
    unknown: (_, _) => 'Неизвестная ошибка',
  );
}

class _CartPillButton extends StatelessWidget {
  final int count;
  final VoidCallback? onPressed;

  const _CartPillButton({
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = scheme.primary;
    final foreground = scheme.onPrimary;

    return Tooltip(
      message: 'Корзина',
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 32),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: foreground,
                  ),
                ],
              ),
            ),
          ),
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

class _LoadedView extends StatelessWidget {
  final CatalogLoadedState state;
  final ScrollController controller;
  final void Function(Product product) onProductAdded;

  const _LoadedView({
    required this.state,
    required this.controller,
    required this.onProductAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async =>
        context.read<CatalogBloc>().add(const RefreshCategoryEvent()),
    child: CustomScrollView(
      controller: controller,
      slivers: [
        const SliverToBoxAdapter(
          child: Column(
            children: [
              _IntroBlock(),
              SizedBox(height: 12),
              _ThemeButtonsRow(),
              SizedBox(height: 8),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: _CategoryTabs(
            categories: state.categories,
            selectedCode: state.selectedCategoryCode,
            onSelected: (code) => context.read<CatalogBloc>().add(
              SelectCategoryEvent(categoryCode: code),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
        if (state.products.isEmpty)
          const SliverToBoxAdapter(
            child: _EmptyCategoryPlaceholder(),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(12),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = state.products[index];
                  return _ProductCard(
                    product: product,
                    onTap: () => _openProductSheet(
                      context,
                      product,
                      onProductAdded,
                    ),
                  );
                },
                childCount: state.products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
            ),
          ),
        SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: state.isLoadingMore
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    ),
  );

  static Future<void> _openProductSheet(
    BuildContext context,
    Product product,
    void Function(Product product) onProductAdded,
  ) async {
    final theme = Theme.of(context);
    final cartBloc = context.read<CartBloc>();

    final selectedSize = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Material(
        color: theme.scaffoldBackgroundColor,
        child: _ProductSheet(product: product),
      ),
    );

    if (product.hasSizes && selectedSize == null) return;

    cartBloc.add(
      AddCartItemEvent(
        product: product,
        sizeName: selectedSize,
      ),
    );

    onProductAdded(product);
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              'Каждый день тысячи девушек распаковывают пакеты с новинками '
              'Lichi и становятся счастливее, ведь очевидно, что новое платье '
              'может изменить день, а с ним и всю жизнь!',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurface.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeButtonsRow extends StatelessWidget {
  const _ThemeButtonsRow();

  @override
  Widget build(BuildContext context) {
    final isDark = context.select<ThemeCubit, bool>(
      (cubit) => cubit.state.mode == ThemeMode.dark,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _ThemeCardButton(
              icon: Icons.nightlight_sharp,
              label: 'Темная тема',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              isSelected: isDark,
              onTap: () => context.read<ThemeCubit>().setDark(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ThemeCardButton(
              icon: Icons.sunny,
              label: 'Светлая тема',
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              isSelected: !isDark,
              onTap: () => context.read<ThemeCubit>().setLight(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCardButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCardButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(20);
    final textTheme = theme.textTheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = isSelected
        ? backgroundColor
        : backgroundColor.withValues(alpha: isDarkTheme ? 0.5 : 0.1);

    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: effectiveBackgroundColor,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 10),
              Text(
                label,
                style: textTheme.labelMedium?.copyWith(
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<Category> categories;
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _CategoryTabs({
    required this.categories,
    required this.selectedCode,
    required this.onSelected,
  });

  double _textWidth(
    BuildContext context,
    String text,
    TextStyle style,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox(height: 8);

    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.code == selectedCode;

          final baseStyle = isSelected
              ? textTheme.titleSmall
              : textTheme.bodyMedium;

          final textStyle =
              baseStyle?.copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ) ??
              const TextStyle(fontSize: 14);

          final underlineWidth = _textWidth(
            context,
            category.title,
            textStyle,
          );

          final textColor =
              textStyle.color ?? Theme.of(context).colorScheme.onSurface;

          return InkWell(
            onTap: () => onSelected(category.code),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: textStyle,
                ),
                const SizedBox(height: 4),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  width: isSelected ? underlineWidth : 0,
                  decoration: BoxDecoration(
                    color: textColor,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  int _currentImagePage = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.product;
    final images = product.imageUrls.isNotEmpty
        ? product.imageUrls
        : const [''];
    final placeholderColor = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceContainerHighest
        : Colors.white;
    final borderRadius = BorderRadius.circular(12);

    return InkWell(
      onTap: widget.onTap,
      borderRadius: borderRadius,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) {
                      setState(() => _currentImagePage = index);
                    },
                    itemBuilder: (context, index) {
                      final imageUrl = images[index];
                      if (imageUrl.isEmpty) {
                        return ColoredBox(color: placeholderColor);
                      }
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return ColoredBox(color: placeholderColor);
                        },
                        errorBuilder: (_, _, _) =>
                            ColoredBox(color: placeholderColor),
                      );
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: _ImagePageIndicator(
                        itemCount: images.length,
                        currentIndex: _currentImagePage,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: theme.scaffoldBackgroundColor,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: _ProductTileInfo(
                title: product.name,
                price: product.price,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _ImagePageIndicator({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final count = itemCount.clamp(1, 3);
    final activeIndex = currentIndex % count;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(count, (index) {
            final isActive = index == activeIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? Colors.black : Colors.white,
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _ProductTileInfo extends StatelessWidget {
  final String title;
  final int price;

  const _ProductTileInfo({
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final priceStyle = textTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
    final descriptionStyle = textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    );
    final priceText = _formatPrice(price);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$priceText руб.',
          style: priceStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: descriptionStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ProductSheet extends StatefulWidget {
  final Product product;

  const _ProductSheet({required this.product});

  @override
  State<_ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<_ProductSheet> {
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final sizes = widget.product.sizes;
    final priceText = _formatPrice(widget.product.price);

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Выберите размер',
                style: textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            if (sizes.isNotEmpty) ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sizes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final size = sizes[index];
                  final selected = _selectedSize == size.name;
                  final isAvailable = size.isAvailable;

                  return InkWell(
                    onTap: isAvailable
                        ? () => setState(() => _selectedSize = size.name)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Text(
                            size.name,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          if (!isAvailable)
                            Text(
                              'нет в наличии',
                              style: textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {},
                child: const Text('Как подобрать размер?'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(vertical: 18),
                  ),
                ),
                onPressed: () {
                  if (widget.product.hasSizes && _selectedSize == null) {
                    return;
                  }
                  Navigator.of(context).pop<String?>(_selectedSize);
                },
                child: Text('В корзину · $priceText руб.'),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

class _EmptyCategoryPlaceholder extends StatelessWidget {
  const _EmptyCategoryPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: Text(
          'Товары в данной категории отсутствуют,\n'
          'пожалуйста выберите другую :(',
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    ),
  );
}
