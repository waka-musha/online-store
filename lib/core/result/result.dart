import 'package:freezed_annotation/freezed_annotation.dart';
import '../failure/failure.dart';

part 'result.freezed.dart';

@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success({required T data}) = Success<T>;

  const factory Result.failure({required Failure failure}) = FailureResult<T>;
}

extension ResultX<T> on Result<T> {
  R match<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => when(success: onSuccess, failure: onFailure);
}
