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
  List<Report> data;
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
      data: List<Report>.from((json['data'] ?? [])
          .map((x) => Report.fromJson(x))), // Menggunakan list kosong jika null
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

class Report {
  int id;
  String date;
  String type;
  int userId;
  String createdAt;
  String updatedAt;

  Report({
    required this.id,
    required this.date,
    required this.type,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      date: json['date'],
      type: json['type'],
      userId: json['user_id'],
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
