abstract class HttpClient {
  Future<HttpResponse> get(String url);
  Future<HttpResponse> post(String url, {Map<String, dynamic>? body});
  Future<HttpResponse> put(String url, {Map<String, dynamic>? body});
  Future<HttpResponse> delete(String url);
}

class HttpResponse {
  final int statusCode;
  final dynamic data;
  final Map<String, String> headers;

  const HttpResponse({
    required this.statusCode,
    required this.data,
    required this.headers,
  });
}
