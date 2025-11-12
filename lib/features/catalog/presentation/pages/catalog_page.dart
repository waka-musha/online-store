import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failure/failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../bloc/catalog_bloc.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(const LoadCatalogEvent());
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    const threshold = 250;
    final max = _scroll.position.maxScrollExtent;
    final offset = _scroll.offset;
    if (max - offset <= threshold) {
      context.read<CatalogBloc>().add(const LoadNextPageEvent());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Каталог')),
    body: SafeArea(
      child: BlocBuilder<CatalogBloc, CatalogState>(
        buildWhen: (prev, next) =>
            prev.runtimeType != next.runtimeType || next is CatalogLoadedState,
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state) {
            CatalogInitialState() ||
            CatalogLoadingState() => const _CenteredLoader(),
            CatalogErrorState(failure: final fail) => _ErrorView(
              key: const ValueKey('catalog_error'),
              message: _failureToMessage(fail),
              onRetry: () =>
                  context.read<CatalogBloc>().add(const LoadCatalogEvent()),
            ),
            CatalogLoadedState() => _LoadedView(
              key: const ValueKey('catalog_loaded'),
              state: state,
              controller: _scroll,
            ),
          },
        ),
      ),
    ),
  );

  String _failureToMessage(Failure f) => f.when(
    network: (_, msg) => msg ?? 'Проблема с соединением',
    api: (_, msg) => msg ?? 'Ошибка сервера',
    parsing: (msg) => msg ?? 'Ошибка данных',
    empty: () => 'Пусто',
    unknown: (_, _) => 'Неизвестная ошибка',
  );
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
        SliverToBoxAdapter(
          child: _CategoryChips(
            categories: state.categories,
            selectedCode: state.selectedCategoryCode,
            onSelected: (code) => context.read<CatalogBloc>().add(
              SelectCategoryEvent(categoryCode: code),
            ),
          ),
        ),
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

  Future<void> _openProductSheet(BuildContext context, Product product) async {
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

class _CategoryChips extends StatelessWidget {
  final List<Category> categories;
  final String selectedCode;
  final ValueChanged<String> onSelected;

  const _CategoryChips({
    required this.categories,
    required this.selectedCode,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox(height: 8);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final category in categories)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category.title),
                  selected: category.code == selectedCode,
                  onSelected: (_) => onSelected(category.code),
                ),
              ),
          ],
        ),
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
  int _page = 0;

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
                    onPageChanged: (i) => setState(() => _page = i),
                    itemBuilder: (_, i) {
                      final url = images[i];
                      if (url.isEmpty) {
                        return const ColoredBox(color: Color(0x11000000));
                      }
                      return Image.network(
                        url,
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        loadingBuilder: (c, child, progress) => progress == null
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
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i == _page
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
    final style = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: style.bodyMedium,
        ),
        const SizedBox(height: 4),
        Text('$price ₽', style: style.titleMedium),
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
  String? _size;

  @override
  Widget build(BuildContext context) {
    final sizes = widget.product.sizes;
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
            if (sizes.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in sizes)
                    ChoiceChip(
                      label: Text(s),
                      selected: _size == s,
                      onSelected: (_) => setState(() => _size = s),
                    ),
                ],
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (widget.product.hasSizes && _size == null) return;
                  Navigator.of(context).pop(_size);
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
