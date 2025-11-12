part of 'catalog_bloc.dart';

@immutable
sealed class CatalogEvent {
  const CatalogEvent();
}

final class LoadCatalogEvent extends CatalogEvent {
  final String? preferredCategoryCode;

  const LoadCatalogEvent({this.preferredCategoryCode});
}

final class SelectCategoryEvent extends CatalogEvent {
  final String categoryCode;

  const SelectCategoryEvent({required this.categoryCode});
}

final class LoadNextPageEvent extends CatalogEvent {
  const LoadNextPageEvent();
}

final class RefreshCategoryEvent extends CatalogEvent {
  const RefreshCategoryEvent();
}
