// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// // Plugin untuk local notifications
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // Channel configuration
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'peminjaman_channel',
//   'Peminjaman Notifications',
//   description: 'Notifikasi terkait peminjaman mesin',
//   importance: Importance.max,
//   playSound: true,
//   enableVibration: true,
//   showBadge: true,
// );

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Inisialisasi Firebase jika diperlukan
//   // await Firebase.initializeApp();

//   print('Handling a background message: ${message.messageId}');
//   print('Message data: ${message.data}');
//   print('Message notification: ${message.notification?.title}');

//   try {
//     // Extract message type and data
//     final String messageType = message.data['type'] ?? 'default';
//     final String peminjamanId = message.data['peminjamanId'] ?? '';
//     final String namaMesin = message.data['namaMesin'] ?? '';

//     // Create notification details
//     String notificationTitle = message.notification?.title ?? 'Notification';
//     String notificationBody = message.notification?.body ?? '';

//     // Customize notification based on message type
//     switch (messageType) {
//       case 'peminjaman_ending':
//         notificationTitle = 'Peminjaman Akan Berakhir';
//         notificationBody = 'Peminjaman $namaMesin akan berakhir dalam 5 menit';
//         break;

//       case 'time_reminder':
//         final String timeRemaining = message.data['timeRemaining'] ?? '0';
//         notificationTitle = 'Peringatan Waktu';
//         notificationBody =
//             'Peminjaman $namaMesin akan berakhir dalam $timeRemaining menit';
//         break;

//       case 'peminjaman_started':
//         notificationTitle = 'Peminjaman Dimulai';
//         notificationBody = 'Peminjaman $namaMesin telah dimulai';
//         break;

//       case 'peminjaman_ended':
//         notificationTitle = 'Peminjaman Selesai';
//         notificationBody = 'Peminjaman $namaMesin telah selesai';
//         break;
//     }

//     // Ensure notification channel exists
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     // Show notification
//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       notificationTitle,
//       notificationBody,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: true,
//           enableVibration: true,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('notification_sound'),
//           icon: '@mipmap/ic_launcher',
//           largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//           styleInformation: BigTextStyleInformation(notificationBody),
//         ),
//       ),
//       payload: json.encode({
//         'type': messageType,
//         'peminjamanId': peminjamanId,
//         'namaMesin': namaMesin,
//         'timeRemaining': message.data['timeRemaining'],
//       }),
//     );

//     // Handle specific actions based on message type
//     switch (messageType) {
//       case 'peminjaman_ending':
//       case 'time_reminder':
//         // Save notification to local storage for later reference
//         await _saveNotificationToStorage(message);

//         // Update app state if needed
//         await _updateAppState(message);
//         break;

//       case 'peminjaman_ended':
//         // Clean up any resources
//         await _cleanupPeminjaman(peminjamanId);
//         break;
//     }

//     print('Background notification processed successfully');
//   } catch (e, stackTrace) {
//     print('Error handling background message: $e');
//     print('Stack trace: $stackTrace');
//   }
// }

// // Helper function to save notification to local storage
// Future<void> _saveNotificationToStorage(RemoteMessage message) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final notifications = prefs.getStringList('notifications') ?? [];

//     notifications.add(json.encode({
//       'id': message.messageId,
//       'timestamp': DateTime.now().toIso8601String(),
//       'type': message.data['type'],
//       'peminjamanId': message.data['peminjamanId'],
//       'title': message.notification?.title,
//       'body': message.notification?.body,
//     }));

//     // Keep only last 50 notifications
//     if (notifications.length > 50) {
//       notifications.removeAt(0);
//     }

//     await prefs.setStringList('notifications', notifications);
//   } catch (e) {
//     print('Error saving notification: $e');
//   }
// }

// // Helper function to update app state
// Future<void> _updateAppState(RemoteMessage message) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final peminjamanId = message.data['peminjamanId'];

//     if (peminjamanId != null) {
//       // Save last notification time for this peminjaman
//       await prefs.setString(
//         'lastNotification_$peminjamanId',
//         DateTime.now().toIso8601String()
//       );

//       // Update notification count
//       final count = prefs.getInt('notificationCount_$peminjamanId') ?? 0;
//       await prefs.setInt('notificationCount_$peminjamanId', count + 1);
//     }
//   } catch (e) {
//     print('Error updating app state: $e');
//   }
// }

// // Helper function to clean up after peminjaman ends
// Future<void> _cleanupPeminjaman(String peminjamanId) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     // Remove peminjaman related data
//     await prefs.remove('lastNotification_$peminjamanId');
//     await prefs.remove('notificationCount_$peminjamanId');

//     // Clear any active notification flags
//     final activeNotifications =
//         prefs.getStringList('activeNotifications') ?? [];
//     activeNotifications.remove(peminjamanId);
//     await prefs.setStringList('activeNotifications', activeNotifications);
//   } catch (e) {
//     print('Error cleaning up peminjaman: $e');
//   }
// }

// // Initialize background handler
// Future<void> initializeBackgroundHandler() async {
//   // Set up local notifications
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) async {
//       if (response.payload != null) {
//         try {
//           final data = json.decode(response.payload!);
//           // Handle notification tap
//           print('Notification tapped with payload: $data');
//         } catch (e) {
//           print('Error handling notification tap: $e');
//         }
//       }
//     },
//   );

//   // Set up Firebase Messaging background handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// }

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Channel untuk notifikasi user
const AndroidNotificationChannel userChannel = AndroidNotificationChannel(
  'peminjaman_channel',
  'Peminjaman Notifications',
  description: 'Notifikasi terkait peminjaman mesin',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  showBadge: true,
);

// Channel khusus untuk notifikasi admin
const AndroidNotificationChannel adminChannel = AndroidNotificationChannel(
  'admin_peminjaman_channel',
  'Admin Peminjaman Notifications',
  description: 'Notifikasi untuk admin terkait peminjaman baru',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
  showBadge: true,
);

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    final String messageType = message.data['type'] ?? 'default';
    final String peminjamanId = message.data['peminjamanId'] ?? '';
    final String namaMesin = message.data['namaMesin'] ?? '';

    String notificationTitle = message.notification?.title ?? 'Notification';
    String notificationBody = message.notification?.body ?? '';
    AndroidNotificationChannel selectedChannel = userChannel;

    // Format notifikasi berdasarkan tipe
    switch (messageType) {
      // Notifikasi untuk user
      case 'peminjaman_ending':
        selectedChannel = userChannel;
        notificationTitle = 'Peminjaman Akan Berakhir';
        notificationBody = 'Peminjaman $namaMesin akan berakhir dalam 5 menit';
        break;

      case 'time_reminder':
        selectedChannel = userChannel;
        final String timeRemaining = message.data['timeRemaining'] ?? '0';
        notificationTitle = 'Peringatan Waktu';
        notificationBody =
            'Peminjaman $namaMesin akan berakhir dalam $timeRemaining menit';
        break;

      // Notifikasi untuk admin
      case 'new_peminjaman':
        selectedChannel = adminChannel;
        final String pemohon = message.data['pemohon'] ?? '';
        final String machineType = message.data['machineType'] ?? '';
        final String jurusan = message.data['jurusan'] ?? '';
        notificationTitle = 'Peminjaman Baru';
        notificationBody =
            'Pengajuan baru $machineType dari $pemohon ($jurusan)';
        break;
    }

    // Setup channel notifikasi
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(selectedChannel);

    // Tampilkan notifikasi
    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      notificationTitle,
      notificationBody,
      NotificationDetails(
        android: AndroidNotificationDetails(
          selectedChannel.id,
          selectedChannel.name,
          channelDescription: selectedChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          styleInformation: BigTextStyleInformation(
            notificationBody,
            htmlFormatContent: true,
            htmlFormatTitle: true,
          ),
        ),
      ),
      payload: json.encode(message.data),
    );

    // Simpan notifikasi ke storage berdasarkan tipe
    if (messageType == 'new_peminjaman') {
      await _saveAdminNotification(message);
    } else {
      await _saveUserNotification(message);
    }
  } catch (e, stackTrace) {
    print('Error handling background message: $e');
    print('Stack trace: $stackTrace');
  }
}

Future<void> _saveAdminNotification(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('admin_notifications') ?? [];

    notifications.add(json.encode({
      'id': message.messageId,
      'timestamp': DateTime.now().toIso8601String(),
      'type': 'new_peminjaman',
      'peminjamanId': message.data['peminjamanId'],
      'machineType': message.data['machineType'],
      'pemohon': message.data['pemohon'],
      'jurusan': message.data['jurusan'],
      'programStudi': message.data['programStudi'],
      'tanggalPeminjaman': message.data['tanggalPeminjaman'],
      'waktuMulai': message.data['waktuMulai'],
      'waktuSelesai': message.data['waktuSelesai'],
      'status': 'unread'
    }));

    if (notifications.length > 100) {
      notifications.removeAt(0);
    }

    await prefs.setStringList('admin_notifications', notifications);

    // Update unread count
    int currentCount = prefs.getInt('admin_unread_count') ?? 0;
    await prefs.setInt('admin_unread_count', currentCount + 1);
  } catch (e) {
    print('Error saving admin notification: $e');
  }
}

Future<void> _saveUserNotification(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final notifications = prefs.getStringList('user_notifications') ?? [];

    notifications.add(json.encode({
      'id': message.messageId,
      'timestamp': DateTime.now().toIso8601String(),
      'type': message.data['type'],
      'peminjamanId': message.data['peminjamanId'],
      'namaMesin': message.data['namaMesin'],
      'timeRemaining': message.data['timeRemaining'],
      'title': message.notification?.title,
      'body': message.notification?.body,
    }));

    if (notifications.length > 50) {
      notifications.removeAt(0);
    }

    await prefs.setStringList('user_notifications', notifications);
  } catch (e) {
    print('Error saving user notification: $e');
  }
}

// ------------------------------------------------------------------------------------------- //
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'peminjaman_channel',
//   'Peminjaman Notifications',
//   description: 'Notifikasi terkait peminjaman mesin',
//   importance: Importance.max,
//   playSound: true,
//   enableVibration: true,
//   showBadge: true,
// );

// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     final String messageType = message.data['type'] ?? 'default';
//     final String peminjamanId = message.data['peminjamanId'] ?? '';
//     final String namaMesin = message.data['namaMesin'] ?? '';

//     String notificationTitle = message.notification?.title ?? 'Notification';
//     String notificationBody = message.notification?.body ?? '';

//     // Customize notification based on message type
//     switch (messageType) {
//       case 'peminjaman_ending':
//         notificationTitle = 'Peminjaman Akan Berakhir';
//         notificationBody = 'Peminjaman $namaMesin akan berakhir dalam 5 menit';
//         break;
//       case 'time_reminder':
//         final String timeRemaining = message.data['timeRemaining'] ?? '0';
//         notificationTitle = 'Peringatan Waktu';
//         notificationBody =
//             'Peminjaman $namaMesin akan berakhir dalam $timeRemaining menit';
//         break;
//       case 'peminjaman_started':
//         notificationTitle = 'Peminjaman Dimulai';
//         notificationBody = 'Peminjaman $namaMesin telah dimulai';
//         break;
//       case 'peminjaman_ended':
//         notificationTitle = 'Peminjaman Selesai';
//         notificationBody = 'Peminjaman $namaMesin telah selesai';
//         break;
//     }

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     await flutterLocalNotificationsPlugin.show(
//       message.hashCode,
//       notificationTitle,
//       notificationBody,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: true,
//           enableVibration: true,
//           playSound: true,
//           icon: '@mipmap/ic_launcher',
//           styleInformation: BigTextStyleInformation(notificationBody),
//         ),
//       ),
//       payload: json.encode({
//         'type': messageType,
//         'peminjamanId': peminjamanId,
//         'namaMesin': namaMesin,
//         'timeRemaining': message.data['timeRemaining'],
//       }),
//     );

//     await _saveNotificationToStorage(message);
//     if (messageType == 'peminjaman_ended') {
//       await _cleanupPeminjaman(peminjamanId);
//     }

//   } catch (e, stackTrace) {
//     print('Error handling background message: $e');
//     print('Stack trace: $stackTrace');
//   }
// }

// Future<void> _saveNotificationToStorage(RemoteMessage message) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final notifications = prefs.getStringList('notifications') ?? [];

//     notifications.add(json.encode({
//       'id': message.messageId,
//       'timestamp': DateTime.now().toIso8601String(),
//       'type': message.data['type'],
//       'peminjamanId': message.data['peminjamanId'],
//       'title': message.notification?.title,
//       'body': message.notification?.body,
//     }));

//     if (notifications.length > 50) {
//       notifications.removeAt(0);
//     }

//     await prefs.setStringList('notifications', notifications);
//   } catch (e) {
//     print('Error saving notification: $e');
//   }
// }

// Future<void> _cleanupPeminjaman(String peminjamanId) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('lastNotification_$peminjamanId');
//     await prefs.remove('notificationCount_$peminjamanId');

//     final activeNotifications = prefs.getStringList('activeNotifications') ?? [];
//     activeNotifications.remove(peminjamanId);
//     await prefs.setStringList('activeNotifications', activeNotifications);
//   } catch (e) {
//     print('Error cleaning up peminjaman: $e');
//   }
// }

// ------------------------------------------------------------------------------------------- //
