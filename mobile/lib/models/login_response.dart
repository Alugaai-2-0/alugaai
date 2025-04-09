class LoginResponse {
  final String token;
  final List<String> roles;
  final String email;
  final String userName;
  final String phoneNumber;
  final DateTime birthDate;
  final String gender;
  final String cpf;
  final bool phoneNumberConfirmed;
  final bool twoFactorEnabled;
  final DateTime createdDate;

  LoginResponse({
    required this.token,
    required this.roles,
    required this.email,
    required this.userName,
    required this.phoneNumber,
    required this.birthDate,
    required this.gender,
    required this.cpf,
    required this.phoneNumberConfirmed,
    required this.twoFactorEnabled,
    required this.createdDate,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      roles: List<String>.from(json['roles']),
      email: json['email'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      birthDate: DateTime.parse(json['birthDate']),
      gender: json['gender'],
      cpf: json['cpf'],
      phoneNumberConfirmed: json['phoneNumberConfirmed'],
      twoFactorEnabled: json['twoFactorEnabled'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'roles': roles,
      'email': email,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'birthDate': birthDate.toIso8601String(),
      'gender': gender,
      'cpf': cpf,
      'phoneNumberConfirmed': phoneNumberConfirmed,
      'twoFactorEnabled': twoFactorEnabled,
      'createdDate': createdDate.toIso8601String(),
    };
  }
}