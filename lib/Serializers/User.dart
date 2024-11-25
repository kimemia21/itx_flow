class UserModel {
  int user_id;
  String user_email;
  int user_type;
  int authorized;
  String token;
  String user_type_name;

  UserModel({
    required this.user_id,
    required this.user_email,
    required this.user_type,
    required this.authorized,
    required this.token,
    required this.user_type_name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (value == null) {
        print('Null value found for key: $key');
      }
    });
    return UserModel(
      user_id: json['user_id'],
      user_email: json['user_email'],
      user_type: json['user_type'],
      authorized: json['authorized'],
      token: json['token'],
      user_type_name: json['user_type_name'],
    );
  }
}
