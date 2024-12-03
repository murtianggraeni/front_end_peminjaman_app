// lib/controllers/notification_controller.dart

import 'dart:convert';

import 'package:get/get.dart';
import 'package:build_app/provider/api.dart';
import 'package:build_app/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotificationController extends GetxController {
  final ApiController _apiController = ApiController();
  final NotificationService _notificationService =
      Get.find<NotificationService>();

  final RxInt unreadCount = 0.obs;
  RxBool hasNotification = false.obs;
  RxList notifications = [].obs;

    @override
  void onInit() {
    super.onInit();
    loadUserNotifications();
  }


  Future<void> loadUserNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('user_notifications') ?? [];
      hasNotification.value = notifications.any((notif) {
        final data = json.decode(notif);
        return data['read'] == false;
      });
      unreadCount.value = notifications.where((notif) {
        final data = json.decode(notif);
        return data['read'] == false;
      }).length;
    } catch (e) {
      print('Error loading user notifications: $e');
    }
  }

  Future<void> handlePeminjamanStatus({
    required String peminjamanId,
    required String status,
    required String namaMesin,
    String? alasan,
  }) async {
    try {
      // Kirim ke API
      final response = await _apiController.sendStatusNotification(
        peminjamanId: peminjamanId,
        status: status,
        namaMesin: namaMesin,
        alasan: alasan,
      );

      if (response.statusCode == 200) {
        // Tampilkan notifikasi lokal
        await _notificationService.sendLocalNotification(
          title: status == 'Disetujui'
              ? 'Peminjaman Disetujui'
              : 'Peminjaman Ditolak',
          body: status == 'Disetujui'
              ? 'Peminjaman $namaMesin Anda telah disetujui'
              : 'Peminjaman $namaMesin Anda ditolak${alasan != null ? ': $alasan' : ''}',
          data: {
            'type': 'peminjaman_status',
            'peminjamanId': peminjamanId,
            'status': status,
            'namaMesin': namaMesin,
            if (alasan != null) 'alasan': alasan,
          },
        );

        // Update list notifikasi
        await loadUserNotifications;
      }
    } catch (e) {
      print('Error handling peminjaman status: $e');
    }
  }

  // Future<void> refreshNotifications() async {
  //   try {
  //     final response = await _apiController.getUserNotifications();
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       notifications.value = data['notifications'] ?? [];
  //       hasNotification.value = notifications.isNotEmpty;
  //     }
  //   } catch (e) {
  //     print('Error refreshing notifications: $e');
  //   }
  // }
}
