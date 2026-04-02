extension Validators on String {
  String? validateEmail() =>
      RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,}))$',
      ).hasMatch(this)
      ? null
      : 'Invalid Email Address';
  String? hasUppercase() => RegExp('(?=.*?[A-Z])').hasMatch(this)
      ? null
      : 'Must contain an uppercase letter';
  String? hasLowerCase() =>
      RegExp('[a-z]').hasMatch(this) ? null : 'Must contain a lowercase letter';
  String? hasDigit() =>
      RegExp('.*?[0-9]').hasMatch(this) ? null : 'Must contain a digit';
  String? hasEightCharacters() => RegExp(r'^.{8,}$').hasMatch(this)
      ? null
      : 'Must be at least 8 characters';
  String? hasSpecialCharacter() => RegExp(r'[!@#$%^&*]').hasMatch(this)
      ? null
      : 'Must include a special character';
  String? validatePassword() {
    if (length < 8) {
      return 'Your password must be at least 8 characters long';
    } else {
      final regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$%^&*]).{8,}$',
      );
      if (!regex.hasMatch(this)) {
        return '''Your password must contain at least one uppercase, one lowercase letter, one number, and one special character''';
      }
      return null;
    }
  }

  String? validateConfirmPassword(String password) {
    if (this != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
