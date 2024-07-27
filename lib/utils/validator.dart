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
