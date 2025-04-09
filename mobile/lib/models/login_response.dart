class LoginResponse {
  final String token;
  final String userName;
  // Add other fields as needed

  LoginResponse({required this.token, required this.userName});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userName: json['userName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userName': userName,
    };
  }
}