import 'package:Daily_Report_DISKOMINFO/pages/auth/report/homepage.dart';
import 'package:Daily_Report_DISKOMINFO/pages/unauth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCheckerPage extends StatefulWidget {
  @override
  _AuthCheckerPageState createState() => _AuthCheckerPageState();
}

class _AuthCheckerPageState extends State<AuthCheckerPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    print(prefs.getString("token") ?? "Tidak ada");

    setState(() {
      _isLoading = false;
    });

    if (isLogin) {
      // Jika pengguna sudah login, arahkan ke HomePage
      _navigateToHomePage();
    } else {
      // Jika pengguna belum login, arahkan ke LoginPage
      _navigateToLoginPage();
    }
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Text("Checking login status..."),
      ),
    );
  }
}
