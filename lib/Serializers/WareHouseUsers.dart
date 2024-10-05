class WarehouseNames {
  int id;
  String username;
  String email;
  String phonenumber;
  int userTypeId;
  String userTypeName;

  WarehouseNames({
    required this.id,
    required this.username,
    required this.email,
    required this.phonenumber,
    required this.userTypeId,
    required this.userTypeName,
  });

  factory WarehouseNames.fromJson(Map<String, dynamic> json) {
    return WarehouseNames(
      id: json['id'],
      username: json['username']??"username",
      email: json['email'],
      phonenumber: json['phonenumber'],
      userTypeId: json['user_type_id'],
      userTypeName: json['user_type_name'],
    );
  }

  
  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'username': username,
  //     'email': email,
  //     'phonenumber': phonenumber,
  //     'user_type_id': userTypeId,
  //     'user_type_name': userTypeName,
  //   };
  // }


}
