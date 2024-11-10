class Checktext {
  static String? validateEmptyText(String? value, String valueName) {
    if (value!.isEmpty) {
      return 'Please enter your $value';
    }
    return null;
  }
}
