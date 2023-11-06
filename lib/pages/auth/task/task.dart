import 'package:Daily_Report_DISKOMINFO/api/tasks_api.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/report/create_report.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/report/update_report.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/task/create_task.dart';
import 'package:Daily_Report_DISKOMINFO/pages/auth/task/update_task.dart';
import 'package:Daily_Report_DISKOMINFO/pages/unauth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskPage extends StatefulWidget {
  final int reportId;

  TaskPage({
    required this.reportId,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Future<String?>? tokenFuture;
  late int _reportId;

  @override
  void initState() {
    super.initState();
    _reportId = widget.reportId;
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
          builder: (context) => CreateTaskPage(
            reportId: _reportId,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Task"),
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
            return ListPage(
              token: token!,
              reportIdFinal: _reportId,
            );
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
  final String token;
  final int reportIdFinal;

  ListPage({
    required this.token,
    required this.reportIdFinal,
  });

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    final token = widget.token;
    final reportId = widget.reportIdFinal;
    return MyList(token, reportId);
  }
}

Widget MyList(String token, int reportId) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: FutureBuilder(
      future: TaskApi().findAll(token, 1, reportId),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(
                    TaskApi().baseUrrl +
                            "storage/" +
                            snapshot.data![index].image ??
                        '',
                    width: 64, // Sesuaikan ukuran gambar sesuai kebutuhan
                    height: 64,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Divisi: ${snapshot.data![index].division ?? ''}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "To Do : ${snapshot.data![index].task ?? ''}",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "Description: ${snapshot.data![index].description ?? ''}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTaskPage(
                            division: snapshot.data![index].division,
                            id: snapshot.data![index].id,
                            description: snapshot.data![index].description,
                            task: snapshot.data![index].task,
                            isUpdate: true,
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    // Tindakan lain yang ingin Anda lakukan saat ListTile ditekan
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
                Text("Loading, Please wait..."),
              ],
            ),
          );
        }
      },
    ),
  );
}
