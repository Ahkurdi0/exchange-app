class AppValidator {
  String? validateUserName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhoneNumber(value) {
    if (value.isEmpty) {
      return 'Please enter your phone number';
    }
    if (value.length != 10) {
      return 'Please enter a 10-digital phone number';
    }
    return null;
  }

  String? validatePassword(value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  String? isEmptyCheak(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null; // means validation passed
  }

  String? reciverCheak(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an Phone Number';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null; // means validation passed
  }
}
