import 'dart:io';
import 'package:build_app/controller/peminjaman_controller.dart';
import 'package:build_app/page/home/form_peminjaman/widget/custom_form_page.dart';
import 'package:build_app/page/widget/custom_buttom_nav.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:open_file/open_file.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class formPenggunaanLasercut extends StatefulWidget {
  @override
  State<formPenggunaanLasercut> createState() => _formPenggunaanLasercutState();
}

class _formPenggunaanLasercutState extends State<formPenggunaanLasercut> {
  final PeminjamanController _peminjamanC = Get.put(PeminjamanController());
  final _formPeminjamanLasercut = GlobalKey<FormState>();

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
          _peminjamanC.tanggalC.text =
              DateFormat('EE, d MMM yyyy').format(selectedDate);
          _peminjamanC.awalC.clear();
          _peminjamanC.akhirC.clear();
        },
      );
    }
  }

  // Untuk memilih waktu peminjaman
  void _showDayNightTimePicker(TextEditingController controller) {
    TimeOfDay now = TimeOfDay.now();
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: Time(
            hour: now.hour, minute: now.minute), // Convert TimeOfDay to Time
        onChange: (Time newTime) {
          // Validasi minute interval
          if (newTime.minute != 0 && newTime.minute != 30) {
            Get.snackbar(
              "Invalid Time",
              'Please select a time with 0 or 30 minute intervals',
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return;
          }

          final TimeOfDay selectedTime = newTime.toTimeOfDay();

          final DateTime selectedDateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            selectedTime.hour,
            selectedTime.minute,
          );

          final DateTime? selectedDate = _peminjamanC.tanggalC.text.isNotEmpty
              ? DateFormat('EE, d MMM yyyy').parse(_peminjamanC.tanggalC.text)
              : null;

          if (selectedDate == null) {
            Get.snackbar(
                "Peringatan", "Silakan pilih tanggal terlebih dahulu.");
            return;
          }

          final bool isSameDate = selectedDate.year == DateTime.now().year &&
              selectedDate.month == DateTime.now().month &&
              selectedDate.day == DateTime.now().day;

          if (isSameDate) {
            final DateTime currentDateTime = DateTime.now();
            if (selectedDateTime.isBefore(currentDateTime)) {
              Get.snackbar("Peringatan!",
                  "Peminjaman tidak bisa dilakukan pada waktu yang sudah lewat.");
              return;
            }
          }

          if (controller == _peminjamanC.akhirC) {
            final TimeOfDay startTime = TimeOfDay.fromDateTime(
              DateFormat('hh:mm a').parse(_peminjamanC.awalC.text),
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

            if (endDateTime.isBefore(startDateTime) ||
                endDateTime.isAtSameMomentAs(startDateTime)) {
              Get.snackbar("Peringatan",
                  "Waktu akhir peminjaman harus melebihi waktu awal peminjaman");
              return;
            }
          }

          setState(() {
            controller.text = selectedTime.format(context);
          });
        },
        is24HrFormat: false,
        minHour: 7,
        maxHour: 20,
        minMinute: 0,
        minuteInterval: TimePickerInterval.THIRTY,
        sunAsset: Image.asset("assets/images/sun.png"),
        moonAsset: Image.asset("assets/images/moon.png"),
        barrierDismissible: false,
        iosStylePicker: true,
      ),
    );
  }

  /* 2. FUNGSI UNTUK MEMILIH DESAIN BENDA */
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
  // final TextEditingController _date = TextEditingController();
  // final TextEditingController _startTime = TextEditingController();
  // final TextEditingController _endTime = TextEditingController();
  final TextEditingController _fileText = TextEditingController();

  // Fungsi untuk mereset form
  void _resetForm() {
    _formPeminjamanLasercut.currentState?.reset();
    _peminjamanC.resetFormFields();
    setState(() {
      _selectedProgramStudi = null;
      _selectedKategori = null;
      _selectedDetail = null;
    });
  }

  // Method: Validasi Form
  void _validateForm() {
    if (_formPeminjamanLasercut.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => CustomDialogWidget(
          onConfirmed: () {
            _peminjamanC.peminjamanLaserButton().then((success) {
              if (success) {
                _resetForm();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => afterSubmit(),
                  ),
                );
              }
            });
          },
        ),
      );
    } else {
      Get.snackbar(
          'Peringatan', 'Silahkan isi form dengan benar sebelum submit');
    }
  }

  // List untuk Dropdown jurusan
  final List<String> jurusanOptions = ['AE', 'DE', 'FE', 'ME', 'Lainnya'];

  // List untuk Dropdown detail program studi
  final Map<String, List<String>> programStudiOptions = {
    'AE': ['TRMO', 'TRO', 'TRIN'],
    'DE': ['TPPP', 'RPM', 'TRPM'],
    'FE': ['TPL', 'TRMM'],
    'ME': ['MM', 'TM', 'TMU', 'TRM', 'MTR'],
  };

  // list kedua kategori peminjaman
  final List<String> kategoriOptions = [
    'Proyek Mata Kuliah',
    'Praktek',
    'Tugas Akhir',
    'Proyek Akhir'
  ];

  // List lanjutan untuk keperluan tertentu
  final Map<String, Map<String, List<String>>> detailOptions = {
    // AUTOMATION ENGINEERING
    'TRMO': {
      'Proyek Mata Kuliah': [
        'Rangkaian Elektrik',
        'Instrumentasi dan Pengukuran',
        'Gambar Teknik',
        'Algoritma dan Pemograman',
        'Digital dan Mikroprosesor',
        'Elektronika',
        'Proses Manufaktur Mekanik 1',
        'Teknik Kendali',
        'Sensor dan Aktuator',
        'Proses Manufaktur Elektrik',
        'Proses Manufaktur Mekanik 2',
        'Mikrokontroller dan Antarmuka',
        'Pemrogaman Aplikasi',
        'Otomasi Industri 1',
        'Pemeliharaan',
        'Elektronika Daya',
        'Otomasi Industri 2',
        'Pengembangan Produk Mekatronika',
        'Komunikasi Data',
        'Kendali Cerdas',
        'Kapita Selekta Mekatronika',
      ],
      'Praktek': [
        'Praktek Rangkaian Elektrik',
        'Praktek Instrumentasi dan Pengukuran',
        'Praktek Gambar Teknik',
        'Praktek Algoritma dan Pemograman',
        'Praktek Digital dan Mikroprosesor',
        'Praktek Elektronika',
        'Praktek Proses Manufaktur Mekanik 1',
        'Praktek Teknik Kendali',
        'Praktek Sensor dan Aktuator',
        'Praktek Proses Manufaktur Elektrik',
        'Praktek Proses Manufaktur Mekanik 2',
        'Praktek Mikrokontroller dan Antarmuka',
        'Praktek Pemrogaman Aplikasi',
        'Praktek Otomasi Industri 1',
        'Praktek Pemeliharaan',
        'Praktek Elektronika Daya',
        'Praktek Otomasi Industri 2',
        'Praktek Pengembangan Produk Mekatronika',
        'Praktek Komunikasi Data',
        'Praktek Kendali Cerdas',
        'Praktek Kapita Selekta Mekatronika',
      ],
    },
    'TRO': {
      'Proyek Mata Kuliah': [
        'Elektronika Otomasi Industri',
        'Gambar Teknik Sistem Otomasi',
        'Metrologi Otomasi',
        'Logika dan Pemrog. Komputer',
        'Digital dan Mikrokontroller',
        'Proses Manufaktur 1',
        'Teknik Mesin & CAD',
        'Kendali Motor Listrik',
        'Pemrograman Labview',
        'Kontrol Pneumatik dan Hidrolik',
        'Proses Manufaktur 2',
        'Pemodelan dan Simulasi',
        'Akuisisi Data dan Instrumentasi',
        'Pemrograman PLC dan HMI',
        'Komunikasi Data',
        'Sistem Kendali Proses',
        'SDCS',
        'PPC Sistem Otomasi',
        'Enterprise Automation',
      ],
      'Praktek': [
        'Praktek Elektronika Otomasi Industri',
        'Praktek Gambar Teknik Sistem Otomasi',
        'Praktek Metrologi Otomasi',
        'Praktek Logika dan Pemrog. Komputer',
        'Praktek Digital dan Mikrokontroller',
        'Praktek Proses Manufaktur 1',
        'Praktek Teknik Mesin & CAD',
        'Praktek Kendali Motor Listrik',
        'Praktek Pemrograman Labview',
        'Praktek Kontrol Pneumatik dan Hidrolik',
        'Praktek Proses Manufaktur 2',
        'Praktek Pemodelan dan Simulasi',
        'Praktek Akuisisi Data dan Instrumentasi',
        'Praktek Pemrograman PLC dan HMI',
        'Praktek Komunikasi Data',
        'Praktek Sistem Kendali Proses',
        'Praktek SDCS',
        'Praktek PPC Sistem Otomasi',
        'Praktek Enterprise Automation',
      ],
    },
    'TRIN': {
      'Proyek Mata Kuliah': [
        'Proses Manufaktur Dasar',
        'Pemrograman Komputer',
        'Sistem Basis Data',
        'Aplikasi Komputasi Awan',
        'Kontrol Logika Terprogram (PLC)',
        'Pemrograman Struktur Data',
        'Basis Data NoSQL',
        'Pemrograman Berorientasi Objek',
        'Mikrontroller (Arduino)',
        'Pemrograman Web',
        'Akusisi Data',
        'Sistem Tertanam',
        'Komputasi Bergerak',
        'Komunikasi Data (IIoT)',
        'Sistem Operasi',
        'Sistem Kendali Proses',
        'SDCS',
        'PPC Sistem Otomasi',
        'Enterprise Automation',
      ],
      'Praktek': [
        'Praktek Proses Manufaktur Dasar',
        'Praktek Pemrograman Komputer',
        'Praktek Sistem Basis Data',
        'Praktek Aplikasi Komputasi Awan',
        'Praktek Kontrol Logika Terprogram (PLC)',
        'Praktek Pemrograman Struktur Data',
        'Praktek Basis Data NoSQL',
        'Praktek Pemrograman Berorientasi Objek',
        'Praktek Mikrontroller (Arduino)',
        'Praktek Pemrograman Web',
        'Praktek Akusisi Data',
        'Praktek Sistem Tertanam',
        'Praktek Komputasi Bergerak',
        'Praktek Komunikasi Data (IIoT)',
        'Praktek Sistem Operasi',
        'Praktek Sistem Kendali Proses',
        'Praktek SDCS',
        'Praktek PPC Sistem Otomasi',
        'Praktek Enterprise Automation',
      ],
    },
    // DESIGN ENGINEERING
    'TPPP': {
      'Proyek Mata Kuliah': [
        'Logika dan Pemrogaman Komputer',
        'Gambar Teknik dan CAD',
        'Proses Manufaktur 1',
        'Olahraga',
        'Proses Manufaktur 2',
        'Gambar Teknik Perkakas Presisi',
        'CAD untuk Perkakas Presisi',
        'Perancangan Mekanik Dasar',
        'Pengukuran dan  Pemeriksaan',
        'Peracangan Jigs & Mixture 1',
        'Perancangan Cetakan Plastik 1',
        'Peracangan Press Tool 1',
        'Peracangan Jigs & Mixture 2',
        'Perancangan Cetakan Plastik 2',
        'Peracangan Press Tool 2',
        'Desain Perancangan Mekanik Project',
        'Manajemen Biro Konstruksi Perkakas Presisi',
      ],
      'Praktek': [
        'Praktek Logika dan Pemrogaman Komputer',
        'Praktek Gambar Teknik dan CAD',
        'Praktek Proses Manufaktur 1',
        'Praktek Olahraga',
        'Praktek Proses Manufaktur 2',
        'Praktek Gambar Teknik Perkakas Presisi',
        'Praktek CAD untuk Perkakas Presisi',
        'Praktek Perancangan Mekanik Dasar',
        'Praktek Pengukuran dan  Pemeriksaan',
        'Praktek Peracangan Jigs & Mixture 1',
        'Praktek Perancangan Cetakan Plastik 1',
        'Praktek Peracangan Press Tool 1',
        'Praktek Peracangan Jigs & Mixture 2',
        'Praktek Perancangan Cetakan Plastik 2',
        'Praktek Peracangan Press Tool 2',
        'Praktek Desain Perancangan Mekanik Project',
        'Praktek Manajemen Biro Konstruksi Perkakas Presisi',
      ],
    },
    'RPM': {
      'Proyek Mata Kuliah': [
        'Elemen Mesin 1',
        'Proses Manufaktur 1',
        'Gambar Teknik dan CAD',
        'Proses Manufaktur 2',
        'CAD Perancangan Mekanik 1',
        'Gambar Teknik Mekanik',
        'Peracangan Konstruksi Mekanik 1',
        'Material Teknik',
        'Proses Manufaktur 3',
        'CAD Perancangan Mekanik 2',
        'Peracangan Konstruksi Mekanik 2',
        'Peracangan Peralatan Penanganan Material 1',
        'Peracangan Konstruksi Otomasi',
        'Peracangan Peralatan Penanganan Material 2',
        'Metrologi Produk Mekanik',
        'Proses Manufaktur 4',
        'Perancangan Mesin Perkakas',
        'Perancangan Mesin Khusus',
        'Kewirusahaan & Manajemen Proyek',
        'Proyek Desain Mekanik',
        'Perencanaan dan Pengendalian Produksi',
        'Manajemen Biro Konstruksi',
      ],
      'Praktek': [
        'Praktek Elemen Mesin 1',
        'Praktek Proses Manufaktur 1',
        'Praktek Gambar Teknik dan CAD',
        'Praktek Proses Manufaktur 2',
        'Praktek CAD Perancangan Mekanik 1',
        'Praktek Gambar Teknik Mekanik',
        'Praktek Peracangan Konstruksi Mekanik 1',
        'Praktek Material Teknik',
        'Praktek Proses Manufaktur 3',
        'Praktek CAD Perancangan Mekanik 2',
        'Praktek Peracangan Konstruksi Mekanik 2',
        'Praktek Peracangan Peralatan Penanganan Material 1',
        'Praktek Peracangan Konstruksi Otomasi',
        'Praktek Peracangan Peralatan Penanganan Material 2',
        'Praktek Metrologi Produk Mekanik',
        'Praktek Proses Manufaktur 4',
        'Praktek Perancangan Mesin Perkakas',
        'Praktek Perancangan Mesin Khusus',
        'Praktek Kewirusahaan & Manajemen Proyek',
        'Praktek Proyek Desain Mekanik',
        'Praktek Perencanaan dan Pengendalian Produksi',
        'Praktek Manajemen Biro Konstruksi',
      ],
    },
    // MANUFACTURE ENGINEERING
    'MM': {
      'Proyek Mata Kuliah': [
        'Metrologi Industri Perawatan dan Perbaikan Mesin',
        'Gambar Teknik',
        'Proses Manufaktur 1',
        'Instalasi Kelistrikan pada Mesin 1	',
        'Teknik Pemeliharaan Mesin 1',
        'Proses Manufaktur 2',
        'Logika & Program Komputer',
        'Teknik Pemeliharaan Mesin 2',
        'Instalasi Kelistrikan pada Mesin 2',
        'Perbaikan Mesin 1',
        'Otomatisasi 1',
        'Pembuatan Suku Cadang',
        'Pengetahuan Mesin',
        'Teknik Pemeliharaan Mesin 3	',
        'Perbaikan Mesin 2',
        'Perencanaan & Pengendalian Perawatan dan Perbaikan Mesin	',
        'Otomatisasi 2',
        'Mekatronika',
        'Teknik Pemeliharaan Mesin 4',
        'Proses Manufaktur 3',
        'Perbaikan Mesin 3',
      ],
      'Praktek': [
        'Praktek Metrologi Industri Perawatan dan Perbaikan Mesin',
        'Praktek Gambar Teknik',
        'Praktek Proses Manufaktur 1',
        'Praktek Instalasi Kelistrikan pada Mesin 1	',
        'Praktek Teknik Pemeliharaan Mesin 1',
        'Praktek Proses Manufaktur 2',
        'Praktek Logika & Program Komputer',
        'Praktek Teknik Pemeliharaan Mesin 2',
        'Praktek Instalasi Kelistrikan pada Mesin 2',
        'Praktek Perbaikan Mesin 1',
        'Praktek Otomatisasi 1',
        'Praktek Pembuatan Suku Cadang',
        'Praktek Pengetahuan Mesin',
        'Praktek Teknik Pemeliharaan Mesin 3	',
        'Praktek Perbaikan Mesin 2',
        'Praktek Perencanaan & Pengendalian Perawatan dan Perbaikan Mesin	',
        'Praktek Otomatisasi 2',
        'Praktek Mekatronika',
        'Praktek Teknik Pemeliharaan Mesin 4',
        'Praktek Proses Manufaktur 3',
        'Praktek Perbaikan Mesin 3',
      ]
    },
    'TM': {
      'Proyek Mata Kuliah': [
        'Metrologi Industri',
        'Proses Manufaktur 1',
        'Gambar Teknik',
        'Manajemen Alat',
        'Proses Manufaktur 2',
        'Proses Manufaktur 3',
        'Sistem Daya Listrik',
        'Praktek Material Teknik 1',
        'CAD/CAM',
        'Proses Pemesinan',
        'Perancangan Mekanik ',
        'Logika dan Pemrograman Komputer',
        'Sistem Manufaktur',
        'Sistem Kendali ',
        'Teknologi Peralatan Industri',
        'Perakitan Komponen Mesin',
        'Pembuatan Peralatan Mekanik (Pembuatan Mesin)',
      ],
      'Praktek': [
        'Praktek Metrologi Industri',
        'Praktek Proses Manufaktur 1',
        'Praktek Gambar Teknik',
        'Praktek Manajemen Alat',
        'Praktek Proses Manufaktur 2',
        'Praktek Proses Manufaktur 3',
        'Praktek Sistem Daya Listrik',
        'Praktek Praktek Material Teknik 1',
        'Praktek CAD/CAM',
        'Praktek Proses Pemesinan',
        'Praktek Perancangan Mekanik ',
        'Praktek Logika dan Pemrograman Komputer',
        'Praktek Sistem Manufaktur',
        'Praktek Sistem Kendali ',
        'Praktek Teknologi Peralatan Industri',
        'Praktek Perakitan Komponen Mesin',
        'Praktek Pembuatan Peralatan Mekanik (Pembuatan Mesin)',
      ]
    },
    'TMU': {
      'Proyek Mata Kuliah': [
        'Proses Manufaktur Dasar 1',
        'Proses Manufaktur Dasar 3',
        'CNC 1',
        'Gambar Teknik Mesin',
        'Proses Manufaktur Dasar 2',
        'Proses Manufaktur Dasar 4',
        'CNC 2',
        'Analisis Perkakas',
        'Konstruksi Perkakas 1',
        'Desain Perkakas 1',
        'Konstruksi Perkakas 2',
        'Konstruksi Perkakas 3',
        'Pemrogaman Komputer',
        'Pneumatik & Hidrolik',
        'Desain Perkakas 2',
      ],
      'Praktek': [
        'Praktek Proses Manufaktur Dasar 1',
        'Praktek Proses Manufaktur Dasar 3',
        'Praktek CNC 1',
        'Praktek Gambar Teknik Mesin',
        'Praktek Proses Manufaktur Dasar 2',
        'Praktek Proses Manufaktur Dasar 4',
        'Praktek CNC 2',
        'Praktek Analisis Perkakas',
        'Praktek Konstruksi Perkakas 1',
        'Praktek Desain Perkakas 1',
        'Praktek Konstruksi Perkakas 2',
        'Praktek Konstruksi Perkakas 3',
        'Praktek Pemrogaman Komputer',
        'Praktek Pneumatik & Hidrolik',
        'Praktek Desain Perkakas 2',
      ]
    },
    'TRM': {
      'Proyek Mata Kuliah': [
        'Proses Manufaktur 1',
        'CTS',
        'Gambar Teknik 1',
        'Proses Manufaktur 2	',
        'CAD CAM CNC1',
        'Gambar Teknik 2',
        'Material Teknik (P)	',
        'CAD CAM CNC 2',
        'Praktik General Mekanik',
        'Pabrikasi',
        'Gambar Teknik 3	',
        'Kelistrikan Dasar',
        'Logika dan Pemrograman Komputer',
        'Kelistrikan Lanjut	',
        'Pneumatik dan Hidrolik',
        'Pembuatan Suku Cadang	',
        'CAD CAM CNC 3',
        'PPC',
        'PLC',
        'PMD',
        'Pemesinan Khusus',
        'Kinematik',
        'SQC',
        'FMS',
        'Konstruksi Mesin',
        'CAD CAM CNC 5-axis',
        'CAE',
        'Advance Manufacturing Process',
        'Sistem Otomasi Manufaktur',
      ],
      'Praktek': [
        'Praktek Proses Manufaktur 1',
        'Praktek CTS',
        'Praktek Gambar Teknik 1',
        'Praktek Proses Manufaktur 2	',
        'Praktek CAD CAM CNC1',
        'Praktek Gambar Teknik 2',
        'Praktek Material Teknik (P)	',
        'Praktek CAD CAM CNC 2',
        'Praktek Praktik General Mekanik',
        'Praktek Pabrikasi',
        'Praktek Gambar Teknik 3	',
        'Praktek Kelistrikan Dasar',
        'Praktek Logika dan Pemrograman Komputer',
        'Praktek Kelistrikan Lanjut	',
        'Praktek Pneumatik dan Hidrolik',
        'Praktek Pembuatan Suku Cadang	',
        'Praktek CAD CAM CNC 3',
        'Praktek PPC',
        'Praktek PLC',
        'Praktek PMD',
        'Praktek Pemesinan Khusus',
        'Praktek Kinematik',
        'Praktek SQC',
        'Praktek FMS',
        'Praktek Konstruksi Mesin',
        'Praktek CAD CAM CNC 5-axis',
        'Praktek CAE',
        'Praktek Advance Manufacturing Process',
        'Praktek Sistem Otomasi Manufaktur',
      ],
    },
    'MTR': {
      'Proyek Mata Kuliah': [
        'Gambar Teknik Mesin (CAD)',
        'Sistem Rekayasa/Manufaktur',
        'Dasar Listrik',
        'Fisika Lanjut',
        'Teknologi Manufaktur, Konsep Teknologi',
        'Kimia Lingkungan',
        'Technical Graphics with CAD',
        'PSI Industri dan Organisasi',
        'Pengenalan Mekanika Material',
        'PPC',
        'Pengenalan Proses Manufaktur',
        'Ekonomi Teknik',
        'Manajemen Mutu',
        'Manajemen Pemasaran',
        'Manajemen Operasi',
        'Kerekayasaan Tata Letak dan Fasilitas',
        'Metodologi Penelitian',
        'Lean Manufacturing System',
        'Manajemen Proyek',
        'Otomasi Manufaktur',
        'Proyek kewirausahaan',
        'Manajemen Strategik dan Rekayasa',
        'Teknik Komunikasi Profesional',
        'Riset dan Pengembangan Teknologi',
      ],
      'Praktek': [
        'Praktek Gambar Teknik Mesin (CAD)',
        'Praktek Sistem Rekayasa/Manufaktur',
        'Praktek Dasar Listrik',
        'Praktek Fisika Lanjut',
        'Praktek Teknologi Manufaktur, Konsep Teknologi',
        'Praktek Kimia Lingkungan',
        'Praktek Technical Graphics with CAD',
        'Praktek PSI Industri dan Organisasi',
        'Praktek Pengenalan Mekanika Material',
        'Praktek PPC',
        'Praktek Pengenalan Proses Manufaktur',
        'Praktek Ekonomi Teknik',
        'Praktek Manajemen Mutu',
        'Praktek Manajemen Pemasaran',
        'Praktek Manajemen Operasi',
        'Praktek Kerekayasaan Tata Letak dan Fasilitas',
        'Praktek Metodologi Penelitian',
        'Praktek Lean Manufacturing System',
        'Praktek Manajemen Proyek',
        'Praktek Otomasi Manufaktur',
        'Praktek Proyek kewirausahaan',
        'Praktek Manajemen Strategik dan Rekayasa',
        'Praktek Teknik Komunikasi Profesional',
        'Praktek Riset dan Pengembangan Teknologi',
      ],
    },
  };

  String? _selectedJurusan;
  String? _selectedProgramStudi;
  String? _selectedKategori;
  String? _selectedDetail;

  // Kondisi untuk jurusan FE dan kategori tertentu
  bool _isManualInputRequired() {
    return (_selectedJurusan == 'FE' &&
            (_selectedKategori == 'Proyek Mata Kuliah' ||
                _selectedKategori == 'Praktek')) ||
        (_selectedJurusan == 'Lainnya'); // Tambahkan kondisi untuk "Lainnya"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Color(0xFF757575),
          size: 20.0,
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0, // agar appbar header tidak meninggalkan shadow
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 23.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 55.0,
              ),
              Text(
                "Form Peminjaman CNC Milling",
                style: GoogleFonts.inter(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B7888),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Form(
                key: _formPeminjamanLasercut,
                child: Column(
                  children: [
                    customFormPeminjaman(
                      controller: _peminjamanC.emailC,
                      returnText: "Silahkan mengisi email",
                      judul: "Email",
                      hintText: "Contoh: ayu@mhs.polman-bandung.ac.id",
                      keyboardType: TextInputType.emailAddress,
                    ),
                    customFormPeminjaman(
                      controller: _peminjamanC.namaC,
                      returnText: "Silahkan mengisi nama lengkap",
                      judul: "Nama Pemohon",
                      hintText: "contoh: Ayu Asahi",
                    ),
                    customFormPeminjaman(
                      controller: _peminjamanC.tanggalC,
                      returnText: "Silahkan mengisi batas peminjaman",
                      judul: "Tanggal Peminjaman",
                      hintText: DateFormat('EE, dd/MMM/yy').format(
                        DateTime.now(),
                      ),
                      icon: IconButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        icon: const Icon(
                          MingCuteIcons.mgc_calendar_month_fill,
                        ),
                        //Iconify(Ion.calendar),
                        color: const Color(0xFFB9B9B9),
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: customFormPeminjaman(
                            controller: _peminjamanC.awalC,
                            judul: "Awal Peminjaman",
                            returnText: "Silahkan mengisi batas peminjaman",
                            hintText: DateFormat('hh:mm a').format(
                              DateTime.now(),
                            ),
                            icon: IconButton(
                              onPressed: () {
                                _showDayNightTimePicker(_peminjamanC.awalC);
                              },
                              icon: const Icon(
                                MingCuteIcons.mgc_time_fill,
                              ),
                              color: const Color(0xFFB9B9B9),
                            ),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(
                          width: 6.0,
                        ),
                        Expanded(
                          child: customFormPeminjaman(
                            controller: _peminjamanC.akhirC,
                            judul: "Akhir Peminjaman",
                            returnText: "Silahkan mengisi batas peminjaman",
                            hintText: DateFormat('hh:mm a').format(
                              DateTime.now(),
                            ),
                            icon: IconButton(
                              onPressed: () {
                                _showDayNightTimePicker(_peminjamanC.akhirC);
                              },
                              icon: const Icon(
                                MingCuteIcons.mgc_time_fill,
                              ),
                              color: const Color(0xFFB9B9B9),
                            ),
                            keyboardType: TextInputType.datetime,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    customFormPeminjaman(
                      controller: _peminjamanC.jumlahC,
                      judul: "Jumlah/Satuan",
                      returnText:
                          "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
                      hintText: "Contoh: 2 Part",
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Detail Keperluan",
                        style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                            color: const Color(0xFF6B7888)),
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    // Jurusan
                    DropdownButtonFormField<String>(
                      value: _selectedJurusan,
                      hint: const Text("Pilih Jurusan"),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedJurusan = newValue;
                          _peminjamanC.jurusanC.text = newValue!;
                          _selectedProgramStudi = null;
                          _selectedKategori = null;
                          _selectedDetail = null;
                        });
                      },
                      items: jurusanOptions.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan pilih jurusan';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color(0xFFD9D9D9),
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      isExpanded: true,
                      menuMaxHeight: 300,
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    // Program Studi
                    if (_selectedJurusan != null &&
                        _selectedJurusan != 'Lainnya')
                      DropdownButtonFormField<String>(
                        value: _selectedProgramStudi,
                        hint: const Text("Pilih Program Studi"),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedProgramStudi = newValue;
                            _peminjamanC.prodiC.text = newValue!;
                            _selectedKategori = null;
                            _selectedDetail = null;
                          });
                        },
                        items: programStudiOptions[_selectedJurusan]!
                            .map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Silahkan pilih program studi";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 34, 23, 23),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    // Kategori
                    if (_selectedProgramStudi != null ||
                        _selectedJurusan == 'Lainnya')
                      DropdownButtonFormField<String>(
                        value: _selectedKategori,
                        hint: const Text("Pilih Kategori Peminjaman"),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedKategori = newValue;
                            _peminjamanC.kategoriC.text = newValue!;
                            _selectedDetail = null;

                            // if (_isManualInputRequired()) {
                            //   _selectedDetail = null;
                            //   _peminjamanC.detailKeperluanC.text =
                            //       ''; // Kosongkan untuk input manual
                            // } else {
                            //   _selectedDetail = null;
                            //   _peminjamanC.detailKeperluanC
                            //       .clear(); // Reset jika memilih kategori lain
                            // }
                          });
                        },
                        items: kategoriOptions.map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Silahkan pilih kategori peminjaman";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    // Detail Keperluan
                    if (_selectedKategori != null &&
                        _selectedKategori != 'Tugas Akhir' &&
                        _selectedKategori != 'Proyek Akhir' &&
                        _selectedProgramStudi != null &&
                        _selectedJurusan != 'FE' &&
                        _selectedJurusan != 'Lainnya')
                      DropdownButtonFormField<String>(
                        value: _selectedDetail,
                        hint: const Text("Pilih Detail Keperluan"),
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDetail = newValue;
                            _peminjamanC.detailKeperluanC.text = newValue!;
                          });
                        },
                        items: detailOptions[_selectedProgramStudi]![
                                _selectedKategori]!
                            .map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Silahkan pilih detail keperluan';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFFD9D9D9),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        isExpanded: true,
                        menuMaxHeight: 300,
                      ),
                    if (_selectedKategori != null && _isManualInputRequired())
                      customFormPeminjaman(
                        controller: _peminjamanC.detailKeperluanC,
                        judul: "Detail Keperluan",
                        returnText: "Silahkan isi detail keperluan",
                        hintText: "Masukkan detail keperluan",
                      ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    customFormPeminjaman(
                      controller: _fileText,
                      judul: "Desain Benda",
                      returnText: "Silahkan mengisi masukan desain benda",
                      hintText: "Tambahkan file",
                      icon: IconButton(
                        onPressed: () {
                          _pickFile();
                        },
                        icon: const Icon(
                          MingCuteIcons.mgc_upload_2_line,
                        ),
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          backgroundColor: const Color(0xFFEFF1F4),
                        ),
                        // onPressed: _validateForm,
                        onPressed: _validateForm,
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
            ],
          ),
        ),
      ),
    );
  }
}

// Pop Up Dialog
class CustomDialogWidget extends StatefulWidget {
  final VoidCallback onConfirmed;

  const CustomDialogWidget({
    super.key,
    required this.onConfirmed,
  });

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
          CardDialog(
            onConfirmed: () {
              widget.onConfirmed();
              Get.to(afterSubmit());
            },
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            height: 28.0,
            width: 28.0,
            child: OutlinedButton(
              onPressed: () {
                Get.back();
                // Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(8.0),
                shape: const CircleBorder(),
                backgroundColor: const Color(0xFFEC5B5B),
              ),
              child: Image.asset("assets/images/close.png"),
            ),
          ),
        ],
      ),
    );
  }
}

class CardDialog extends StatelessWidget {
  final VoidCallback onConfirmed;

  const CardDialog({
    super.key,
    required this.onConfirmed,
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
                onPressed: () {
                  Get.back();
                },
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
                onPressed: () {
                  onConfirmed();
                },
                child: const Text("Ya"),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Fungsi untuk menampilkan animasi setelah di submit
class afterSubmit extends StatefulWidget {
  const afterSubmit({super.key});

  @override
  State<afterSubmit> createState() => _afterSubmitState();
}

class _afterSubmitState extends State<afterSubmit>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    Future.delayed(const Duration(seconds: 7), () {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: BottomNavBar(),
        withNavBar: true, // Ini akan memastikan bottom nav bar ditampilkan
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );

      //Get.off(mainPageUser());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.network(
          'https://lottie.host/ec484086-d82c-4cf6-b84e-eae4f18c9195/zK1DbzlbOK.json',
          repeat: true,
          frameRate: FrameRate.max,
          onLoaded: (composition) {},
        ),
      ),
    );
  }
}
