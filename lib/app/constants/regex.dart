class AppRegex {
  const AppRegex._();

  static final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+");
  static final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$');
}

class EmailValidator {
  // Regex per una singola email

  /// Verifica se una singola email è valida
  static bool isValidEmail(String email) {
    return AppRegex.emailRegex.hasMatch(email.trim());
  }

  /// Verifica se uno o più indirizzi separati da ';' sono validi
  static bool areValidEmails(String input) {
    final List<String> emails = input.split(';');

    for (var email in emails) {
      email = email.trim();
      if (email.isEmpty) continue; // ignora entry vuote
      if (!isValidEmail(email)) return false; // se una email non è valida
    }

    return true; // tutte le email sono valide
  }

  /// Restituisce la lista delle email non valide
  static List<String> invalidEmails(String input) {
    final List<String> emails = input.split(';');
    final List<String> invalid = [];

    for (var email in emails) {
      email = email.trim();
      if (email.isEmpty) continue;
      if (!isValidEmail(email)) invalid.add(email);
    }

    return invalid;
  }
}
