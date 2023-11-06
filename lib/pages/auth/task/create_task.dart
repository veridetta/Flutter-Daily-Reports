import 'dart:io';
import 'dart:typed_data';

import 'package:Daily_Report_DISKOMINFO/api/tasks_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart'; // Impor file_picker

import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTaskPage extends StatefulWidget {
  final int reportId;

  CreateTaskPage({required this.reportId});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _division = "Umum";
  String _task = "No Task";
  late String _description;
  late int _reportId;
  int _userId = 0;
  late String token;
  bool _isLoading = false;
  File? _image; // Menggunakan PlatformFile dari file_picker
  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    _reportId = widget.reportId;
    // Inisialisasi tanggal dengan hari ini
    // Ambil user_id dari provider
    _userId;

    // Ambil token dari SharedPreferences
    _loadToken();
  }

  void _completeCreate() {
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
        print("User ID is not available. Please log in.");
      } else {
        setState(() {
          _isLoading = true;
        });

        try {
          final task = await TaskApi().createTask(
            token,
            _reportId,
            _userId,
            _division,
            _task,
            _description,
            _imageBytes, // Mengirim PlatformFile sebagai gambar
          );

          setState(() {
            _isLoading = false;
          });
          _completeCreate();
        } catch (e) {
          print("Error: $e");
          setState(() {
            _isLoading = false;
          });

          _failedCreate();
        }
      }
    }
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _imageBytes = result.files.first.bytes!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
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
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      labelText: "Division",
                    ),
                    value: _division,
                    onChanged: (String? newValue) {
                      setState(() {
                        _division = newValue ?? "";
                      });
                    },
                    items:
                        <String>['Umum', 'Publik', 'E-Gov'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      icon: Icon(Icons.assignment),
                      labelText: "Task",
                    ),
                    value: _task,
                    onChanged: (String? newValue) {
                      setState(() {
                        _task = newValue ?? "";
                      });
                    },
                    items: <String>['No Task', 'Belum', 'Selesai']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.description),
                      labelText: "Description",
                    ),
                    onSaved: (value) {
                      _description = value ?? "";
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text("Pick an Image"),
                  ),
                  if (_image != null)
                    if (_imageBytes != null)
                      Image.memory(
                        _imageBytes,
                        width: 100,
                        height: 100,
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
