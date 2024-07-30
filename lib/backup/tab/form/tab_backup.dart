import 'dart:io';
import 'package:build_app/page/home/form_peminjaman/form_penggunaan/utility/custom_form_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class TabForm extends StatefulWidget {
  const TabForm({
    super.key,
    required this.namaMesin,
    required this.keyForm,
  });

  final String namaMesin;

  // final Key? keyForm;
  final GlobalKey<FormState> keyForm;

  @override
  State<TabForm> createState() => _TabFormState();
}

class _TabFormState extends State<TabForm> with SingleTickerProviderStateMixin {
  final _formPeminjaman = GlobalKey<FormState>();
  final _formLaporanKerusakan = GlobalKey<FormState>();
  late TabController tabController;

  // bool isFormFilled = false;

  /* 0. FUNGSI UNTUK MENGATUR TAB CONTROLLER */
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

/* 1. FUNGSI UNTUK PEMILIHAN TANGGAL DAN WAKTU DI FORM PEMINJAMAN */
// Untuk memilih tanggal peminjaman
  void _showDatePicker() async {
    final DateTime now = DateTime.now();
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(
        () {
          _date.text = DateFormat('EE, d MMM yyyy').format(selectedDate);
          _startTime.clear();
          _endTime.clear();
        },
      );
    }
  }

// Untuk memilih waktu peminjaman
  void _showTimePicker(TextEditingController controller) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: now,
    );

    if (selectedTime != null) {
      final DateTime selectedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final DateTime? selectedDate = _date.text.isNotEmpty
          ? DateFormat('EE, d MMM yyyy').parse(_date.text)
          : null;

      if (selectedDate == null) {
        Get.snackbar("Peringatan", "Silakan pilih tanggal terlebih dahulu.");
        return;
      }

      final bool isSameDate = selectedDate.year == DateTime.now().year &&
          selectedDate.month == DateTime.now().month &&
          selectedDate.day == DateTime.now().day;

      // Jika tanggal yang dipilih sama dengan tanggal saat ini
      if (isSameDate) {
        final DateTime currentDateTime = DateTime.now();
        // Periksa apakah waktu yang dipilih sudah lewat
        if (selectedDateTime.isBefore(currentDateTime)) {
          Get.snackbar("Peringatan!",
              "Peminjaman tidak bisa dilakukan pada waktu yang sudah lewat.");
          return;
        }
      }

      // Validasi endTime harus setelah startTime
      if (controller == _endTime) {
        final TimeOfDay startTime = TimeOfDay.fromDateTime(
          DateFormat('hh:mm a').parse(_startTime.text),
        );
        final DateTime startDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          startTime.hour,
          startTime.minute,
        );
        final DateTime endDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Memeriksa apakah endTime setelah startTime
        if (endDateTime.isBefore(startDateTime) ||
            endDateTime.isAtSameMomentAs(startDateTime)) {
          Get.snackbar("Peringatan",
              "Waktu akhir peminjaman harus melebihi waktu awal peminjaman");
          return;
        }
      }

      setState(
        () {
          controller.text = selectedTime.format(context);
        },
      );
    }
  }

  /* 2. FUNGSI UNTUK MEMILIH WAKTU DAN TANGGAL KERUSAKAN */
  void _showDatePickerDamage() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(
        () {
          _dateKerusakan.text =
              DateFormat('EE, d MMM yyyy').format(selectedDate);
        },
      );
    }
  }

  // Fungsi untuk memilih waktu kerusakan
  void _showTimePickerDamage() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(
        () {
          _timeKerusakan.text = selectedTime.format(context);
        },
      );
    }
  }

  /* 3. FUNGSI UNTUK MEMILIH DESAIN BENDA */
  // Fungsi untuk memilih file dari PC
  List<String> pickedFileNames = [];

  Future<void> _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(
        () {
          if (kIsWeb) {
            pickedFileNames = result.files.map((file) => file.name).toList();
          } else {
            pickedFileNames =
                result.paths.map((path) => path!.split('/').last).toList();
          }
          // Menggabungkan nama file menjadi satu string
          _fileText.text = pickedFileNames.join(", ");
        },
      );
    }
  }

  // Fungsi untuk membuka file
  void openFile(File file) {
    OpenFile.open(file.path);
  }

  // Sebagai controller dari masing-masing fungsi
  final TextEditingController _date = TextEditingController();
  final TextEditingController _startTime = TextEditingController();
  final TextEditingController _endTime = TextEditingController();
  final TextEditingController _dateKerusakan = TextEditingController();
  final TextEditingController _timeKerusakan = TextEditingController();
  final TextEditingController _fileText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF757575), size: 20.0),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0, // agar appbar header tidak meninggalkan shadow
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Form(
          key: widget.keyForm, // _formPenggunaanCnc,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 23.0,
              vertical: 55.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Form Penggunaan ${widget.namaMesin}",
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B7888),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const customFormPeminjaman(
                  returnText: "Silahkan mengisi email",
                  judul: "Email",
                  hintText: "Contoh: ayu@mhs.polman-bandung.ac.id",
                  keyboardType: TextInputType.emailAddress,
                ),
                const customFormPeminjaman(
                  returnText: "Silahkan mengisi nama lengkap",
                  judul: "Nama Pemohon",
                  hintText: "contoh: Ayu Asahi",
                ),
                Text(
                  "Keperluan",
                  style: GoogleFonts.inter(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFF6B7888),
                  ),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                SizedBox(
                  height: 650.0,
                  child: Column(
                    children: [
                      Container(
                        // height: 52.0,
                        width: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TabBar(
                                labelColor: Colors.black,
                                unselectedLabelColor: const Color(0xFF6B7888),
                                indicatorColor: Colors.white,
                                indicatorWeight: 2,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                controller: tabController,
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                                tabs: const [
                                  Tab(text: 'Peminjaman'),
                                  Tab(text: 'Laporan Kerusakan'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            // Form Peminjaman
                            Form(
                              key: _formPeminjaman,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customFormPeminjaman(
                                      controller: _date,
                                      returnText:
                                          "Silahkan mengisi batas peminjaman",
                                      judul: "Tanggal Peminjaman",
                                      hintText:
                                          DateFormat('EE, dd/MMM/yy').format(
                                        DateTime.now(),
                                      ),
                                      icon: IconButton(
                                        onPressed: () {
                                          _showDatePicker();
                                        },
                                        icon: const Icon(
                                            MingCute.calendar_month_fill),
                                        color: const Color(0xFFB9B9B9),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: customFormPeminjaman(
                                            controller: _startTime,
                                            judul: "Awal Peminjaman",
                                            returnText:
                                                "Silahkan mengisi batas peminjaman",
                                            hintText:
                                                DateFormat('hh:mm a').format(
                                              DateTime.now(),
                                            ),
                                            icon: IconButton(
                                              onPressed: () {
                                                _showTimePicker(_startTime);
                                              },
                                              icon: const Icon(
                                                  MingCute.time_fill),
                                              color: const Color(0xFFB9B9B9),
                                            ),
                                            keyboardType:
                                                TextInputType.datetime,
                                            readOnly: true,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6.0,
                                        ),
                                        Expanded(
                                          child: customFormPeminjaman(
                                            controller: _endTime,
                                            judul: "Akhir Peminjaman",
                                            returnText:
                                                "Silahkan mengisi batas peminjaman",
                                            hintText:
                                                DateFormat('hh:mm a').format(
                                              DateTime.now(),
                                            ),
                                            icon: IconButton(
                                              onPressed: () {
                                                _showTimePicker(_endTime);
                                              },
                                              icon: const Icon(
                                                  MingCute.time_fill),
                                              color: const Color(0xFFB9B9B9),
                                            ),
                                            keyboardType:
                                                TextInputType.datetime,
                                            readOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const customFormPeminjaman(
                                      judul: "Jumlah/Satuan",
                                      returnText:
                                          "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
                                      hintText: "Contoh: 2 Part",
                                    ),
                                    const customFormPeminjaman(
                                      judul: "Detail Keperluan",
                                      returnText:
                                          "Silahkan mengisi alasan keperluan dengan rinci",
                                      hintText:
                                          "Contoh: untuk memenuhi tugas mata kuliah",
                                    ),
                                    customFormPeminjaman(
                                      controller: _fileText,
                                      judul: "Desain Benda",
                                      returnText:
                                          "Silahkan mengisi masukan desain benda",
                                      hintText: "Tambahkan file",
                                      icon: IconButton(
                                        onPressed: () {
                                          _pickFile();
                                        },
                                        icon:
                                            const Icon(MingCute.upload_2_line),
                                        color: const Color(0xFFB9B9B9),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 11.0,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(328, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          backgroundColor:
                                              const Color(0xFFEFF1F4),
                                        ),
                                        onPressed: () {
                                          // Memeriksa validitas form pada formPeminjaman
                                          if (widget.keyForm.currentState !=
                                                  null &&
                                              _formPeminjaman.currentState !=
                                                  null) {
                                            if (widget.keyForm.currentState!
                                                    .validate() &&
                                                _formPeminjaman.currentState!
                                                    .validate()) {
                                              // Lakukan tindakan setelah validasi berhasil
                                            }
                                          }
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomDialogWidget(),
                                          );
                                        },
                                        child: Text(
                                          "Submit",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6B7888),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Form Laporan Kerusakan
                            Form(
                              key: _formLaporanKerusakan,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 11.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const customFormPeminjaman(
                                      judul: "ID Order",
                                      returnText: "Silahkan mengisi ID Order",
                                      hintText: "Contoh: 290866",
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: customFormPeminjaman(
                                            controller: _dateKerusakan,
                                            judul: "Waktu Kerusakan",
                                            returnText:
                                                "Silahkan mengisi tanggal kerusakan",
                                            hintText:
                                                DateFormat('d/MM/yy').format(
                                              DateTime.now(),
                                            ),
                                            icon: IconButton(
                                              onPressed: () {
                                                _showDatePickerDamage();
                                              },
                                              icon: const Icon(
                                                  MingCute.calendar_month_fill),
                                              color: const Color(0xFFB9B9B9),
                                            ),
                                            keyboardType:
                                                TextInputType.datetime,
                                            readOnly: true,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 6.0,
                                        ),
                                        Expanded(
                                          child: customFormPeminjaman(
                                            controller: _timeKerusakan,
                                            judul: "",
                                            returnText:
                                                "Silahkan mengisi jam kerusakan",
                                            hintText: DateFormat('hh:mm a')
                                                .format(DateTime.now()),
                                            icon: IconButton(
                                              onPressed: () {
                                                _showTimePickerDamage();
                                              },
                                              icon: const Icon(
                                                  MingCute.time_fill),
                                              color: const Color(0xFFB9B9B9),
                                            ),
                                            keyboardType:
                                                TextInputType.datetime,
                                            readOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const customFormPeminjaman(
                                      judul: "Deskripsi Kerusakan Mesin",
                                      returnText:
                                          "Silahkan mengisi deskripsi kerusakan mesin",
                                      hintText: "Contoh: 2 Part",
                                    ),
                                    customFormPeminjaman(
                                      controller: _fileText,
                                      judul: "Bukti Kerusakan",
                                      returnText:
                                          "Silahkan mengisi bukti kerusakan",
                                      hintText: "Tambahkan file",
                                      icon: IconButton(
                                        onPressed: () {
                                          _pickFile();
                                        },
                                        icon:
                                            const Icon(MingCute.upload_2_line),
                                        color: const Color(0xFFB9B9B9),
                                      ),
                                      keyboardType: TextInputType.datetime,
                                      readOnly: true,
                                    ),
                                    const SizedBox(
                                      height: 11.0,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(328, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          backgroundColor:
                                              const Color(0xFFEFF1F4),
                                        ),
                                        onPressed: () {
                                          // Memeriksa validitas form pada formPeminjaman
                                          if (widget.keyForm.currentState!
                                                  .validate() ||
                                              _formLaporanKerusakan
                                                  .currentState!
                                                  .validate()) {}
                                        },
                                        child: Text(
                                          "Submit",
                                          style: GoogleFonts.inter(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF6B7888),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Pop Up Dialog
class CustomDialogWidget extends StatefulWidget {
  const CustomDialogWidget({super.key});

  @override
  State<CustomDialogWidget> createState() => _CustomDialogWidgetState();
}

class _CustomDialogWidgetState extends State<CustomDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          const CardDialog(),
          Positioned(
            top: 0.0,
            right: 0.0,
            height: 28.0,
            width: 28.0,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(8.0),
                  shape: const CircleBorder(),
                  backgroundColor: const Color(0xFFEC5B5B)),
              child: Image.asset("assets/images/close.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  const CardDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 16.0,
      ),
      margin: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: const Color(
            0xFFEDF9FE), //const Color(0xFFCEE5EF) //const Color(0xFFD9D9D9) //const Color(0XFF2a303e)
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/alert.png",
            width: 72.0,
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "Peringatan!",
            style: GoogleFonts.montserrat(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFEC5B5B),
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),
          Text(
            "Apakah data yang diisi sudah sesuai?",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 32.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 32.0,
                  ),
                  foregroundColor: const Color(0xFFEC5B5B),
                  side: const BorderSide(
                    color: Color(0xFFEC5B5B),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Batal",
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: const Color(0xFF5BEC84),
                  foregroundColor: const Color(0xFF2A303E),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 32.0,
                  ),
                ),
                onPressed: () {},
                child: const Text("Ya"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/* BACK UP FUNGSI SHOW UP TIME PICKER 1,
  // void _showTimePicker(TextEditingController controller) async {
  //   final TimeOfDay now = TimeOfDay.now();
  //   final TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: now,
  //   );

  //   if (selectedTime != null) {
  //     // Validasi untuk jam yang sama hari ini
  //     final DateTime selectedDateTime = DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //       selectedTime.hour,
  //       selectedTime.minute,
  //     );
  //     if (selectedDateTime.isBefore(DateTime.now()) &&
  //         !selectedDateTime.isAtSameMomentAs(DateTime.now())) {
  //       Get.snackbar(
  //         "Peringatan!",
  //         "Peminjaman tidak bisa dilakukan pada saat ini juga.",
  //       );
  //       return;
  //     }

  //     // Validasi endTime harus setelah startTime
  //     if (controller == _endTime) {
  //       final DateTime? selectedStartDate = _date.text.isNotEmpty
  //           ? DateFormat('EE, d MMM yyyy').parse(_date.text)
  //           : null;
  //       if (selectedStartDate == null) {
  //         Get.snackbar(
  //           "Peringatan",
  //           "Silakan pilih tanggal terlebih dahulu.",
  //         );
  //         return;
  //       }

  //       final TimeOfDay startTime = TimeOfDay.fromDateTime(
  //           DateFormat('hh:mm a').parse(_startTime.text));
  //       final DateTime startDateTime = DateTime(
  //         selectedStartDate.year,
  //         selectedStartDate.month,
  //         selectedStartDate.day,
  //         startTime.hour,
  //         startTime.minute,
  //       );
  //       final DateTime endDateTime = DateTime(
  //         selectedStartDate.year,
  //         selectedStartDate.month,
  //         selectedStartDate.day,
  //         selectedTime.hour,
  //         selectedTime.minute,
  //       );

  //       // Memeriksa apakah endTime setelah startTime
  //       if (endDateTime.isBefore(startDateTime) ||
  //           endDateTime.isAtSameMomentAs(startDateTime)) {
  //         Get.snackbar(
  //           "Peringatan",
  //           "Waktu akhir peminjaman harus melebihi waktu awal peminjaman",
  //         );
  //         return;
  //       }
  //     }

  //     setState(() {
  //       controller.text = selectedTime.format(context);
  //     });
  //   }
  // }
*/

/* BACKUP 2,

  // METODE 2,
  // void _showTimePicker(TextEditingController controller) async {
  //   final TimeOfDay now = TimeOfDay.now();
  //   final TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: now,
  //   );

  //   if (selectedTime != null) {
  //     final DateTime selectedDateTime = DateTime(
  //       DateTime.now().year,
  //       DateTime.now().month,
  //       DateTime.now().day,
  //       selectedTime.hour,
  //       selectedTime.minute,
  //     );

  //     // Cek apakah tanggal yang dipilih sama dengan tanggal saat ini
  //     final DateTime currentDate = DateTime.now();
  //     final bool isSameDate = selectedDateTime.year == currentDate.year &&
  //         selectedDateTime.month == currentDate.month &&
  //         selectedDateTime.day == currentDate.day;

  //     // Validasi agar peminjaman tidak dilakukan pada waktu yang sudah berlalu
  //     if (!isSameDate || selectedDateTime.isAfter(DateTime.now())) {
  //       // Validasi endTime harus setelah startTime
  //       if (controller == _endTime) {
  //         final DateTime? selectedStartDate = _date.text.isNotEmpty
  //             ? DateFormat('EE, d MMM yyyy').parse(_date.text)
  //             : null;
  //         if (selectedStartDate == null) {
  //           Get.snackbar(
  //             "Peringatan",
  //             "Silakan pilih tanggal terlebih dahulu.",
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
  //           Get.snackbar(
  //             "Peringatan",
  //             "Waktu akhir peminjaman harus melebihi waktu awal peminjaman",
  //           );
  //           return;
  //         }
  //       }

  //       setState(() {
  //         controller.text = selectedTime.format(context);
  //       });
  //     }
  //   }
  // }
*/

// // Untuk memilih tanggal peminjaman
// void _showDatePicker() async {
//   final DateTime now = DateTime.now();
//   final DateTime? selectedDate = await showDatePicker(
//     context: context,
//     initialDate: now,
//     firstDate: now,
//     lastDate: DateTime(2100),
//   );

//   if (selectedDate != null) {
//     final TimeOfDay currentTime = TimeOfDay.now();
//     // Validasi agar pengguna dapat memilih tanggal yang sama dengan hari ini
//     // tetapi waktu tidak sama dengan waktu saat ini
//     if (selectedDate.year == now.year &&
//         selectedDate.month == now.month &&
//         selectedDate.day == now.day &&
//         selectedDate.hour == currentTime.hour &&
//         selectedDate.minute == currentTime.minute) {
//       // Jika waktu yang dipilih sama dengan waktu saat ini, tambahkan 1 menit
//       final DateTime nextMinute = now.add(const Duration(minutes: 1));
//       setState(() {
//         _date.text = DateFormat('EE, d MMM yyyy').format(selectedDate);
//         _startTime.text = '${nextMinute.hour}:${nextMinute.minute}';
//       });
//     } else {
//       setState(() {
//         _date.text = DateFormat('EE, d MMM yyyy').format(selectedDate);
//       });
//     }
//   }
// }

// // Untuk memilih waktu peminjaman
// void _showTimePicker(TextEditingController controller) async {
//   final TimeOfDay now = TimeOfDay.now();
//   final TimeOfDay? selectedTime = await showTimePicker(
//     context: context,
//     initialTime: now,
//   );

//   if (selectedTime != null) {
//     final DateTime selectedDateTime = DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//       selectedTime.hour,
//       selectedTime.minute,
//     );

//     // Cek apakah tanggal yang dipilih sama dengan tanggal saat ini
//     final DateTime currentDate = DateTime.now();
//     final bool isSameDate = selectedDateTime.year == currentDate.year &&
//         selectedDateTime.month == currentDate.month &&
//         selectedDateTime.day == currentDate.day;

//     // Jika tanggalnya sama dengan hari ini, periksa apakah waktu sudah lewat
//     if (isSameDate && selectedDateTime.isBefore(DateTime.now())) {
//       Get.snackbar(
//         "Peringatan!",
//         "Peminjaman tidak bisa dilakukan pada waktu yang sudah lewat.",
//       );
//       return;
//     }

//     // Validasi endTime harus setelah startTime
//     if (controller == _endTime) {
//       final DateTime? selectedStartDate = _date.text.isNotEmpty
//           ? DateFormat('EE, d MMM yyyy').parse(_date.text)
//           : null;
//       if (selectedStartDate == null) {
//         Get.snackbar(
//           "Peringatan",
//           "Silakan pilih tanggal terlebih dahulu.",
//         );
//         return;
//       }

//       final TimeOfDay startTime = TimeOfDay.fromDateTime(
//           DateFormat('hh:mm a').parse(_startTime.text));
//       final DateTime startDateTime = DateTime(
//         selectedStartDate.year,
//         selectedStartDate.month,
//         selectedStartDate.day,
//         startTime.hour,
//         startTime.minute,
//       );
//       final DateTime endDateTime = DateTime(
//         selectedStartDate.year,
//         selectedStartDate.month,
//         selectedStartDate.day,
//         selectedTime.hour,
//         selectedTime.minute,
//       );

//       // Memeriksa apakah endTime setelah startTime
//       if (endDateTime.isBefore(startDateTime) ||
//           endDateTime.isAtSameMomentAs(startDateTime)) {
//         Get.snackbar(
//           "Peringatan",
//           "Waktu akhir peminjaman harus melebihi waktu awal peminjaman",
//         );
//         return;
//       }
//     }

//     setState(() {
//       controller.text = selectedTime.format(context);
//     });
//   }
// }
