import 'dart:math';
import 'package:intl/intl.dart';

class VidalUtils {
  /// Generate a unique request ID with format: randomString-tbp-nrk-XXX
  static String generateRequestId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomString = _generateRandomString(8);
    final randomNumber = random.nextInt(999).toString().padLeft(3, '0');

    return "${randomString}${timestamp.toString().substring(8)}-tbp-nrk-$randomNumber";
  }

  /// Generate random string of specified length
  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }

  /// Get today's date in DD/MM/YYYY format
  static String getTodayDate() {
    final now = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(now);
  }

  /// Get date in DD/MM/YYYY format from DateTime
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Calculate age from date of birth
  static int calculateAge(String dob) {
    try {
      final dobDate = DateFormat('dd/MM/yyyy').parse(dob);
      final today = DateTime.now();
      int age = today.year - dobDate.year;
      if (today.month < dobDate.month ||
          (today.month == dobDate.month && today.day < dobDate.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  /// Generate enrollment ID for spouse
  static String generateSpouseEnrollmentId(String baseEnrollmentId) {
    return "${baseEnrollmentId}-S";
  }

  /// Generate enrollment ID for child
  static String generateChildEnrollmentId(
    String baseEnrollmentId,
    int childNumber,
  ) {
    return "${baseEnrollmentId}-C-$childNumber";
  }
}
