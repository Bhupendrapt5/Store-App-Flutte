import 'dart:convert';

class UserModel {
  final String email;
  final String password;

  UserModel({
    this.email,
    this.password,
  });

  String toJsonForSignUp()=> json.encode({
    'email':email,
    'password':password,
    'returnSecureToken':true,
  });
}
