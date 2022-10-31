import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class NetworkClient extends http.BaseClient {
  NetworkClient();

  final _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    developer.log(
      'Start requesting to ${request.url}',
    );

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();

    super.close();
  }
}
