class AppValidator {
  String? validateFirstName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your First Name';
    }
    return null;
  }

  String? validateLastName(value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Last Name';
    }
    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter your email';
    }
    RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  phoneNumberValidator(String? value) {
    RegExp regExp = RegExp(r'^07[0-9]{9}$');
    if (value?.isEmpty ?? true) {
      return "Please enter phone number!";
    } else if (!regExp.hasMatch(value!)) {
      return "Please enter a valid phone number starting with 07 and followed by 9 digits!";
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
