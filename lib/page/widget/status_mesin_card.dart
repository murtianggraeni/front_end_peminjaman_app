import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:build_app/models/machine_status_model.dart';

// lib/widgets/status_mesin_card.dart
class StatusMesinCard extends StatelessWidget {
  final String merekMesin;
  final String namaMesin;
  final String namaLab;
  final String gambarMesin;
  final Stream<MachineStatus?> stream;

  const StatusMesinCard({
    Key? key,
    required this.merekMesin,
    required this.namaMesin,
    required this.namaLab,
    required this.gambarMesin,
    required this.stream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Perlebar sedikit
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 16), // Tambah margin
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200), // Tambah border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: StreamBuilder<MachineStatus?>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

        //         child: Obx(() {  // Ubah StreamBuilder ke Obx untuk reaktivitas GetX
        // final controller = Get.find<MachineStatusController>();
        // final status = controller.getStatusByType(namaMesin.toLowerCase());
        
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }


          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bagian Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Mesin
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        gambarMesin,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Informasi Mesin
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          namaMesin,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1D5973),
                          ),
                        ),
                        // const SizedBox(height: 1),
                        Text(
                          merekMesin,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            namaLab,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Status Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status:',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildStatusIndicator(snapshot.data),
                ],
              ),

              // User Info Section jika mesin aktif
              if (snapshot.data?.isStarted == true &&
                  snapshot.data?.currentUser != null) ...[
                const SizedBox(height: 20),
                _buildUserInfo(snapshot.data!.currentUser!),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(MachineStatus? status) {
    final bool isActive = status?.isStarted ?? false;
    final String statusText = isActive ? 'Sedang Digunakan' : 'Tidak Aktif';
    final Color statusColor = isActive ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(UserPeminjaman user) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Informasi Penggunaan',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.person, 'Pengguna', user.namaPemohon),
          const SizedBox(height: 8),
          _buildInfoRow(
              Icons.calendar_today, 'Tanggal', 
              // user.tanggalPeminjaman)
              user.convertToDateFormat(user.tanggalPeminjaman)),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.access_time, 'Waktu',
          '${user.convertTo24HourFormat(user.awalPeminjaman)} - ${user.convertTo24HourFormat(user.akhirPeminjaman)}'),
              // '${user.awalPeminjaman} - ${user.akhirPeminjaman}'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// class StatusMesinCard extends StatelessWidget {
//   final String merekMesin;
//   final String namaMesin;
//   final String namaLab;
//   final String gambarMesin;
//   final Stream<MachineStatus?> stream;

//   const StatusMesinCard({
//     Key? key,
//     required this.merekMesin,
//     required this.namaMesin,
//     required this.namaLab,
//     required this.gambarMesin,
//     required this.stream,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 280,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: StreamBuilder<MachineStatus?>(
//         stream: stream,
//         builder: (context, snapshot) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header dengan info mesin
//               Row(
//                 children: [
//                   Image.asset(
//                     gambarMesin,
//                     width: 60,
//                     height: 60,
//                     fit: BoxFit.cover,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           namaMesin,
//                           style: GoogleFonts.inter(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           merekMesin,
//                           style: GoogleFonts.inter(
//                             fontSize: 12,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // Status Indicator
//               _buildStatusIndicator(snapshot.data),

//               // Informasi penggunaan jika aktif
//               if (snapshot.data?.isStarted == true && 
//                   snapshot.data?.currentUser != null)
//                 _buildUserInfo(snapshot.data!.currentUser!),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatusIndicator(MachineStatus? status) {
//     final bool isActive = status?.isStarted ?? false;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isActive ? Colors.green : Colors.grey,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             isActive ? 'Sedang Digunakan' : 'Tidak Aktif',
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               color: isActive ? Colors.green : Colors.grey,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildUserInfo(UserPeminjaman user) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Informasi Penggunaan:',
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8),
//           _buildInfoRow(Icons.person_outline, 'Pengguna:', user.namaPemohon),
//           const SizedBox(height: 4),
//           _buildInfoRow(Icons.calendar_today, 'Tanggal:', user.tanggalPeminjaman),
//           const SizedBox(height: 4),
//           _buildInfoRow(
//             Icons.access_time, 
//             'Waktu:', 
//             '${user.awalPeminjaman} - ${user.akhirPeminjaman}'
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 14, color: Colors.grey[600]),
//         const SizedBox(width: 4),
//         Text(
//           '$label ',
//           style: GoogleFonts.inter(
//             fontSize: 12,
//             color: Colors.grey[600],
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: GoogleFonts.inter(
//               fontSize: 12,
//               fontWeight: FontWeight.w500,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }