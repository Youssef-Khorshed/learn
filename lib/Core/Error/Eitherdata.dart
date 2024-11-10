class FetchResult<T, E> {
  final T? value;
  final E? error;

  FetchResult.success(this.value) : error = null;
  FetchResult.error(this.error) : value = null;

  // Method to fold over the Result
  R fold<R>(R Function(E error) onError, R Function(T value) onSuccess) {
    if (error != null) {
      return onError(error as E);
    } else {
      return onSuccess(value as T);
    }
  }
}
