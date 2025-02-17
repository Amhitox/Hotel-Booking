class User {
  String name;
  String email;
  String phone;
  String password;
  final String userType;
  DateTime lastLogin;

  User(
      {required this.name,
      required this.email,
      required this.password,
      this.phone = '00000000',
      required this.userType,
      required this.lastLogin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      userType: json['userType'],
      lastLogin: DateTime.parse(json['lastLogin']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'userType': userType,
        'lastLogin': lastLogin.toIso8601String(),
      };
}
