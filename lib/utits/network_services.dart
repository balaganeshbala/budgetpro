import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkCallService {
  static final instance = NetworkCallService._privateConstructor();

  static const _authHeader =
      "<AUTH_HEADER>"; // Replace it with the actual auth header value.

  NetworkCallService._privateConstructor();

  Future makeAPICall(String urlString) async {
    final url = Uri.parse(urlString);
    final headers = <String, String>{
      'Authorization': NetworkCallService._authHeader,
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedData = json.decode(response.body);
      return decodedData;
    } else {
      return null;
    }
  }

  Future makePostAPICall(String urlString, Map<String, dynamic> data) async {
    final url = Uri.parse(urlString);
    final headers = <String, String>{
      'Authorization': NetworkCallService._authHeader,
      'Content-Type': 'application/json; charset=UTF-8',
    };

    String jsonBody = json.encode(data);

    http.Response response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Map<String, dynamic> responseData = json.decode(response.body);
      return responseData;
    } else {
      return null;
    }
  }
}
