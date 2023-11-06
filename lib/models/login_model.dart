class LoginResponse {
  UserData user;
  String token;
  String status;
  String message;

  LoginResponse({
    required this.user,
    required this.token,
    required this.status,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserData.fromJson(json['data']['user']),
      token: json['data']['token'],
      status: json['status'],
      message: json['message'],
    );
  }
}

class UserData {
  int id;
  String name;
  String email;

  UserData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
