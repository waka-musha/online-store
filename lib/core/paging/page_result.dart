import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_result.freezed.dart';

@freezed
abstract class PageResult<T> with _$PageResult<T> {
  const factory PageResult({
    required List<T> items,
    required int page,
    required bool hasMore,
  }) = _PageResult<T>;
}
