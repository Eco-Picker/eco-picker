String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email address';
  }
  String pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }
  if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  }

  bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
  bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
  bool hasDigit = value.contains(RegExp(r'[0-9]'));
  bool hasSpecialCharacter = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  int count = 0;
  if (hasUpperCase) count++;
  if (hasLowerCase) count++;
  if (hasDigit) count++;
  if (hasSpecialCharacter) count++;

  if (count < 3) {
    return 'Password must contain at least 3 of the following: \nuppercase letter, lowercase letter, \nnumber, special character';
  }

  return null;
}
