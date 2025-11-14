import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/failure/failure.dart';
import '../../../../../core/paging/page_result.dart';
import '../../../../../core/result/result.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repository/catalog_repository.dart';

part 'catalog_event.dart';

part 'catalog_state.dart';

final class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final CatalogRepository _repository;

  CatalogBloc({required CatalogRepository repository})
    : _repository = repository,
      super(const CatalogInitialState()) {
    on<LoadCatalogEvent>(_onLoadCatalog, transformer: sequential());
    on<SelectCategoryEvent>(_onSelectCategory, transformer: sequential());
    on<LoadNextPageEvent>(_onLoadNextPage, transformer: droppable());
    on<RefreshCategoryEvent>(_onRefreshCategory, transformer: restartable());
  }

  Future<void> _onLoadCatalog(
    LoadCatalogEvent event,
    Emitter<CatalogState> emit,
  ) async {
    emit(const CatalogLoadingState());

    final categoriesResult = await _repository.getCategories();
    Category? selected;
    var categories = const <Category>[];

    final categoriesOk = categoriesResult.match<List<Category>>(
      onSuccess: (data) => data,
      onFailure: (_) => const [],
    );

    categories = categoriesOk;

    if (event.preferredCategoryCode != null &&
        categories.any(
          (category) => category.code == event.preferredCategoryCode,
        )) {
      selected = categories.firstWhere(
        (category) => category.code == event.preferredCategoryCode,
      );
    } else if (categories.isNotEmpty) {
      selected = categories.first;
    }

    if (selected == null) {
      emit(
        const CatalogLoadedState(
          categories: [],
          selectedCategoryCode: '',
          products: [],
          page: 0,
          hasMore: false,
        ),
      );
      return;
    }

    final selectedCode = selected.code;
    final firstPageResult = await _loadFirstPage(selectedCode);

    firstPageResult.match(
      onSuccess: (PageResult<Product> page) {
        emit(
          CatalogLoadedState(
            categories: categories,
            selectedCategoryCode: selectedCode,
            products: page.items,
            page: page.page,
            hasMore: page.hasMore,
          ),
        );
      },
      onFailure: (fail) => emit(CatalogErrorState(failure: fail)),
    );
  }

  Future<void> _onSelectCategory(
    SelectCategoryEvent event,
    Emitter<CatalogState> emit,
  ) async {
    final current = state;

    if (current is CatalogLoadedState &&
        current.selectedCategoryCode == event.categoryCode) {
      return;
    }

    if (current is! CatalogLoadedState) {
      emit(const CatalogLoadingState());
    }

    final pageResult = await _loadFirstPage(event.categoryCode);

    pageResult.match(
      onSuccess: (PageResult<Product> page) {
        final categories = current is CatalogLoadedState
            ? current.categories
            : const <Category>[];

        emit(
          CatalogLoadedState(
            categories: categories,
            selectedCategoryCode: event.categoryCode,
            products: page.items,
            page: page.page,
            hasMore: page.hasMore,
          ),
        );
      },
      onFailure: (fail) => emit(CatalogErrorState(failure: fail)),
    );
  }

  Future<void> _onLoadNextPage(
    LoadNextPageEvent event,
    Emitter<CatalogState> emit,
  ) async {
    final current = state;
    if (current is! CatalogLoadedState) return;
    if (!current.hasMore || current.isLoadingMore) return;
    if (current.selectedCategoryCode.isEmpty) return;

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await _repository.getProducts(
      categoryCode: current.selectedCategoryCode,
      page: nextPage,
    );

    result.match(
      onSuccess: (PageResult<Product> page) {
        emit(
          current.copyWith(
            products: [...current.products, ...page.items],
            page: page.page,
            hasMore: page.hasMore,
            isLoadingMore: false,
          ),
        );
      },
      onFailure: (_) {
        emit(current.copyWith(isLoadingMore: false));
      },
    );
  }

  Future<void> _onRefreshCategory(
    RefreshCategoryEvent event,
    Emitter<CatalogState> emit,
  ) async {
    final current = state;
    if (current is! CatalogLoadedState) return;
    if (current.selectedCategoryCode.isEmpty) return;

    final result = await _loadFirstPage(current.selectedCategoryCode);

    result.match(
      onSuccess: (PageResult<Product> page) {
        emit(
          current.copyWith(
            products: page.items,
            page: 1,
            hasMore: page.hasMore,
          ),
        );
      },
      onFailure: (fail) => emit(CatalogErrorState(failure: fail)),
    );
  }

  Future<Result<PageResult<Product>>> _loadFirstPage(String categoryCode) =>
      _repository.getProducts(categoryCode: categoryCode, page: 1);
}
