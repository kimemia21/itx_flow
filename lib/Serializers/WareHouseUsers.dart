class WarehouseNames {
  int id;
  String username;
  String email;
  String phonenumber;
  int userTypeId;
  String userTypeName;
  String name;
  String location;
  String capacity;
  String rate;

  WarehouseNames(
      {required this.id,
      required this.username,
      required this.email,
      required this.phonenumber,
      required this.userTypeId,
      required this.userTypeName,
      required this.name,
      required this.location,
      required this.rate,
      required this.capacity});

  factory WarehouseNames.fromJson(Map<String, dynamic> json) {
    // json.forEach((key,value)=>
    // );
    return WarehouseNames(
      id: json['id'],
      username: json['username'] ?? "username",
      email: json['email'],
      phonenumber: json['phonenumber'],
      userTypeId: json['user_type_id'],
      userTypeName: json['user_type_name'],
      rate: json["wh_rate"],
      capacity: json["wh_capacity_kg"],
      location: json["wh_location"],
      name: json["wh_name"],
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
