import 'dart:convert';
import 'package:Daily_Report_DISKOMINFO/models/report_model.dart';
import 'package:http/http.dart' as http;

class ReportAPI {
  var url = "http://127.0.0.1:8000/api/reports";
  //Uri(scheme: 'http', host: '127.0.0.1', port: 8000, path: '/api/reports');

  Future<List<Report>> findAll(String token, int page) async {
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan header Authorization
          'Content-Type': 'application/json',
        },
      );
      print("URL: $url"); // Log URL
      print("yoken " + token.toString());
      //print(response.body.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        ApiData apiData = ApiData.fromJson(
            jsonResponse['data']); // Mengambil data dari ApiResponse
        print(apiData.data.toString());
        List<Report> reportList =
            apiData.data; // Mengambil daftar Report dari ApiData
        return reportList;
      } else {
        print(
            "Response Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Gagal mengambil data personel dari API");
      }
    } catch (e) {
      print("Error: $e"); // Log error
      throw Exception("Gagal mengambil data personel dari API");
    }
  }

  Future<Report> createReport(
      String token, String date, String type, int userId) async {
    try {
      final Map<String, dynamic> requestData = {
        'date': date,
        'type': type,
        'user_id': userId,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> data = jsonResponse['data'];
        return Report.fromJson(data);
      } else {
        print(
            "Create Report Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Gagal membuat laporan baru");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Gagal membuat laporan baru");
    }
  }

  Future<Report> updateReport(
      String token, int reportId, String date, String type, int userId) async {
    try {
      final Map<String, dynamic> requestData = {
        'date': date,
        'type': type,
        'user_id': userId,
      };

      final response = await http.put(
        Uri.parse('$url/$reportId'), // Sesuaikan dengan URL pembaruan
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> data = jsonResponse['data'];
        return Report.fromJson(data);
      } else {
        print(
            "Update Report Error: ${response.statusCode} - ${response.reasonPhrase}");
        throw Exception("Gagal memperbarui laporan");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Gagal memperbarui laporan");
    }
  }
}
