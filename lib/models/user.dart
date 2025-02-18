class CustomUser {
  String name;
  String email;
  String phone;
  String password;
  String userType;
  DateTime lastLogin;

  CustomUser(
      {this.name = 'name',
      this.email = 'email',
      this.password = 'password',
      this.phone = '00000000',
      this.userType = 'guest',
      DateTime? lastLogin})
      : lastLogin = lastLogin ?? DateTime.now();

  factory CustomUser.fromJson(Map<String, dynamic> json) {
    return CustomUser(
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
