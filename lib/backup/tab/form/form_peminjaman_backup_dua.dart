// import 'dart:io';
// import 'package:build_app/page/home/form_peminjaman/widget/custom_form_page.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:ming_cute_icons/ming_cute_icons.dart';
// import 'package:open_file/open_file.dart';

// class formPeminjamanBackupDua extends StatefulWidget {
//   const formPeminjamanBackupDua({super.key});

//   @override
//   State<formPeminjamanBackupDua> createState() =>
//       _formPeminjamanBackupDuaState();
// }

// class _formPeminjamanBackupDuaState extends State<formPeminjamanBackupDua> {
//   // Untuk memilih tanggal peminjaman
//   void _showDatePicker() async {
//     final DateTime now = DateTime.now();
//     final DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: now,
//       lastDate: DateTime(2100),
//     );

//     if (selectedDate != null) {
//       final TimeOfDay currentTime = TimeOfDay.now();
//       // Validasi agar pengguna dapat memilih tanggal yang sama dengan hari ini
//       // tetapi waktu tidak sama dengan waktu saat ini
//       if (selectedDate.year == now.year &&
//           selectedDate.month == now.month &&
//           selectedDate.day == now.day &&
//           selectedDate.hour == currentTime.hour &&
//           selectedDate.minute == currentTime.minute) {
//         // Jika waktu yang dipilih sama dengan waktu saat ini, tambahkan 1 menit
//         final DateTime nextMinute = now.add(const Duration(minutes: 1));
//         setState(() {
//           _date.text = DateFormat('EE, d MMM yyyy').format(selectedDate);
//           _startTime.text = '${nextMinute.hour}:${nextMinute.minute}';
//         });
//       } else {
//         setState(() {
//           _date.text = DateFormat('EE, d MMM yyyy').format(selectedDate);
//         });
//       }
//     }
//   }

//   // cara 1,
//   // Untuk memilih waktu peminjaman
//   // void _showTimePicker(TextEditingController controller) async {
//   //   final TimeOfDay now = TimeOfDay.now();
//   //   final TimeOfDay? selectedTime = await showTimePicker(
//   //     context: context,
//   //     initialTime: now,
//   //   );

//   // Validasi: Pastikan tanggal dan waktu awal sudah diisi sebelum memilih waktu akhir
//   // if (controller == _endTime &&
//   //     (_date.text.isEmpty || _startTime.text.isEmpty)) {
//   //   Get.snackbar(
//   //       "Peringatan", "Silakan pilih tanggal dan waktu awal terlebih dahulu");
//   //   return;
//   // }

//   // if (selectedTime != null) {
//   // Validasi untuk jam yang sama hari ini
//   // if (_date.text.isNotEmpty) {
//   //   final DateTime selectedDate =
//   //       DateFormat('EE, d MMM yyyy').parse(_date.text);
//   //   final DateTime now = DateTime.now();

//   //   if (selectedDate.year == now.year &&
//   //       selectedDate.month == now.month &&
//   //       selectedDate.day == now.day) {
//   //     if (selectedTime.hour < now.hour ||
//   //         (selectedTime.hour == now.hour &&
//   //             selectedTime.minute < now.minute)) {
//   //       Get.snackbar(
//   //           "Peringatan", "Tidak bisa memilih waktu yang sudah lewat");
//   //       return;
//   //     }
//   //   }
//   // }

//   // Validasi endTime harus setelah startTime
//   // cara 1,
//   // if (controller == _endTime) {
//   //   final TimeOfDay startTime = TimeOfDay.fromDateTime(
//   //       DateFormat('hh:mm a').parse(_startTime.text));
//   //   if (selectedTime.hour < startTime.hour ||
//   //       (selectedTime.hour == startTime.hour &&
//   //           selectedTime.minute <= startTime.minute)) {
//   //     Get.snackbar("Peringatan!",
//   //         "Waktu akhir peminjaman harus melewati waktu awal peminjaman");
//   //     return;
//   //   }
//   // }

//   // Validasi endTime harus setelah startTime
//   // cara 2,
//   // if (controller == _endTime) {
//   //   if (_startTime.text.isNotEmpty) {
//   //     final TimeOfDay startTime =
//   //         TimeOfDay.fromDateTime(DateFormat('jm').parse(_startTime.text));
//   //     if (selectedTime.hour < startTime.hour ||
//   //         (selectedTime.hour == startTime.hour &&
//   //             selectedTime.minute <= startTime.minute)) {
//   //       Get.snackbar("Peringatan!",
//   //           "Waktu akhir peminjaman harus melewati waktu awal peminjaman");
//   //       return;
//   //     }
//   //   }
//   // }

//   // cara 3,
//   // Validasi endTime harus setelah startTime
//   // Validasi endTime harus setelah startTime
//   // if (controller == _endTime) {
//   //   if (_startTime.text.isNotEmpty) {
//   //     final TimeOfDay startTime = TimeOfDay.fromDateTime(DateFormat('jm').parse(_startTime.text));
//   //     final DateTime selectedDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
//   //     final DateTime startDateTime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, startTime.hour, startTime.minute);
//   //     if (selectedDateTime.isBefore(startDateTime)) {
//   //       Get.snackbar("Peringatan!", "Waktu akhir peminjaman harus melewati waktu awal peminjaman");
//   //       return;
//   //     }
//   //   }
//   // }

//   //     setState(() {
//   //       controller.text = selectedTime.format(context);
//   //     });
//   //   }
//   // }

//   // cara 2,
//   // void _showTimePicker(TextEditingController controller) async {
//   //   final TimeOfDay now = TimeOfDay.now();
//   //   final TimeOfDay? selectedTime = await showTimePicker(
//   //     context: context,
//   //     initialTime: now,
//   //   );

//   //   // Validasi: Pastikan tanggal dan waktu awal sudah diisi sebelum memilih waktu akhir
//   //   if (controller == _endTime &&
//   //       (_date.text.isEmpty || _startTime.text.isEmpty)) {
//   //     Get.snackbar(
//   //         "Peringatan", "Silakan pilih tanggal dan waktu awal terlebih dahulu");
//   //     return;
//   //   }

//   //   // Validasi untuk jam yang sama hari ini
//   //   final DateTime selectedDate = _date.text.isNotEmpty
//   //       ? DateFormat('EE, d MMM yyyy').parse(_date.text)
//   //       : DateTime.now();

//   //   if (selectedTime != null) {
//   //     final DateTime currentDateTime = DateTime.now();

//   //     if (selectedDate.year == currentDateTime.year &&
//   //         selectedDate.month == currentDateTime.month &&
//   //         selectedDate.day == currentDateTime.day) {
//   //       if (selectedTime.hour < now.hour ||
//   //           (selectedTime.hour == now.hour &&
//   //               selectedTime.minute < now.minute)) {
//   //         Get.snackbar(
//   //             "Peringatan", "Tidak bisa memilih waktu yang sudah lewat");
//   //         return;
//   //       }
//   //     }

//   //     // Validasi endTime harus setelah startTime
//   //     if (controller == _endTime) {
//   //       if (_startTime.text.isNotEmpty && _date.text.isNotEmpty) {
//   //         final TimeOfDay startTime =
//   //             TimeOfDay.fromDateTime(DateFormat('jm').parse(_startTime.text));
//   //         final DateTime selectedDateTime = DateTime(
//   //             selectedDate.year,
//   //             selectedDate.month,
//   //             selectedDate.day,
//   //             selectedTime.hour,
//   //             selectedTime.minute);
//   //         final DateTime startDateTime = DateTime(
//   //             selectedDate.year,
//   //             selectedDate.month,
//   //             selectedDate.day,
//   //             startTime.hour,
//   //             startTime.minute);
//   //         if (selectedDateTime.isBefore(startDateTime)) {
//   //           Get.snackbar("Peringatan!",
//   //               "Waktu akhir peminjaman harus melewati waktu awal peminjaman");
//   //           return;
//   //         }
//   //       }
//   //     }

//   //     setState(() {
//   //       controller.text = selectedTime.format(context);
//   //     });
//   //   }
//   // }

//   // cara 3,
//   //

//   // cara 4,
// //   void _showTimePicker(TextEditingController controller) async {
// //   final TimeOfDay now = TimeOfDay.now();
// //   final TimeOfDay? selectedTime = await showTimePicker(
// //     context: context,
// //     initialTime: now,
// //   );

// //   if (selectedTime != null) {
// //     // Validasi untuk jam yang sama hari ini
// //     final DateTime selectedDateTime = DateTime(
// //       now.year,
// //       now.month,
// //       now.day,
// //       selectedTime.hour,
// //       selectedTime.minute,
// //     );
// //     if (selectedDateTime.isAtSameMomentAs(now)) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text("Waktu harus berbeda dengan waktu sekarang."),
// //         ),
// //       );
// //       return;
// //     }

// //     // Validasi endTime harus setelah startTime
// //     if (controller == _endTime) {
// //       final DateTime? selectedStartDate = _date.text.isNotEmpty
// //           ? DateFormat('EE, d MMM yyyy').parse(_date.text)
// //           : null;
// //       if (selectedStartDate == null) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("Silakan pilih tanggal terlebih dahulu."),
// //           ),
// //         );
// //         return;
// //       }

// //       final TimeOfDay startTime = TimeOfDay.fromDateTime(
// //           DateFormat('hh:mm a').parse(_startTime.text));
// //       final DateTime startDateTime = DateTime(
// //         selectedStartDate.year,
// //         selectedStartDate.month,
// //         selectedStartDate.day,
// //         startTime.hour,
// //         startTime.minute,
// //       );
// //       final DateTime endDateTime = DateTime(
// //         selectedStartDate.year,
// //         selectedStartDate.month,
// //         selectedStartDate.day,
// //         selectedTime.hour,
// //         selectedTime.minute,
// //       );
// //       if (endDateTime.isBefore(startDateTime)) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text("EndTime harus setelah StartTime."),
// //           ),
// //         );
// //         return;
// //       }
// //     }

// //     setState(() {
// //       controller.text = selectedTime.format(context);
// //     });
// //   }
// // }

//   // cara 5,
//   void _showTimePicker(TextEditingController controller) async {
//     final TimeOfDay now = TimeOfDay.now();
//     final TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: now,
//     );

//     if (selectedTime != null) {
//       // Validasi untuk jam yang sama hari ini
//       final DateTime selectedDateTime = DateTime(
//         DateTime.now().year,
//         DateTime.now().month,
//         DateTime.now().day,
//         selectedTime.hour,
//         selectedTime.minute,
//       );
//       if (selectedDateTime.isAtSameMomentAs(DateTime.now())) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Waktu harus berbeda dengan waktu sekarang."),
//           ),
//         );
//         return;
//       }

//       // Validasi endTime harus setelah startTime
//       if (controller == _endTime) {
//         final DateTime? selectedStartDate = _date.text.isNotEmpty
//             ? DateFormat('EE, d MMM yyyy').parse(_date.text)
//             : null;
//         if (selectedStartDate == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Silakan pilih tanggal terlebih dahulu."),
//             ),
//           );
//           return;
//         }

//         final TimeOfDay startTime = TimeOfDay.fromDateTime(
//             DateFormat('hh:mm a').parse(_startTime.text));
//         final DateTime startDateTime = DateTime(
//           selectedStartDate.year,
//           selectedStartDate.month,
//           selectedStartDate.day,
//           startTime.hour,
//           startTime.minute,
//         );
//         final DateTime endDateTime = DateTime(
//           selectedStartDate.year,
//           selectedStartDate.month,
//           selectedStartDate.day,
//           selectedTime.hour,
//           selectedTime.minute,
//         );

//         // Memeriksa apakah endTime setelah startTime
//         if (endDateTime.isBefore(startDateTime) ||
//             endDateTime.isAtSameMomentAs(startDateTime)) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("EndTime harus setelah StartTime."),
//             ),
//           );
//           return;
//         }
//       }

//       setState(() {
//         controller.text = selectedTime.format(context);
//       });
//     }
//   }

//   // Untuk memilih desain benda
//   List<String> pickedFileNames = [];

//   Future<void> _pickFile() async {
//     FilePickerResult? result =
//         await FilePicker.platform.pickFiles(allowMultiple: true);

//     if (result != null) {
//       setState(
//         () {
//           if (kIsWeb) {
//             pickedFileNames = result.files.map((file) => file.name).toList();
//           } else {
//             pickedFileNames =
//                 result.paths.map((path) => path!.split('/').last).toList();
//           }
//           // Menggabungkan nama file menjadi satu string
//           _fileText.text = pickedFileNames.join(", ");
//         },
//       );
//     }
//   }

//   void openFile(File file) {
//     OpenFile.open(file.path);
//   }

//   // Sebagai controller dari masing-masing fungsi
//   final TextEditingController _date = TextEditingController();
//   final TextEditingController _startTime = TextEditingController();
//   final TextEditingController _endTime = TextEditingController();
//   final TextEditingController _fileText = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Form(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 11.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               customFormPeminjaman(
//                 controller: _date,
//                 returnText: "Silahkan mengisi batas peminjaman",
//                 judul: "Tanggal Peminjaman",
//                 hintText: DateFormat('EE, dd/MMM/yy').format(
//                   DateTime.now(),
//                 ),
//                 icon: IconButton(
//                   onPressed: () {
//                     _showDatePicker();
//                   },
//                   icon: const Icon(
//                     MingCuteIcons.mgc_calendar_month_fill,
//                   ),
//                   color: const Color(0xFFB9B9B9),
//                 ),
//                 keyboardType: TextInputType.datetime,
//                 readOnly: true,
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: customFormPeminjaman(
//                       controller: _startTime,
//                       judul: "Awal Peminjaman",
//                       returnText: "Silahkan mengisi batas peminjaman",
//                       hintText: DateFormat('hh:mm a').format(
//                         DateTime.now(),
//                       ),
//                       icon: IconButton(
//                         onPressed: () {
//                           _showTimePicker(_startTime);
//                         },
//                         icon: const Icon(
//                           MingCuteIcons.mgc_time_fill,
//                         ),
//                         color: const Color(0xFFB9B9B9),
//                       ),
//                       keyboardType: TextInputType.datetime,
//                       readOnly: true,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 6.0,
//                   ),
//                   Expanded(
//                     child: customFormPeminjaman(
//                       controller: _endTime,
//                       judul: "Akhir Peminjaman",
//                       returnText: "Silahkan mengisi batas peminjaman",
//                       hintText: DateFormat('hh:mm a').format(
//                         DateTime.now(),
//                       ),
//                       icon: IconButton(
//                         onPressed: () {
//                           _showTimePicker(_endTime);
//                         },
//                         icon: const Icon(
//                           MingCuteIcons.mgc_time_fill,
//                         ),
//                         color: const Color(0xFFB9B9B9),
//                       ),
//                       keyboardType: TextInputType.datetime,
//                       readOnly: true,
//                     ),
//                   ),
//                 ],
//               ),
//               const customFormPeminjaman(
//                 judul: "Jumlah/Satuan",
//                 returnText:
//                     "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
//                 hintText: "Contoh: 2 Part",
//               ),
//               const customFormPeminjaman(
//                 judul: "Detail Keperluan",
//                 returnText: "Silahkan mengisi alasan keperluan dengan rinci",
//                 hintText: "Contoh: untuk memenuhi tugas mata kuliah",
//               ),
//               customFormPeminjaman(
//                 controller: _fileText,
//                 judul: "Desain Benda",
//                 returnText: "Silahkan mengisi masukan desain benda",
//                 hintText: "Tambahkan file",
//                 icon: IconButton(
//                   onPressed: () {
//                     _pickFile();
//                   },
//                   icon: const Icon(
//                     MingCuteIcons.mgc_upload_2_line,
//                   ),
//                   color: const Color(0xFFB9B9B9),
//                 ),
//                 keyboardType: TextInputType.datetime,
//                 readOnly: true,
//               ),
//               SizedBox(
//                 height: 11.0,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size(328, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () {},
//                   child: Text(
//                     "Submit",
//                     style: GoogleFonts.inter(
//                       fontSize: 16.0,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF6B7888),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
