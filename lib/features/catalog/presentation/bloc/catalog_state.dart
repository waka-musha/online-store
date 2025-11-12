part of 'catalog_bloc.dart';

@immutable
sealed class CatalogState {
  const CatalogState();
}

final class CatalogInitialState extends CatalogState {
  const CatalogInitialState();
}

final class CatalogLoadingState extends CatalogState {
  const CatalogLoadingState();
}

final class CatalogLoadedState extends CatalogState {
  final List<Category> categories;
  final String selectedCategoryCode;
  final List<Product> products;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const CatalogLoadedState({
    required this.categories,
    required this.selectedCategoryCode,
    required this.products,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
  });

  CatalogLoadedState copyWith({
    List<Category>? categories,
    String? selectedCategoryCode,
    List<Product>? products,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) => CatalogLoadedState(
    categories: categories ?? this.categories,
    selectedCategoryCode: selectedCategoryCode ?? this.selectedCategoryCode,
    products: products ?? this.products,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
  );
}

final class CatalogErrorState extends CatalogState {
  final Failure failure;

  const CatalogErrorState({required this.failure});
}
