/* 
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
 - Code Explanation: Creating the User class which corresponds to the database table User with corresponding variables.
 - Constructor createse an instance of user class allowing a new user to be inserted.
 - fromMap method creates a user object which allows retrieval of data from database as data is in form of a map
 - toMap method converts the user object into a Map<String, dynamic> which allows the updating or inserting of new records.
---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.---.
*/
class User {
  String? email;
  int? userId;
  String? username;
  String? password;
  DateTime? lastLogin;
  int emailNotifications = 0;
  String firstName = ' ';
  String lastName = ' ';

// User table constructor
  User({required this.email, this.userId, required this.username, required this.password, 
  this.lastLogin, required this.emailNotifications, required this.firstName, required this.lastName});
  
  User.fromMap(dynamic obj) { 
    email = obj['email'] ?? (throw ArgumentError('Email cannot be null'));
    userId = obj['userId']?? '';
    username = obj['username'];
    password = obj['password'];
    lastLogin = obj['lastLogin'] != null ? DateTime.parse(obj['lastLogin']) : null;
    emailNotifications = obj['emailNotifications'];
    firstName= obj['firstName'];
    lastName = obj['lastName'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'email': email,
      'userId': userId,
      'username': username,
      'password': password,
      'lastLogin': lastLogin?.toIso8601String(), // Convert DateTime to string
      'emailNotifications': emailNotifications,
      'firstName': firstName,
      'lastName': lastName,
    };
    return map;
  }
}