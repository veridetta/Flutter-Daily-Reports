import 'package:Daily_Report_DISKOMINFO/api/tasks_api.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:flutter/material.dart';
import 'package:Daily_Report_DISKOMINFO/api/report_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateTaskPage extends StatefulWidget {
  final String division;
  final int id;
  final String description;
  final String task;
  final bool isUpdate;

  UpdateTaskPage({
    required this.division,
    required this.id,
    required this.description,
    required this.task,
    this.isUpdate = false,
  });

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _division;
  late int _id;
  late String _description;
  late String _task;
  late String token;
  int _userId = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _division = widget.division;
    _id = widget.id;
    _description = widget.description;
    _task = widget.task;
    _userId = 0;
    _loadToken();
  }

  void _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    setState(() {
      _userId = prefs.getInt('id') ?? 0;
    });
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
          final report = widget.isUpdate
              ? await TaskApi()
                  .updateTask(token, _id, _division, _description, _task)
              : "";

          setState(() {
            _isLoading = false;
          });

          _completeAction(widget.isUpdate);
        } catch (e) {
          print("Error: $e");
          setState(() {
            _isLoading = false;
          });

          _failedAction(widget.isUpdate);
        }
      }
    }
  }

  void _completeAction(bool isUpdate) {
    final action = isUpdate ? 'updated' : 'created';
    final snackBar = SnackBar(
      content: Text("Successfully $action a report"),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (isUpdate) {
      // Redirect to the homepage after a successful update
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomePage(),
        ),
      );
    }
  }

  void _failedAction(bool isUpdate) {
    final action = isUpdate ? 'update' : 'create';
    final snackBar = SnackBar(
      content: Text("Failed to $action a report. Please try again."),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? "Update Report" : "Create Report"),
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
                    initialValue: _description,
                    onSaved: (value) {
                      _description = value ?? "";
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: Text(widget.isUpdate ? "Update" : "Submit"),
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
