/// API ve repository işlemleri için result wrapper
sealed class Result<T> {
  const Result();
}

/// Başarılı sonuç
final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Hata sonucu
final class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  const Failure(this.message, [this.error]);
}

/// Result extension for pattern matching
extension ResultExtension<T> on Result<T> {
  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      final f = this as Failure<T>;
      return failure(f.message, f.error);
    }
  }

  /// Async version of when
  Future<R> whenAsync<R>({
    required Future<R> Function(T data) success,
    required Future<R> Function(String message, Object? error) failure,
  }) async {
    if (this is Success<T>) {
      return await success((this as Success<T>).data);
    } else {
      final f = this as Failure<T>;
      return await failure(f.message, f.error);
    }
  }
}
