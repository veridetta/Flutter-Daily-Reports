import 'package:Daily_Report_DISKOMINFO/api/login_api.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String statusMessage = "";
  bool _isLoading = false;
  void _completeLogin() {
    Navigator.pushReplacement<void, void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const HomePage(),
      ),
    );
  }

  Future<void> _performLogin() async {
    final username = usernameController.text;
    final password = passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final loginResponse = await LoginAPI().login(username, password);

      if (loginResponse.status == "success") {
        statusMessage = "Login berhasil!";
        final token = loginResponse.token;

        if (token != "") {
          // Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setInt('id', loginResponse.user.id);
          await prefs.setString('email', loginResponse.user.email);
          await prefs.setString('name', loginResponse.user.name);
          await prefs.setBool('isLogin', true);
          _completeLogin();
        } else {
          statusMessage = "Token kosong";
        }
      } else {
        statusMessage = "Login gagal. ${loginResponse.message}";
      }
    } catch (e) {
      statusMessage = "Gagal melakukan login. ${e.toString()}";
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/logo.png', width: 100.0, height: 100.0),
                Text(
                  "Daily Report DISKOMINFO",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _isLoading ? null : _performLogin,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text("Login"),
                ),
                SizedBox(height: 16.0),
                Text(
                  statusMessage,
                  style: TextStyle(
                    color: statusMessage.contains("gagal")
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
