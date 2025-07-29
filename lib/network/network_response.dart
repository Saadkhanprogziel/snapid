class NetworkResponse {
  String success;
  String message;
  dynamic data;
  bool failed;
  NetworkResponse({
    this.data,
    this.failed = false,
    this.message = "",
    this.success = "",
  });

  @override
  String toString() => message;
}
