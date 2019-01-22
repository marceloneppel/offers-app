class Result {
  final Object _data;
  final String _error;

  Result(this._data, this._error);

  bool isError() {
    return _error != null;
  }

  bool isOk() {
    return _error == null;
  }

  Object unwrap() {
    return _data;
  }

  Object unwrapError() {
    return _error;
  }
}
