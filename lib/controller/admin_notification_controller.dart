import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AdminNotificationController extends GetxController {
  final RxInt unreadCount = 0.obs;
  final RxList notifications = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifList = prefs.getStringList('admin_notifications') ?? [];
      notifications.value = notifList.map((str) => json.decode(str)).toList();
      unreadCount.value = prefs.getInt('admin_unread_count') ?? 0;
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('admin_unread_count', 0);
      unreadCount.value = 0;

      final List<String> currentNotifs =
          prefs.getStringList('admin_notifications') ?? [];
      final updatedNotifs = currentNotifs.map((notifStr) {
        final notif = json.decode(notifStr);
        notif['status'] = 'read';
        return json.encode(notif);
      }).toList();

      await prefs.setStringList('admin_notifications', updatedNotifs);
      await loadNotifications();
    } catch (e) {
      print('Error marking notifications as read: $e');
    }
  }
}
