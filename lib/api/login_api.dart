import 'dart:convert';
import 'package:Daily_Report_DISKOMINFO/models/login_model.dart';
import 'package:http/http.dart' as http;

class LoginAPI {
  var url =
      Uri(scheme: 'http', host: '127.0.0.1', port: 8000, path: '/api/login');

  Future<LoginResponse> login(String email, String password) async {
    try {
      final Map<String, dynamic> requestData = {
        'email': email,
        'password': password,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        return LoginResponse.fromJson(jsonResponse);
      } else {
        print("Login Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Gagal login");
      }
    } catch (e) {
      print("Error: $e"); // Log error
      throw Exception("Gagal melakukan login");
    }
  }
}
