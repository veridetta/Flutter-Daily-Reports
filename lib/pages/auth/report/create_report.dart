import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:Daily_Report_DISKOMINFO/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:Daily_Report_DISKOMINFO/api/report_api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReportPage extends StatefulWidget {
  CreateReportPage();

  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _date;
  late String _type;
  int _userId = 0;
  late String token; // Tambahkan variabel token
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi tanggal dengan hari ini
    _date = DateTime.now().toLocal().toIso8601String().split('T')[0];
    // Inisialisasi type dengan "Morning"
    _type = "Morning";
    // Ambil user_id dari provider
    _userId;

    // Ambil token dari SharedPreferences
    _loadToken();
  }

  void _completeCreate() {
    // Tampilkan pesan sukses dengan snackbar
    const snackBar = SnackBar(
      content: Text("Successfully created a report"),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HomePage(),
      ),
    );
  }

  void _failedCreate() {
    // Tampilkan pesan sukses dengan snackbar
    const snackBar = SnackBar(
      content: Text("Failed to create a report. Please try again."),
    );
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    setState(() {
      _userId = prefs.getInt('id') ?? 0;
    });
    print(_userId);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_userId == 0) {
        // Handle case where _userId is still 0 (not retrieved from SharedPreferences)
        print("User ID is not available. Please log in.");
        // Redirect to the login page or show an error message
      } else {
        // Set status loading sebelum mengirim permintaan
        setState(() {
          _isLoading = true;
        });

        try {
          final report =
              await ReportAPI().createReport(token, _date, _type, _userId);
          // Laporan berhasil dibuat
          setState(() {
            _isLoading = false;
          });
          _completeCreate();
          // Lalu, arahkan ke halaman sebelumnya atau lakukan yang sesuai
          // Contoh menggunakan Navigator.pop(context);
        } catch (e) {
          // Handle error saat membuat laporan gagal
          print("Error: $e");
          setState(() {
            _isLoading = false;
          });

          _failedCreate();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Report"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text("Date"),
                    trailing: Text(_date),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2030),
                      );

                      if (picked != null && picked != DateTime.now()) {
                        setState(() {
                          _date =
                              picked.toLocal().toIso8601String().split('T')[0];
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text("Type"),
                    trailing: DropdownButton<String>(
                      value: _type,
                      items:
                          <String>['Morning', 'Afternoon'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _type = newValue!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("User ID"),
                    trailing: Text("$_userId"),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text("Submit"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
