import './api_keys.dart';
import 'package:flutter/foundation.dart';

class API {
  API({this.apiKey = ''});
  final String apiKey;

  factory API.sandbox() => API(apiKey: APIKeys.sterndeckKey);

  static final String host = 'api.openai.com';
  static final int port = 443;
  Uri completionUri = Uri(
    scheme: 'https',
    host: host,
    path: 'v1/completions',
  );
}
