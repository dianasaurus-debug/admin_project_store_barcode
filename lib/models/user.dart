class User {
  final String first_name;
  final String last_name;
  final String email;
  final int id;
  final String phone;
  final String photo_path;


  User(this.id, this.first_name,this.last_name,this.email, this.phone, this.photo_path);

  User.fromJson(Map<String, dynamic> json)
      : first_name = json['first_name'],
        id = json['id'],
        last_name = json['last_name'],
        email = json['email'],
        phone = json['phone'],
        photo_path = json['photo_path'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'first_name': first_name,
    'last_name': last_name,
    'email': email,
    'phone' : phone,
    'photo_path' : photo_path
  };
}