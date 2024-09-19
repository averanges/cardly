String? emailValidation(String? email) {
  if (email == null || email.isEmpty) {
    return 'E-mail address is required.';
  } else if (!RegExp(r"^[a-zA-Z0-9._-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email)) {
    return 'Please enter a valid e-mail address.';
  }
  return null;
}

String? passwordValidation(String? psw) {
  if (psw == null || psw.isEmpty) {
    return 'Please, type in your password.';
  } else if (psw.length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

String? nameValidation(String? name) {
  if (name != null && name.length < 4) {
    return 'Please, add more characters to chosen name. At least 4 characters.';
  }
  return null;
}

String? confirmPasswordValidation(String? confirmPsw, String password) {
  if (confirmPsw == null || confirmPsw.isEmpty) {
    return 'Please confirm your password.';
  } else if (confirmPsw != password) {
    return 'Passwords do not match.';
  }
  return null;
}
