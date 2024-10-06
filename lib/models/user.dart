class User {
  final String id;
  final String name;
  final String email;
  // Add any other user properties you need

  User({
    required this.id,
    required this.name,
    required this.email,
    // Add other required properties here
  });

  // Convert a User instance to a Map. Useful when inserting into the database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // Add other properties here
    };
  }

  // Create a User instance from a Map. Useful when retrieving from the database
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      // Add other properties here
    );
  }

  // Implement toString to make it easier to see information about
  // each user when using the print statement.
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email}';
  }
}