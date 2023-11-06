import 'package:Daily_Report_DISKOMINFO/pages/auth/report/create_report.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/report/update_report.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/task/task.dart';
import 'package:Daily_Report_DISKOMINFO/pages/unauth/login.dart';
import 'package:Daily_Report_DISKOMINFO/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:Daily_Report_DISKOMINFO/api/report_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<String?>? tokenFuture;

  @override
  void initState() {
    super.initState();
    tokenFuture = _loadToken();
  }

  Future<String?> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token') ?? "");
    return prefs.getString('token') ?? "";
  }

  @override
  Widget build(BuildContext context) {
    void navigateToCreateReport(String token) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateReportPage(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Laporan"),
        centerTitle: true,
        actions: [
          FutureBuilder<String?>(
            future: tokenFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final token = snapshot.data;
                return IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => navigateToCreateReport(token!),
                );
              } else {
                // Menampilkan indikator loading saat token masih dimuat
                return CircularProgressIndicator();
              }
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Logout"),
                value: 1,
              ),
            ],
            onSelected: (int menu) async {
              if (menu == 1) {
                final prefs = await SharedPreferences.getInstance();
                // Menghapus data token dari SharedPreferences
                await prefs.remove('token');
                // Mengalihkan ke LoginPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: FutureBuilder<String?>(
        future: tokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final token = snapshot.data;
            return ListPage(token: token!);
          } else {
            // Menampilkan indikator loading saat token masih dimuat
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  final String token; // Terima token sebagai parameter
  const ListPage({required this.token, super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final token = widget.token; // Mengambil token dari widget
    print("token page " + token);
    return MyList(token); // Mengirimkan token ke MyList
  }
}

MyList(String token) {
  return Padding(
      padding: EdgeInsets.all(10),
      child: FutureBuilder(
        future: ReportAPI()
            .findAll(token, 1), // Menggunakan token dalam pemanggilan API
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.date_range,
                    ),
                    title: Text(
                      "Date : ${snapshot.data![index].date ?? ''}",
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit), // Tambahkan ikon edit di sini
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateReportPage(
                              date: snapshot.data![index].date ?? '',
                              id: snapshot.data![index].id,
                              type: snapshot.data![index].type ?? '',
                              userId: snapshot.data![index].userId,
                              isUpdate:
                                  true, // Sesuaikan dengan kondisi saat mengedit
                            ),
                          ),
                        );
                      },
                    ),
                    subtitle: Text(
                      "Type : ${snapshot.data![index].type ?? ''}",
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(
                            reportId: snapshot.data![index]
                                .id, // Kirim report_id ke halaman TaskPage
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 60, left: 60),
                  child: LinearProgressIndicator(
                    backgroundColor: Color.fromARGB(0, 0, 0, 0),
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Loading, Please wait... "),
              ],
            ));
          }
        },
      ));
}
