class UserModel {
  String uid;
  String email;
  String? _userName;

  UserModel({required this.uid, required this.email});

  String get userName => _userName ?? '';

  set userName(String value) {
    _userName = value;
  }

  void clearUserModel() {
    _userName = '';
    email = '';
    uid = '';
  }
}
