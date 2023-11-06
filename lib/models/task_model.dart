class ApiResponse {
  String status;
  String message;
  ApiData data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      data: ApiData.fromJson(json['data']),
    );
  }
}

class ApiData {
  int currentPage;
  List<Task> data;
  String firstPageUrl;
  int from;
  int lastPage;
  String lastPageUrl;
  List<ApiLink> links;
  String nextPageUrl = "";
  String path;
  int perPage;
  String prevPageUrl = "";
  int to;
  int total;

  ApiData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    required this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.prevPageUrl,
    required this.to,
    required this.total,
  });

  factory ApiData.fromJson(Map<String, dynamic> json) {
    return ApiData(
      currentPage:
          json['current_page'] ?? 0, // Menggunakan nilai default jika null
      data: List<Task>.from((json['data'] ?? [])
          .map((x) => Task.fromJson(x))), // Menggunakan list kosong jika null
      firstPageUrl:
          json['first_page_url'] ?? "", // Menggunakan string kosong jika null
      from: json['from'] ?? 0, // Menggunakan nilai default jika null
      lastPage: json['last_page'] ?? 0, // Menggunakan nilai default jika null
      lastPageUrl:
          json['last_page_url'] ?? "", // Menggunakan string kosong jika null
      links: List<ApiLink>.from((json['links'] ?? []).map(
          (x) => ApiLink.fromJson(x))), // Menggunakan list kosong jika null
      nextPageUrl:
          json['next_page_url'] ?? "", // Menggunakan string kosong jika null
      path: json['path'] ?? "", // Menggunakan string kosong jika null
      perPage: json['per_page'] ?? 0, // Menggunakan nilai default jika null
      prevPageUrl:
          json['prev_page_url'] ?? "", // Menggunakan string kosong jika null
      to: json['to'] ?? 0, // Menggunakan nilai default jika null
      total: json['total'] ?? 0, // Menggunakan nilai default jika null
    );
  }
}

class Task {
  final int id;
  final int reportId;
  final String division;
  final String task;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  Task({
    required this.id,
    required this.reportId,
    required this.division,
    required this.task,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      reportId: json['report_id'],
      division: json['division'],
      task: json['task'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ApiLink {
  String? url = "";
  String label;
  bool active;

  ApiLink({
    this.url,
    required this.label,
    required this.active,
  });

  factory ApiLink.fromJson(Map<String, dynamic> json) {
    return ApiLink(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
