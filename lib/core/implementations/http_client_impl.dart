import 'package:fudo_challenge/core/interfaces/http_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpClientImpl implements HttpClient {
  final http.Client client;

  HttpClientImpl(this.client);

  @override
  Future<HttpResponse> get(String url) async {
    final response = await client.get(Uri.parse(url));
    return _processResponse(response);
  }

  @override
  Future<HttpResponse> post(String url, {Map<String, dynamic>? body}) async {
    final response = await client.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _processResponse(response);
  }

  @override
  Future<HttpResponse> put(String url, {Map<String, dynamic>? body}) async {
    final response = await client.put(
      Uri.parse(url),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _processResponse(response);
  }

  @override
  Future<HttpResponse> delete(String url) async {
    final response = await client.delete(Uri.parse(url));
    return _processResponse(response);
  }

  HttpResponse _processResponse(http.Response response) {
    return HttpResponse(
      statusCode: response.statusCode,
      data: json.decode(response.body),
      headers: response.headers,
    );
  }
}
