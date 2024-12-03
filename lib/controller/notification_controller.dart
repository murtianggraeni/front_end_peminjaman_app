import 'dart:convert';

import 'package:get/get.dart';
import 'package:build_app/services/notification_services.dart';
import 'package:build_app/provider/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_app/services/logger.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService =
      Get.find<NotificationService>();
  final ApiController _apiController = ApiController();

  // Constants
  final int maxRetries = 3;
  static const String USER_NOTIFICATIONS_KEY = 'user_notifications';

  // Observable states
  final RxInt unreadCount = 0.obs;
  RxBool hasNotification = false.obs;
  RxList notifications = [].obs;
  final RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserNotifications();
    _setupNotificationListeners();
  }

  void _setupNotificationListeners() {
    // Listen for notification status changes
    ever(hasNotification, (_) {
      _saveNotificationState();
    });
  }

  void logWithTimestamp(String message) {
    final now = DateTime.now();
    final formattedTime = '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year} ${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}:'
        '${now.second.toString().padLeft(2, '0')}';
    LoggerService.debug('[$formattedTime] : $message');
  }

  Future<void> loadUserNotifications() async {
    try {
      logWithTimestamp("Loading user notifications...");
      final prefs = await SharedPreferences.getInstance();
      final savedNotifications =
          prefs.getStringList(USER_NOTIFICATIONS_KEY) ?? [];

      notifications.value =
          savedNotifications.map((notif) => json.decode(notif)).toList();

      _updateNotificationCounts();

      logWithTimestamp(
          "Loaded ${notifications.length} notifications, ${unreadCount.value} unread");
    } catch (e) {
      LoggerService.error('Error loading user notifications: $e');
    }
  }

  void _updateNotificationCounts() {
    unreadCount.value =
        notifications.where((notif) => notif['read'] == false).length;
    hasNotification.value = unreadCount.value > 0;
  }

  Future<void> _saveNotificationState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationStrings =
          notifications.map((n) => json.encode(n)).toList();
      await prefs.setStringList(USER_NOTIFICATIONS_KEY, notificationStrings);
      logWithTimestamp("Notification state saved successfully");
    } catch (e) {
      LoggerService.error('Error saving notification state: $e');
    }
  }

  Future<bool> checkPeminjaman(String peminjamanId) async {
    if (isProcessing.value) {
      logWithTimestamp("Another check is in progress, skipping...");
      return false;
    }

    isProcessing.value = true;
    int attempts = 0;

    try {
      while (attempts < maxRetries) {
        try {
          logWithTimestamp(
              "Checking peminjaman notification: Attempt ${attempts + 1}");

          final response =
              await _apiController.checkPeminjamanNotification(peminjamanId);

          if (response.statusCode == 200) {
            final responseData = json.decode(response.body);

            // Handle successful check
            if (responseData['success'] == true) {
              logWithTimestamp(
                  "Successfully checked notification for peminjaman: $peminjamanId");

              // Add local notification as backup
              await _notificationService.sendLocalNotification(
                title: 'Peminjaman Akan Berakhir',
                body: 'Peminjaman Anda akan berakhir dalam 5 menit',
                data: {
                  'type': 'peminjaman_ending',
                  'peminjamanId': peminjamanId,
                  'timeRemaining': '5',
                },
                isAdmin: false,
              );

              return true;
            }
          }

          attempts++;
          if (attempts < maxRetries) {
            logWithTimestamp("Retrying in ${2 * attempts} seconds...");
            await Future.delayed(Duration(seconds: 2 * attempts));
          }
        } catch (e) {
          LoggerService.error('Error on attempt $attempts: $e');
          attempts++;
          if (attempts >= maxRetries) rethrow;
          await Future.delayed(Duration(seconds: 2 * attempts));
        }
      }

      return false;
    } catch (e) {
      LoggerService.error('Final error checking notification: $e');
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> handlePeminjamanEnding({
    required String peminjamanId,
    required String namaMesin,
  }) async {
    try {
      logWithTimestamp(
          "Handling peminjaman ending notification for: $peminjamanId");

      // Try server notification first
      final success = await checkPeminjaman(peminjamanId);

      // Always show local notification as backup
      await _notificationService.sendLocalNotification(
        title: 'Peminjaman Akan Berakhir',
        body: 'Peminjaman $namaMesin akan berakhir dalam 5 menit',
        data: {
          'type': 'peminjaman_ending',
          'peminjamanId': peminjamanId,
          'namaMesin': namaMesin,
          'timeRemaining': '5',
        },
        isAdmin: false,
      );

      // Add to notifications list
      final newNotification = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': 'Peminjaman Akan Berakhir',
        'body': 'Peminjaman $namaMesin akan berakhir dalam 5 menit',
        'type': 'peminjaman_ending',
        'peminjamanId': peminjamanId,
        'read': false,
        'timestamp': DateTime.now().toIso8601String(),
      };

      notifications.insert(0, newNotification);
      _updateNotificationCounts();
      await _saveNotificationState();

      logWithTimestamp(
          "Successfully handled ending notification for: $peminjamanId");
    } catch (e) {
      LoggerService.error('Error handling peminjaman ending: $e');
      rethrow;
    }
  }

  @override
  void onClose() {
    _saveNotificationState();
    super.onClose();
  }
}
