import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:Daily_Report_DISKOMINFO/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:Daily_Report_DISKOMINFO/api/report_api.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateReportPage extends StatefulWidget {
  final String date;
  final int id;
  final String type;
  final int userId;
  final bool isUpdate;

  UpdateReportPage({
    required this.id,
    required this.date,
    required this.type,
    required this.userId,
    this.isUpdate = false,
  });

  @override
  _UpdateReportPageState createState() => _UpdateReportPageState();
}

class _UpdateReportPageState extends State<UpdateReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _date;
  late int _id;
  late String _type;
  late int _userId;
  late String token;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _date = widget.date;
    _type = widget.type;
    _userId = widget.userId;
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
              ? await ReportAPI()
                  .updateReport(token, _id, _date, _type, _userId)
              : await ReportAPI().createReport(token, _date, _type, _userId);

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
