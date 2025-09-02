// domain/user.dart
class User {
  final String id;
  final String name;
  //final String email;
  //final String city;

  //User({required this.id, required this.name, required this.email, required this.city});
  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      //email: json['email'] ?? '',
      //city: json['city'] ?? '',
    );
  }
}
