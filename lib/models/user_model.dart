class User {
  int? id;
  String name;
  int age;
  String role;
  String password;
  String uniquePairId;

  User({this.id, required this.name, required this.age, required this.role, required this.password, required this.uniquePairId});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'role': role, 'password': password, 'uniquePairId': uniquePairId};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      role: map['role'],
      password: map['password'],
      uniquePairId: map['uniquePairId'],
    );
  }
}
