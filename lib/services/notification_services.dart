import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:build_app/provider/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:build_app/services/firebase_messaging_handler.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final ApiController _apiController = ApiController();

  // State management
  final RxBool isInitialized = false.obs;
  final RxInt unreadCount = 0.obs;
  final RxBool hasNewNotifications = false.obs;

  // Timer management
  final Map<String, Timer> _notificationTimers = {};
  final Map<String, Timer> _reminderTimers = {};

  // Role management
  final RxString userRole = ''.obs;

  Future<NotificationService> init() async {
    try {
      await _setupInitialConfig();
      isInitialized.value = true;
      return this;
    } catch (e) {
      print('Error initializing NotificationService: $e');
      rethrow;
    }
  }

  Future<void> _setupInitialConfig() async {
    await _requestPermissions();
    await _initializeLocalNotifications();
    await _setupFirebaseMessaging();
    await _loadUserRole();
    await _loadUnreadCount();
  }

  Future<void> _requestPermissions() async {
    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      criticalAlert: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    // User channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(userChannel);

    // Admin channel
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(adminChannel);
  }

  Future<void> _setupFirebaseMessaging() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Background messages already handled by firebaseMessagingBackgroundHandler

    // App opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Update FCM token
    await _updateFcmToken();
  }

  void _handleNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = json.decode(response.payload!);
        _navigateBasedOnNotification(data);
      } catch (e) {
        print('Error handling notification response: $e');
      }
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Got a message in foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      final selectedChannel =
          message.data['type'] == 'new_peminjaman' ? adminChannel : userChannel;

      await _showLocalNotification(
        message.notification!.title ?? 'Notification',
        message.notification!.body ?? '',
        message.data,
        selectedChannel,
      );
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print('Message opened app: ${message.messageId}');
    if (message.data.isNotEmpty) {
      _navigateBasedOnNotification(message.data);
    }
  }

  Future<void> _showLocalNotification(
    String title,
    String body,
    Map<String, dynamic> data,
    AndroidNotificationChannel channel,
  ) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
        ),
        payload: json.encode(data),
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  void _navigateBasedOnNotification(Map<String, dynamic> data) {
    final String type = data['type'] ?? '';
    final String peminjamanId = data['peminjamanId'] ?? '';

    switch (type) {
      case 'new_peminjaman':
        if (userRole.value == 'admin') {
          Get.toNamed('/admin/peminjaman/$peminjamanId');
        }
        break;
      case 'peminjaman_ending':
      case 'time_reminder':
        Get.toNamed('/peminjaman/$peminjamanId');
        break;
    }
  }

  Future<void> _updateFcmToken() async {
    try {
      final String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _apiController.updateFcmToken(token);

        _firebaseMessaging.onTokenRefresh.listen((newToken) async {
          await _apiController.updateFcmToken(newToken);
        });
      }
    } catch (e) {
      print('Error updating FCM token: $e');
    }
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    userRole.value = prefs.getString('user_role') ?? '';
  }

  Future<void> _loadUnreadCount() async {
    final prefs = await SharedPreferences.getInstance();
    if (userRole.value == 'admin') {
      unreadCount.value = prefs.getInt('admin_unread_count') ?? 0;
    }
  }

  void startPeminjamanCheck(
      String peminjamanId, DateTime endTime, String namaMesin) {
    stopPeminjamanCheck(peminjamanId);

    final now = DateTime.now();
    final reminderTime = endTime.subtract(Duration(minutes: 5));

    if (now.isBefore(reminderTime)) {
      _notificationTimers[peminjamanId] = Timer(
        reminderTime.difference(now),
        () => _sendPeminjamanEndingNotification(peminjamanId, namaMesin),
      );
    }
  }

  // Future<void> _sendPeminjamanEndingNotification(
  //     String peminjamanId, String namaMesin) async {
  //   await _apiController.checkPeminjamanNotification(peminjamanId);
  // }

  void stopPeminjamanCheck(String peminjamanId) {
    _notificationTimers[peminjamanId]?.cancel();
    _reminderTimers[peminjamanId]?.cancel();
    _notificationTimers.remove(peminjamanId);
    _reminderTimers.remove(peminjamanId);
  }

  // Method public untuk mengirim notifikasi lokal
  Future<void> sendLocalNotification({
    required String title,
    required String body,
    required Map<String, dynamic> data,
    bool isAdmin = false,
  }) async {
    try {
      final selectedChannel = isAdmin ? adminChannel : userChannel;
      await _showLocalNotification(
        title,
        body,
        data,
        selectedChannel,
      );
    } catch (e) {
      print('Error sending local notification: $e');
    }
  }

// Method public untuk mengirim notifikasi peminjaman akan berakhir
  Future<void> sendPeminjamanEndingNotification({
    required String peminjamanId,
    required String namaMesin,
  }) async {
    try {
      await _apiController.checkPeminjamanNotification(peminjamanId);

      await sendLocalNotification(
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
    } catch (e) {
      print('Error sending peminjaman ending notification: $e');
    }
  }

// Method public untuk mengirim notifikasi reminder waktu
  Future<void> sendTimeReminderNotification({
    required String peminjamanId,
    required String namaMesin,
    required int remainingMinutes,
  }) async {
    try {
      await sendLocalNotification(
        title: 'Peringatan Waktu',
        body:
            'Peminjaman $namaMesin akan berakhir dalam $remainingMinutes menit',
        data: {
          'type': 'time_reminder',
          'peminjamanId': peminjamanId,
          'namaMesin': namaMesin,
          'timeRemaining': remainingMinutes.toString(),
        },
        isAdmin: false,
      );
    } catch (e) {
      print('Error sending time reminder notification: $e');
    }
  }

// Update method _sendPeminjamanEndingNotification
  Future<void> _sendPeminjamanEndingNotification(
      String peminjamanId, String namaMesin) async {
    await sendPeminjamanEndingNotification(
      peminjamanId: peminjamanId,
      namaMesin: namaMesin,
    );
  }

  Future<void> setupUserNotifications({
    Function? onStatusChange,
    Function? onPeminjamanEnding,
  }) async {
    try {
      // Listen untuk pesan foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.data['type'] == 'peminjaman_status' ||
            message.data['type'] == 'peminjaman_ending') {
          print('User notification received in foreground');

          // Tampilkan notifikasi lokal
          _showLocalNotification(
            message.notification?.title ?? 'Notifikasi Peminjaman',
            message.notification?.body ?? '',
            message.data,
            userChannel,
          );

          // Trigger callback berdasarkan tipe notifikasi
          if (message.data['type'] == 'peminjaman_status') {
            onStatusChange?.call();
          } else if (message.data['type'] == 'peminjaman_ending') {
            onPeminjamanEnding?.call();
          }
        }
      });

      // Listen untuk pesan ketika app dibuka dari notifikasi
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data['type'] == 'peminjaman_status') {
          print('App opened from peminjaman status notification');
          final String? peminjamanId = message.data['peminjamanId'];
          if (peminjamanId != null) {
            Get.toNamed('/peminjaman/$peminjamanId');
          }
        }
      });

      // Load notifikasi yang sudah ada
      final prefs = await SharedPreferences.getInstance();
      final userNotifications = prefs.getStringList('user_notifications') ?? [];
      print('Loaded ${userNotifications.length} existing user notifications');

      // Request permission untuk notifikasi
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      print(
          'User notification permission status: ${settings.authorizationStatus}');
    } catch (e) {
      print('Error setting up user notifications: $e');
    }
  }

  // Method untuk memuat notifikasi user
  Future<void> _loadUserNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifications = prefs.getStringList('user_notifications') ?? [];
      hasNewNotifications.value = notifications.any((notif) {
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

  Future<void> setupAdminNotifications({
    Function? onNewPeminjaman,
  }) async {
    try {
      // Listen untuk pesan foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.data['type'] == 'new_peminjaman') {
          print('New peminjaman notification received in foreground');

          // Tampilkan notifikasi lokal
          _showLocalNotification(
            message.notification?.title ?? 'Peminjaman Baru',
            message.notification?.body ?? '',
            message.data,
            adminChannel,
          );

          // Trigger callback jika ada
          onNewPeminjaman?.call();
        }
      });

      // Listen untuk pesan ketika app dibuka dari notifikasi
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data['type'] == 'new_peminjaman') {
          print('App opened from new peminjaman notification');

          // Navigate ke halaman yang sesuai
          final String? peminjamanId = message.data['peminjamanId'];
          if (peminjamanId != null) {
            Get.toNamed('/admin/peminjaman/$peminjamanId');
          }
        }
      });

      // Load notifikasi yang sudah ada
      final prefs = await SharedPreferences.getInstance();
      final adminNotifications =
          prefs.getStringList('admin_notifications') ?? [];
      print('Loaded ${adminNotifications.length} existing admin notifications');
    } catch (e) {
      print('Error setting up admin notifications: $e');
    }
  }

  @override
  void onClose() {
    for (var timer in _notificationTimers.values) {
      timer.cancel();
    }
    for (var timer in _reminderTimers.values) {
      timer.cancel();
    }
    _notificationTimers.clear();
    _reminderTimers.clear();
    super.onClose();
  }
}


// ---------------------------------------------------------------------------------------------------------- //
// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final ApiController _apiController = ApiController();
//   // Remove direct instantiation of controllers
//   // late final ExtendPeminjamanController _extendController;
//   // late final DetailPeminjamanController _detailController;

//   // State tracking
//   final RxBool isInitialized = false.obs;
//   final Map<String, Timer> _notificationTimers = {};
//   final Map<String, Timer> _reminderTimers = {};
//   // final Map<String, bool> _hasShownDialog = {};
//   // final Map<String, bool> _hasExtended = {};

//   // Counter untuk ID notifikasi
//   int _notificationIdCounter = 0;

//   // Callback untuk extension dialog
//   Function(String, String, DateTime)? onShowExtensionDialog;

//   int _getNextNotificationId() {
//     _notificationIdCounter = (_notificationIdCounter + 1) % 100000;
//     return _notificationIdCounter;
//   }

//   Future<NotificationService> init() async {
//     try {
//       // Initialize controllers lazily
//       // _extendController = Get.find<ExtendPeminjamanController>();
//       // _detailController = Get.find<DetailPeminjamanController>();
//       await _requestPermissions();
//       await _initializeLocalNotifications();
//       await _setupFirebaseMessaging(); // Changed from _setupMessageHandlers
//       await _updateFcmToken();
//       isInitialized.value = true;
//       return this;
//     } catch (e) {
//       print('Error initializing NotificationService: $e');
//       rethrow;
//     }
//   }

//   Future<void> _requestPermissions() async {
//     try {
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//         criticalAlert: true,
//       );
//       print('User granted permission: ${settings.authorizationStatus}');
//     } catch (e) {
//       print('Error requesting notification permissions: $e');
//       rethrow;
//     }
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         _onNotificationResponse(
//             response); // Changed from _handleNotificationResponse
//       },
//     );

//     await _createNotificationChannel();
//   }

//   // Renamed from _setupMessageHandlers to _setupFirebaseMessaging
//   Future<void> _setupFirebaseMessaging() async {
//     // Foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Background messages
//     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

//     // Message opens app
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
//   }

//   // Renamed from _handleNotificationResponse to _onNotificationResponse
//   void _onNotificationResponse(NotificationResponse response) {
//     if (response.payload != null) {
//       try {
//         final data = json.decode(response.payload!);
//         _handleNotificationAction(data);
//       } catch (e) {
//         print('Error handling notification response: $e');
//       }
//     }
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'peminjaman_channel',
//       'Peminjaman Notifications',
//       description: 'Notifikasi terkait peminjaman mesin',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//       showBadge: true,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> _updateFcmToken() async {
//     try {
//       final String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         print('Got new FCM token: ${token.substring(0, 10)}...');
//         await _apiController.updateFcmToken(token);

//         // Setup token refresh listener
//         _firebaseMessaging.onTokenRefresh.listen((newToken) async {
//           print('FCM token refreshed. Updating...');
//           await _apiController.updateFcmToken(newToken);
//         });
//       }
//     } catch (e) {
//       print('Error updating FCM token: $e');
//     }
//   }

//   Future<void> _setupNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'peminjaman_channel',
//       'Peminjaman Notifications',
//       description: 'Notifikasi terkait peminjaman mesin',
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//       showBadge: true,
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   void startPeminjamanCheck(
//       String peminjamanId, DateTime endTime, String namaMesin) {
//     stopPeminjamanCheck(peminjamanId);

//     try {
//       final now = DateTime.now();

//       // Set timer untuk notifikasi 5 menit sebelum berakhir
//       final warningTime = endTime.subtract(Duration(minutes: 5));
//       if (now.isBefore(warningTime)) {
//         _notificationTimers[peminjamanId] = Timer(
//           warningTime.difference(now),
//           () => _sendEndingNotification(peminjamanId, namaMesin),
//         );
//       }
//     } catch (e) {
//       print('Error in startPeminjamanCheck: $e');
//     }
//   }

//   // void startPeminjamanCheck(
//   //     String peminjamanId, DateTime endTime, String namaMesin,
//   //     {bool shouldShowExtension = true}) {
//   //   stopPeminjamanCheck(peminjamanId);

//   //   try {
//   //     final now = DateTime.now();

//   //     // Set timer untuk notifikasi 5 menit sebelum berakhir
//   //     final warningTime = endTime.subtract(Duration(minutes: 5));
//   //     if (now.isBefore(warningTime)) {
//   //       _notificationTimers[peminjamanId] = Timer(warningTime.difference(now),
//   //           () => _sendEndingNotification(peminjamanId, namaMesin));
//   //     }

//   //     // Extension check at 3 minutes before end
//   //     if (shouldShowExtension) {
//   //       final extensionCheckTime = endTime.subtract(Duration(minutes: 3));
//   //       if (now.isBefore(extensionCheckTime)) {
//   //         _reminderTimers[peminjamanId] = Timer(
//   //           extensionCheckTime.difference(now),
//   //           () async {
//   //             if (!(await hasDialogBeenShown(peminjamanId))) {
//   //               onShowExtensionDialog?.call(peminjamanId, namaMesin, endTime);
//   //               await markDialogAsShown(peminjamanId);
//   //             }
//   //           },
//   //         );
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error in startPeminjamanCheck: $e');
//   //   }
//   // }

//   // Future<bool> extendPeminjaman(
//   //     String peminjamanId, String namaMesin, int minutes) async {
//   //   try {
//   //     // Call extend using controller
//   //     await _extendController.extendPeminjaman(peminjamanId, minutes);

//   //     // Get updated peminjaman detail
//   //     await _detailController.getPeminjamanDetail(peminjamanId);
//   //     final newEndTime =
//   //         _detailController.detailPeminjaman.value.data.akhirPeminjamanTime;

//   //     if (newEndTime != null) {
//   //       // Mark as extended
//   //       _hasExtended[peminjamanId] = true;

//   //       // Start new check with updated end time
//   //       startPeminjamanCheck(peminjamanId, newEndTime, namaMesin,
//   //           shouldShowExtension: false);
//   //       return true;
//   //     }
//   //     return false;
//   //   } catch (e) {
//   //     print('Error extending peminjaman: $e');
//   //     return false;
//   //   }
//   // }

//   // Future<bool> handleExtension(
//   //     String peminjamanId, String namaMesin, int minutes) async {
//   //   try {
//   //     // Get latest peminjaman detail
//   //     await _detailController.getPeminjamanDetail(peminjamanId);

//   //     // Extend peminjaman
//   //     await _extendController.extendPeminjaman(peminjamanId, minutes);

//   //     // Mark as extended
//   //     _hasExtended[peminjamanId] = true;

//   //     // Get updated end time
//   //     await _detailController.getPeminjamanDetail(peminjamanId);
//   //     final newEndTime =
//   //         _detailController.detailPeminjaman.value.data.akhirPeminjamanTime;

//   //     if (newEndTime != null) {
//   //       // Restart notification check with new end time
//   //       startPeminjamanCheck(peminjamanId, newEndTime, namaMesin,
//   //           shouldShowExtension: false);
//   //     }

//   //     return true;
//   //   } catch (e) {
//   //     print('Error in handleExtension: $e');
//   //     return false;
//   //   }
//   // }

//   Future<void> _sendEndingNotification(
//       String peminjamanId, String namaMesin) async {
//     try {
//       await _showLocalNotification('Peminjaman Akan Berakhir',
//           'Peminjaman $namaMesin akan berakhir dalam 5 menit', {
//         'type': 'peminjaman_ending',
//         'peminjamanId': peminjamanId,
//         'namaMesin': namaMesin
//       });

//       await _apiController.checkPeminjamanNotification(peminjamanId);
//     } catch (e) {
//       print('Error sending ending notification: $e');
//     }
//   }

//   Future<void> _showLocalNotification(
//       String title, String body, Map<String, dynamic> payload) async {
//     final notificationId = _getNextNotificationId();

//     try {
//       await _flutterLocalNotificationsPlugin.show(
//           notificationId,
//           title,
//           body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               'peminjaman_channel',
//               'Peminjaman Notifications',
//               channelDescription: 'Notifikasi terkait peminjaman mesin',
//               importance: Importance.max,
//               priority: Priority.high,
//               showWhen: true,
//               enableVibration: true,
//               playSound: true,
//             ),
//           ),
//           payload: json.encode(payload));
//     } catch (e) {
//       print('Error showing notification: $e');
//       // Fallback without sound
//       try {
//         await _flutterLocalNotificationsPlugin.show(
//             notificationId,
//             title,
//             body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 'peminjaman_channel',
//                 'Peminjaman Notifications',
//                 channelDescription: 'Notifikasi terkait peminjaman mesin',
//                 importance: Importance.max,
//                 priority: Priority.high,
//                 showWhen: true,
//                 enableVibration: true,
//                 playSound: false,
//               ),
//             ),
//             payload: json.encode(payload));
//       } catch (e) {
//         print('Error showing fallback notification: $e');
//       }
//     }
//   }

//   void _handleNotificationAction(Map<String, dynamic> data) {
//     final String? type = data['type'];
//     final String? peminjamanId = data['peminjamanId'];

//     if (peminjamanId != null) {
//       switch (type) {
//         case 'peminjaman_ending':
//         case 'time_reminder':
//           Get.toNamed('/peminjaman/$peminjamanId');
//           break;
//       }
//     }
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     print('Got a message in foreground!');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       await _showLocalNotification(
//         message.notification!.title ?? 'Notification',
//         message.notification!.body ?? '',
//         message.data,
//       );
//     }
//   }

//   void _handleMessageOpenedApp(RemoteMessage message) {
//     print('Message opened app: ${message.messageId}');
//     if (message.data.isNotEmpty) {
//       _handleNotificationAction(message.data);
//     }
//   }

//   void stopPeminjamanCheck(String peminjamanId) {
//     _notificationTimers[peminjamanId]?.cancel();
//     _reminderTimers[peminjamanId]?.cancel();
//     _notificationTimers.remove(peminjamanId);
//     _reminderTimers.remove(peminjamanId);
//   }

//   // void markAsExtended(String peminjamanId) {
//   //   _hasExtended[peminjamanId] = true;
//   // }

//   // void resetState(String peminjamanId) {
//   //   _hasShownDialog[peminjamanId] = false;
//   //   _hasExtended[peminjamanId] = false;
//   // }

//   // void resetState(String peminjamanId) {
//   //   _hasShownDialog[peminjamanId] = false;
//   // }

//   // Future<void> markDialogAsShown(String peminjamanId) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final shownDialogs = prefs.getStringList('hasShownDialog')?.toSet() ?? {};
//   //   shownDialogs.add(peminjamanId);
//   //   await prefs.setStringList('hasShownDialog', shownDialogs.toList());
//   // }

//   // Future<bool> hasDialogBeenShown(String peminjamanId) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final shownDialogs = prefs.getStringList('hasShownDialog')?.toSet() ?? {};
//   //   return shownDialogs.contains(peminjamanId);
//   // }

//   // Future<void> resetDialogState(String peminjamanId) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   final shownDialogs = prefs.getStringList('hasShownDialog')?.toSet() ?? {};
//   //   shownDialogs.remove(peminjamanId);
//   //   await prefs.setStringList('hasShownDialog', shownDialogs.toList());
//   // }

//   @override
//   void onClose() {
//     for (var timer in _notificationTimers.values) {
//       timer.cancel();
//     }
//     for (var timer in _reminderTimers.values) {
//       timer.cancel();
//     }
//     _notificationTimers.clear();
//     _reminderTimers.clear();
//     super.onClose();
//   }
// }
  
// ----------------------------------------------------------------------------------------------------------------------- //
  
// class NotificationService extends GetxService {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final ApiController _apiController = ApiController();

//   // Tambahkan counter untuk ID notifikasi
//   int _notificationIdCounter = 0;

//   // Fungsi untuk mendapatkan ID notifikasi yang valid
//   int _getNextNotificationId() {
//     _notificationIdCounter = (_notificationIdCounter + 1) % 100000;
//     return _notificationIdCounter;
//   }

//   // Map untuk menyimpan timer notifikasi aktif
//   final Map<String, Timer> _notificationTimers = {};
//   final Map<String, Timer> _reminderTimers = {};

//   // Channel configuration
//   static const String channelId = 'peminjaman_channel';
//   static const String channelName = 'Peminjaman Notifications';
//   static const String channelDescription =
//       'Notifikasi terkait peminjaman mesin';

//   // Status tracking
//   final RxBool isInitialized = false.obs;

//   Future<NotificationService> init() async {
//     try {
//       await _requestPermissions();
//       await _initializeLocalNotifications();
//       await _setupMessageHandlers();
//       await _updateFcmToken();
//       isInitialized.value = true;
//       return this;
//     } catch (e) {
//       print('Error initializing NotificationService: $e');
//       rethrow;
//     }
//   }

//   Future<void> _requestPermissions() async {
//     try {
//       final settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//         criticalAlert: true,
//       );
//       print('User granted permission: ${settings.authorizationStatus}');
//     } catch (e) {
//       print('Error requesting notification permissions: $e');
//       rethrow;
//     }
//   }

//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//     );

//     await _flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _handleNotificationResponse,
//     );

//     // Create notification channel
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       channelId,
//       channelName,
//       description: channelDescription,
//       importance: Importance.max,
//       playSound: true,
//       enableVibration: true,
//       enableLights: true,
//       // Gunakan default sound
//       sound: null, // Menggunakan default sound sistem
//     );

//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> _setupMessageHandlers() async {
//     // Foreground messages
//     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

//     // Background messages
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // Message opens app
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
//   }

//   Future<void> _updateFcmToken() async {
//     try {
//       final String? token = await _firebaseMessaging.getToken();
//       if (token != null) {
//         print('Got new FCM token: ${token.substring(0, 10)}...');
//         await _apiController.updateFcmToken(token);

//         // Setup token refresh listener
//         _firebaseMessaging.onTokenRefresh.listen((newToken) async {
//           print('FCM token refreshed. Updating...');
//           await _apiController.updateFcmToken(newToken);
//         });
//       }
//     } catch (e) {
//       print('Error updating FCM token: $e');
//     }
//   }

//   // Fungsi untuk memulai pengecekan notifikasi untuk peminjaman
//   void startPeminjamanCheck(
//       String peminjamanId, DateTime endTime, String namaMesin) {
//     stopPeminjamanCheck(peminjamanId); // Hentikan timer yang ada

//     print('Starting notification check for: $peminjamanId');
//     print('End time: $endTime');

//     final now = DateTime.now();

//     // Set timer untuk notifikasi 5 menit sebelum berakhir
//     final notificationTime = endTime.subtract(Duration(minutes: 5));
//     if (now.isBefore(notificationTime)) {
//       _notificationTimers[peminjamanId] = Timer(
//           notificationTime.difference(now),
//           () => _sendEndingNotification(peminjamanId, namaMesin));
//     }

//     // Set reminder setiap menit di 3 menit terakhir
//     final reminderStartTime = endTime.subtract(Duration(minutes: 3));
//     if (now.isBefore(reminderStartTime)) {
//       _reminderTimers[peminjamanId] = Timer.periodic(Duration(minutes: 1),
//           (_) => _checkTimeRemaining(peminjamanId, endTime, namaMesin));
//     }
//   }

//   void stopPeminjamanCheck(String peminjamanId) {
//     _notificationTimers[peminjamanId]?.cancel();
//     _notificationTimers.remove(peminjamanId);

//     _reminderTimers[peminjamanId]?.cancel();
//     _reminderTimers.remove(peminjamanId);

//     print('Stopped all notifications for: $peminjamanId');
//   }

//   // Future<void> _sendEndingNotification(
//   //     String peminjamanId, String namaMesin) async {
//   //   await _showLocalNotification('Peminjaman Akan Berakhir',
//   //       'Peminjaman $namaMesin akan berakhir dalam 5 menit', {
//   //     'type': 'peminjaman_ending',
//   //     'peminjamanId': peminjamanId,
//   //     'namaMesin': namaMesin
//   //   });

//   //   try {
//   //     await _apiController.checkPeminjamanNotification(peminjamanId);
//   //   } catch (e) {
//   //     print('Error sending server notification: $e');
//   //   }
//   // }

//   // Perbarui cara mengirim notifikasi untuk peminjaman yang akan berakhir
//   Future<void> _sendEndingNotification(
//       String peminjamanId, String namaMesin) async {
//     try {
//       // Kirim notifikasi lokal
//       await _showLocalNotification('Peminjaman Akan Berakhir',
//           'Peminjaman $namaMesin akan berakhir dalam 5 menit', {
//         'type': 'peminjaman_ending',
//         'peminjamanId': peminjamanId,
//         'namaMesin': namaMesin
//       });

//       // Kirim notifikasi ke server
//       final response =
//           await _apiController.checkPeminjamanNotification(peminjamanId);
//       if (response.statusCode == 200) {
//         print('Server notification sent successfully');
//       } else {
//         print('Failed to send server notification: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error in _sendEndingNotification: $e');
//     }
//   }

//   // Future<void> _checkTimeRemaining(
//   //     String peminjamanId, DateTime endTime, String namaMesin) async {
//   //   final now = DateTime.now();
//   //   final remaining = endTime.difference(now);

//   //   if (remaining.inMinutes <= 3 && remaining.inMinutes > 0) {
//   //     await _showLocalNotification(
//   //         'Peringatan Waktu',
//   //         'Peminjaman $namaMesin akan berakhir dalam ${remaining.inMinutes} menit',
//   //         {
//   //           'type': 'time_reminder',
//   //           'peminjamanId': peminjamanId,
//   //           'namaMesin': namaMesin,
//   //           'timeRemaining': remaining.inMinutes.toString()
//   //         });
//   //   } else if (remaining.inMinutes <= 0) {
//   //     stopPeminjamanCheck(peminjamanId);
//   //   }
//   // }

//   Future<void> _checkTimeRemaining(
//       String peminjamanId, DateTime endTime, String namaMesin) async {
//     try {
//       final now = DateTime.now();
//       final remaining = endTime.difference(now);

//       if (remaining.inMinutes <= 3 && remaining.inMinutes > 0) {
//         await _showLocalNotification(
//             'Peringatan Waktu',
//             'Peminjaman $namaMesin akan berakhir dalam ${remaining.inMinutes} menit',
//             {
//               'type': 'time_reminder',
//               'peminjamanId': peminjamanId,
//               'namaMesin': namaMesin,
//               'timeRemaining': remaining.inMinutes.toString()
//             });
//       } else if (remaining.inMinutes <= 0) {
//         stopPeminjamanCheck(peminjamanId);
//       }
//     } catch (e) {
//       print('Error in _checkTimeRemaining: $e');
//     }
//   }

//   // Future<void> _showLocalNotification(
//   //     String title, String body, Map<String, dynamic> payload) async {
//   //   const androidDetails = AndroidNotificationDetails(channelId, channelName,
//   //       channelDescription: channelDescription,
//   //       importance: Importance.max,
//   //       priority: Priority.high,
//   //       showWhen: true,
//   //       enableVibration: true,
//   //       playSound: true,
//   //       sound: null,
//   //       ticker: 'Peminjaman Notification');

//   //   final notificationDetails = NotificationDetails(android: androidDetails);

//   //   try {
//   //     await _flutterLocalNotificationsPlugin.show(
//   //         DateTime.now().millisecondsSinceEpoch, // Lebih unik ID
//   //         title,
//   //         body,
//   //         notificationDetails,
//   //         payload: json.encode(payload));
//   //     print('Local notification shown: $title');
//   //   } catch (e) {
//   //     print('Error showing local notification: $e');
//   //     // Coba lagi tanpa sound jika error
//   //     const fallbackAndroidDetails = AndroidNotificationDetails(
//   //       channelId,
//   //       channelName,
//   //       channelDescription: channelDescription,
//   //       importance: Importance.max,
//   //       priority: Priority.high,
//   //       showWhen: true,
//   //       enableVibration: true,
//   //       playSound: false, // Disable sound jika error
//   //     );

//   //     final fallbackNotificationDetails =
//   //         NotificationDetails(android: fallbackAndroidDetails);

//   //     try {
//   //       await _flutterLocalNotificationsPlugin.show(
//   //           DateTime.now().millisecondsSinceEpoch,
//   //           title,
//   //           body,
//   //           fallbackNotificationDetails,
//   //           payload: json.encode(payload));
//   //       print('Fallback notification shown without sound: $title');
//   //     } catch (e) {
//   //       print('Error showing fallback notification: $e');
//   //     }
//   //   }
//   // }

//   Future<void> _showLocalNotification(
//       String title, String body, Map<String, dynamic> payload) async {
//     const androidDetails = AndroidNotificationDetails(channelId, channelName,
//         channelDescription: channelDescription,
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: true,
//         enableVibration: true,
//         playSound: true,
//         sound: null, // Menggunakan default sound sistem
//         ticker: 'Peminjaman Notification');

//     final notificationDetails = NotificationDetails(android: androidDetails);

//     try {
//       // Gunakan ID yang valid
//       final notificationId = _getNextNotificationId();

//       await _flutterLocalNotificationsPlugin.show(
//           notificationId, title, body, notificationDetails,
//           payload: json.encode(payload));
//       print('Local notification shown: $title with ID: $notificationId');
//     } catch (e) {
//       print('Error showing local notification: $e');

//       // Fallback dengan ID yang berbeda
//       try {
//         final fallbackId = _getNextNotificationId();
//         const fallbackAndroidDetails = AndroidNotificationDetails(
//           channelId,
//           channelName,
//           channelDescription: channelDescription,
//           importance: Importance.max,
//           priority: Priority.high,
//           showWhen: true,
//           enableVibration: true,
//           playSound: false,
//         );

//         final fallbackNotificationDetails =
//             NotificationDetails(android: fallbackAndroidDetails);

//         await _flutterLocalNotificationsPlugin.show(
//             fallbackId, title, body, fallbackNotificationDetails,
//             payload: json.encode(payload));
//         print('Fallback notification shown with ID: $fallbackId');
//       } catch (e) {
//         print('Error showing fallback notification: $e');
//       }
//     }
//   }

//   void _handleNotificationResponse(NotificationResponse response) {
//     if (response.payload != null) {
//       try {
//         final data = json.decode(response.payload!);
//         _handleNotificationAction(data);
//       } catch (e) {
//         print('Error handling notification response: $e');
//       }
//     }
//   }

//   void _handleNotificationAction(Map<String, dynamic> data) {
//     final String? type = data['type'];
//     final String? peminjamanId = data['peminjamanId'];

//     if (peminjamanId != null) {
//       switch (type) {
//         case 'peminjaman_ending':
//         case 'time_reminder':
//           Get.toNamed('/peminjaman/$peminjamanId');
//           break;
//       }
//     }
//   }

//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     print('Got a message in foreground!');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       await _showLocalNotification(
//         message.notification!.title ?? 'Notification',
//         message.notification!.body ?? '',
//         message.data,
//       );
//     }
//   }

//   void _handleMessageOpenedApp(RemoteMessage message) {
//     print('Message opened app: ${message.messageId}');
//     if (message.data.isNotEmpty) {
//       _handleNotificationAction(message.data);
//     }
//   }

//   @override
//   void onClose() {
//     // Cancel all active timers
//     for (var timer in _notificationTimers.values) {
//       timer.cancel();
//     }
//     for (var timer in _reminderTimers.values) {
//       timer.cancel();
//     }
//     _notificationTimers.clear();
//     _reminderTimers.clear();
//     super.onClose();
//   }
// }

// // Top-level function for handling background messages
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('Handling a background message: ${message.messageId}');
//   // Add any background message handling logic here
// }

// // class NotificationService extends GetxService {
// //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
// //   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //   final ApiController _apiController = ApiController();

// //   // Channel ID constants
// //   static const String channelId = 'peminjaman_channel';
// //   static const String channelName = 'Peminjaman Notifications';
// //   static const String channelDescription =
// //       'Notifikasi terkait peminjaman mesin';

// //   Future<NotificationService> init() async {
// //     // Request permission
// //     await _requestPermissions();

// //     // Initialize local notifications
// //     await _initializeLocalNotifications();

// //     // Setup message handlers
// //     _setupMessageHandlers();

// //     // Get and update FCM token
// //     await _updateFcmToken();

// //     return this;
// //   }

// //   Future<void> _requestPermissions() async {
// //     await _firebaseMessaging.requestPermission(
// //       alert: true,
// //       badge: true,
// //       sound: true,
// //       provisional: false,
// //     );
// //   }

// //   Future<void> _initializeLocalNotifications() async {
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');

// //     const InitializationSettings initializationSettings =
// //         InitializationSettings(
// //       android: initializationSettingsAndroid,
// //     );

// //     await _flutterLocalNotificationsPlugin.initialize(
// //       initializationSettings,
// //       onDidReceiveNotificationResponse: _handleNotificationTap,
// //     );

// //     // Create notification channel
// //     const AndroidNotificationChannel channel = AndroidNotificationChannel(
// //       channelId,
// //       channelName,
// //       description: channelDescription,
// //       importance: Importance.high,
// //     );

// //     await _flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>()
// //         ?.createNotificationChannel(channel);
// //   }

// //   void _setupMessageHandlers() {
// //     FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
// //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
// //     FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
// //   }

// //   Future<void> _updateFcmToken() async {
// //     try {
// //       // Validate access token first
// //       final SharedPreferences shared = await SharedPreferences.getInstance();
// //       String? accessToken = shared.getString("accessToken");

// //       if (accessToken == null) {
// //         print('No access token available. Skipping FCM update.');
// //         return;
// //       }

// //       // Validate FCM token
// //       String? token = await _firebaseMessaging.getToken();
// //       if (token == null) {
// //         print('Failed to get FCM token from Firebase');
// //         return;
// //       }

// //       print('Got FCM token: ${token.substring(0, 10)}...');
// //       await _apiController.updateFcmToken(token);
// //     } catch (e) {
// //       print('Error in _updateFcmToken: $e');
// //     }

// //     // Setup token refresh listener
// //     _firebaseMessaging.onTokenRefresh.listen((newToken) async {
// //       try {
// //         print('FCM token refreshed. Updating...');
// //         await _apiController.updateFcmToken(newToken);
// //       } catch (e) {
// //         print('Error updating refreshed FCM token: $e');
// //       }
// //     });
// //   }

// //   Future<void> _handleForegroundMessage(RemoteMessage message) async {
// //     print('Got a message in foreground!');
// //     print('Message data: ${message.data}');

// //     if (message.notification != null) {
// //       await _showLocalNotification(
// //         message.notification!.title ?? 'Notification',
// //         message.notification!.body ?? '',
// //         message.data,
// //       );
// //     }
// //   }

// //   Future<void> _showLocalNotification(
// //     String title,
// //     String body,
// //     Map<String, dynamic> data,
// //   ) async {
// //     const AndroidNotificationDetails androidPlatformChannelSpecifics =
// //         AndroidNotificationDetails(
// //       channelId,
// //       channelName,
// //       importance: Importance.max,
// //       priority: Priority.high,
// //       showWhen: true,
// //     );

// //     const NotificationDetails platformChannelSpecifics =
// //         NotificationDetails(android: androidPlatformChannelSpecifics);

// //     await _flutterLocalNotificationsPlugin.show(
// //       0,
// //       title,
// //       body,
// //       platformChannelSpecifics,
// //       payload: data['peminjamanId'],
// //     );
// //   }

// //   void _handleNotificationTap(NotificationResponse response) {
// //     if (response.payload != null) {
// //       // Navigate to specific screen based on payload
// //       final String peminjamanId = response.payload!;
// //       // Get.toNamed('/peminjaman/$peminjamanId');
// //     }
// //   }

// //   void _handleNotificationOpenedApp(RemoteMessage message) {
// //     if (message.data['peminjamanId'] != null) {
// //       // Navigate to specific screen
// //       final String peminjamanId = message.data['peminjamanId'];
// //       // Get.toNamed('/peminjaman/$peminjamanId');
// //     }
// //   }
// // }

// // // Top-level function for background message handling
// // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   print('Handling a background message: ${message.messageId}');
// // }
