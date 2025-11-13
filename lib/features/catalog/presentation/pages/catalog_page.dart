import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../core/theme/theme_cubit.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: const Text('Каталог товаров'),
      actions: const [
        _CartActionButton(count: 0, onPressed: null),
        SizedBox(width: 8),
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

class _CartActionButton extends StatelessWidget {
  final int count;
  final VoidCallback? onPressed;

  const _CartActionButton({required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.shopping_bag_outlined),
      tooltip: 'Корзина',
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        Positioned(
          right: 6,
          top: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            child: Text(
              '$count',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                height: 1,
              ),
            ),
          ),
        ),
      ],
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

  const _LoadedView({
    required this.state,
    required this.controller,
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
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = state.products[index];
                return _ProductCard(
                  product: product,
                  onTap: () => _openProductSheet(context, product),
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
  ) async {
    final selectedSize = await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => _ProductSheet(product: product),
    );

    if (product.hasSizes && selectedSize == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Товар добавлен')),
    );
  }
}

class _IntroBlock extends StatelessWidget {
  const _IntroBlock();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              'Каждый день тысячи девушек распаковывают пакеты с новинками '
              'Lichi и становятся счастливее, ведь очевидно, что новое платье '
              'может изменить день, а с ним и всю жизнь!',
              style: textTheme.bodyMedium?.copyWith(height: 1.35),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = context.select<ThemeCubit, bool>(
      (cubit) => cubit.state.mode == ThemeMode.dark,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: _ThemeCardButton(
              icon: Icons.nightlight_round,
              label: 'Темная тема',
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurface,
              isSelected: isDark,
              onTap: () => context.read<ThemeCubit>().setDark(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ThemeCardButton(
              icon: Icons.wb_sunny_outlined,
              label: 'Светлая тема',
              backgroundColor: colorScheme.inverseSurface,
              foregroundColor: colorScheme.onInverseSurface,
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
    final borderRadius = BorderRadius.circular(20);
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: backgroundColor,
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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: foregroundColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
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

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox(height: 8);

    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

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
          return InkWell(
            onTap: () => onSelected(category.code),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  category.title,
                  style:
                      (isSelected ? textTheme.titleSmall : textTheme.bodyMedium)
                          ?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 2,
                  width: isSelected ? 28 : 0,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
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
    final product = widget.product;
    final images = product.imageUrls.isNotEmpty
        ? product.imageUrls
        : const [''];

    return InkWell(
      onTap: widget.onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) =>
                        setState(() => _currentImagePage = index),
                    itemBuilder: (_, index) {
                      final imageUrl = images[index];
                      if (imageUrl.isEmpty) {
                        return const ColoredBox(color: Color(0x11000000));
                      }
                      return Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        loadingBuilder: (context, child, progress) =>
                            progress == null
                            ? child
                            : const ColoredBox(color: Color(0x11000000)),
                        errorBuilder: (_, _, _) =>
                            const ColoredBox(color: Color(0x11000000)),
                      );
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 8,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index == _currentImagePage
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.white70,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text('$price ₽', style: textTheme.titleMedium),
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
    final availableSizes = widget.product.sizes;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (availableSizes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final size in availableSizes)
                    ChoiceChip(
                      label: Text(size),
                      selected: _selectedSize == size,
                      onSelected: (_) => setState(() => _selectedSize = size),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (widget.product.hasSizes && _selectedSize == null) return;
                  Navigator.of(context).pop(_selectedSize);
                },
                child: const Text('Добавить'),
              ),
            ),
          ],
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
            FilledButton(onPressed: onRetry, child: const Text('Повторить')),
          ],
        ),
      ),
    ),
  );
}
