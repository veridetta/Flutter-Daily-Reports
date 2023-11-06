import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:Daily_Report_DISKOMINFO/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TaskApi {
  var baseUrrl = "http://127.0.0.1:8000/";
  var url = "http://127.0.0.1:8000/api/tasks";
  //Uri(scheme: 'http', host: '127.0.0.1', port: 8000, path: '/api/reports');

  Future<List<Task>> findAll(String token, int page, int report_id) async {
    try {
      var response = await http.get(
        Uri.parse('$url/datas/$report_id'),
        headers: {
          'Authorization': 'Bearer $token', // Menambahkan header Authorization
          'Content-Type': 'application/json',
        },
      );
      //print("Request : " + response.request.toString()); // Log URL

      print("Response bodey: " + response.body.toString());

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        ApiData apiData = ApiData.fromJson(
            jsonResponse['data']); // Mengambil data dari ApiResponse
        print(apiData.data.toString());
        List<Task> reportList =
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

  Future<void> createTask(
    String token,
    int reportId,
    int userId,
    String division,
    String task,
    String description,
    Uint8List? imageBytes, // Tambahkan parameter imageBytes
  ) async {
    try {
      final Uri uri = Uri.parse(url);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['report_id'] = reportId.toString();
      request.fields['division'] = division;
      request.fields['task'] = task;
      request.fields['description'] = description;

      if (imageBytes != null) {
        // Tambahkan gambar ke permintaan sebagai MultipartFile
        request.files.add(
          http.MultipartFile.fromBytes(
            'image', // Nama field di server untuk gambar
            imageBytes,
            filename:
                'image.jpg', // Nama berkas gambar (bisa diganti sesuai kebutuhan)
          ),
        );
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        //final responseJson = await response.stream.bytesToString();
        //final Map<String, dynamic> jsonResponse = json.decode(responseJson);
        //final Map<String, dynamic> data = jsonResponse['data'];
        //return;
      } else {
        print("Create Report Error: ${response.statusCode}");
        throw Exception("Gagal membuat laporan baru");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Gagal membuat laporan baru");
    }
  }

  Future<void> updateTask(String token, int taskId, String division,
      String description, String task) async {
    try {
      final Map<String, dynamic> requestData = {
        'description': description,
        'task': task,
        'division': division,
      };

      final response = await http.put(
        Uri.parse('$url/$taskId'), // Sesuaikan dengan URL pembaruan
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        //sukses
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
