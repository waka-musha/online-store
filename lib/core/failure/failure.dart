import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    int? statusCode,
    String? message,
  }) = NetworkFailure;

  const factory Failure.api({
    int? statusCode,
    String? message,
  }) = ApiFailure;

  const factory Failure.parsing({
    String? message,
  }) = ParsingFailure;

  const factory Failure.empty() = EmptyFailure;

  const factory Failure.unknown({
    Object? error,
    StackTrace? stackTrace,
  }) = UnknownFailure;
}
