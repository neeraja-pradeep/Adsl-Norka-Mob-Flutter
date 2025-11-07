import 'package:flutter/material.dart';
import 'package:norkacare_app/services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  String _notificationMessage = '';
  bool _isImportant = false;
  bool _isLoading = false;
  String _errorMessage = '';

  String get notificationMessage => _notificationMessage;
  bool get isImportant => _isImportant;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  /// Fetch notification from API
  Future<void> fetchNotification() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await NotificationService.getNotification();
      
      if (response != null) {
        _notificationMessage = response['registration_info'] ?? '';
        _isImportant = response['is_important'] ?? false;
      } else {
        _notificationMessage = '';
        _isImportant = false;
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch notification';
      _isLoading = false;
      debugPrint('Error fetching notification: $e');
      notifyListeners();
    }
  }

  /// Clear notification data
  void clearData() {
    _notificationMessage = '';
    _isImportant = false;
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }
}

