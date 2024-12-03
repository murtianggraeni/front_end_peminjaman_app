import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:build_app/controller/admin_notification_controller.dart';


class AdminNotificationDialog extends StatelessWidget {
  final AdminNotificationController controller = Get.find();

  Color _getColorForMachine(String type) {
    switch (type.toLowerCase()) {
      case 'cnc':
        return Colors.blue;
      case 'laser':
        return Colors.red;
      case 'printing':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notifikasi',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(),
            
            // Unread Counter
            Obx(() {
              if (controller.unreadCount.value > 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${controller.unreadCount.value} peminjaman baru',
                    style: GoogleFonts.inter(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Notification List
            Expanded(
              child: Obx(() {
                if (controller.notifications.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada notifikasi',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    final notification = controller.notifications[index];
                    final bool isUnread = notification['status'] == 'unread';
                    final Color machineColor = _getColorForMachine(
                      notification['machineType'] ?? '',
                    );

                    return Card(
                      elevation: isUnread ? 2 : 1,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: machineColor.withOpacity(0.2),
                          child: Icon(
                            Icons.precision_manufacturing,
                            color: machineColor,
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Peminjaman ${notification['machineType']}',
                                style: GoogleFonts.inter(
                                  fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isUnread)
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['pemohon'] ?? '',
                              style: GoogleFonts.inter(fontSize: 14),
                            ),
                            Text(
                              '${notification['jurusan']} - ${notification['programStudi']}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.calendar_today, 
                                     size: 12, 
                                     color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  notification['tanggalPeminjaman'] ?? '',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.access_time,
                                     size: 12,
                                     color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${notification['waktuMulai']} - ${notification['waktuSelesai']}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          // Close dialog
                          Navigator.of(context).pop();
                          // Navigate to detail
                          Get.toNamed(
                            '/admin/peminjaman/${notification['peminjamanId']}',
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Get.toNamed(
                              '/admin/peminjaman/${notification['peminjamanId']}',
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      await controller.markAllAsRead();
                      // Optional: Show confirmation
                      Get.snackbar(
                        'Sukses',
                        'Semua notifikasi telah ditandai sudah dibaca',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: Text(
                      'Tandai Semua Dibaca',
                      style: GoogleFonts.inter(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}