import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class detailPageCnc extends StatefulWidget {
  const detailPageCnc({super.key});

  @override
  State<detailPageCnc> createState() => _detailPageCncState();
}

class _detailPageCncState extends State<detailPageCnc> {
  // Data dummy peminjaman
  List<Peminjaman> peminjamanList = [
    Peminjaman(
      id: 1001,
      namaPemohon: "Selena Natasha",
      tanggalPermintaan: DateTime.parse("2024-07-19"),
      status: "Sedang diverifikasi",
      email: "selena@gmail.com",
      waktuAwal: "08.00",
      waktuAkhir: "12.00",
      jumlahSatuan: "2 Part",
      keperluan: "Untuk bagian dari tugas akhir",
      desainBenda: "desainMotor.pdf",
    ),
    Peminjaman(
      id: 1002,
      namaPemohon: "Ahmad Zidan",
      tanggalPermintaan: DateTime.parse("2024-07-31"),
      status: "Sudah diverifikasi: Diterima",
      email: "ahmad@yahoo.com",
      waktuAwal: "10.00",
      waktuAkhir: "12.00",
      jumlahSatuan: "10 Part",
      keperluan: "Untuk keperluan pembuatan spare part food feeder",
      desainBenda: "desainFoodFeeder.pdf",
    ),
    Peminjaman(
      id: 1003,
      namaPemohon: "Rafza Ray Firdaus",
      tanggalPermintaan: DateTime.parse("2024-08-17"),
      status: "Sudah diverifikasi: Ditolak",
      email: "rafza@bing.com",
      waktuAwal: "13.00",
      waktuAkhir: "14.30",
      jumlahSatuan: "6 Part",
      keperluan: "Untuk keperluan mata kuliah KSJ",
      desainBenda: "desainKSJ.pdf",
    ),
    Peminjaman(
      id: 1004,
      namaPemohon: "Naufal Hilmi",
      tanggalPermintaan: DateTime.parse("2024-09-12"),
      status: "Sedang diverifikasi",
      email: "naufal@yahoo.com",
      waktuAwal: "12.00",
      waktuAkhir: "11.30",
      jumlahSatuan: "4 Part",
      keperluan: "Untuk keperluan mata kuliah ENA",
      desainBenda: "desainENA.pdf",
    ),
  ];

  // List dari item yang difilter dalam filter peminjaman
  List filterItem = [
    'All',
    'Sedang diverifikasi',
    'Diterima',
    'Ditolak',
  ];

  List<Peminjaman> filteredList = [];
  String filter = '';
  String statusFilter = 'All';
  bool sortAscending = true;
  List<int> selectedCheckboxes = [];
  Peminjaman? recentlyDeleted;

  @override
  void initState() {
    super.initState();
    filteredList = peminjamanList;
  }

  // Fungsi untuk memfilter tabel peminjaman berdasarkan status
  void filterPeminjaman() {
    setState(() {
      filteredList = peminjamanList.where((peminjaman) {
        bool matchesFilter =
            peminjaman.namaPemohon.toLowerCase().contains(filter.toLowerCase());
        bool matchesStatus = statusFilter == 'All' ||
            (statusFilter == 'Sedang diverifikasi' &&
                peminjaman.status == 'Sedang diverifikasi') ||
            (statusFilter == 'Diterima' &&
                peminjaman.status.contains('Diterima')) ||
            (statusFilter == 'Ditolak' &&
                peminjaman.status.contains('Ditolak'));
        return matchesFilter && matchesStatus;
      }).toList();
    });
  }

  // Fungsi untuk menyortir tabel berdasarkan tanggal peminjaman
  void sortPeminjaman() {
    setState(() {
      filteredList.sort((a, b) => sortAscending
          ? a.tanggalPermintaan.compareTo(b.tanggalPermintaan)
          : b.tanggalPermintaan.compareTo(a.tanggalPermintaan));
      sortAscending = !sortAscending;
    });
  }

  // Fungsi untuk sorting tabel berdasarkan status
  void sortStatus() {
    setState(() {
      filteredList.sort(
        (a, b) => sortAscending
            ? a.status.compareTo(b.status)
            : b.status.compareTo(a.status),
      );
      sortAscending = !sortAscending;
    });
  }

  // Fungsi untuk menerima permohonan permintaan
  Future<void> approvePeminjaman(Peminjaman peminjaman) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.infoReverse,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2.0),
      ),
      animType: AnimType.topSlide,
      title: 'Konfirmasi',
      desc: 'Apakah Anda yakin ingin menyetujui permohonan peminjaman ini?',
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          peminjaman.status = 'Sudah diverifikasi: Diterima';
          selectedCheckboxes.remove(peminjaman.id);
        });
      },
    ).show();
  }

  // Fungsi untuk menolak permohonan peminjaman
  Future<void> rejectPeminjaman(Peminjaman peminjaman) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2.0),
      ),
      title: 'Konfirmasi',
      desc: 'Apakah Anda yakin ingin menolak permohonan peminjaman ini?',
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          //peminjaman.isApproved = false;
          peminjaman.status = "Sudah diverifikasi: Ditolak";
        });
      },
    ).show();
  }

  // Fungsi pop up konfirmasi penghapusan tabel
  Future<void> deletePeminjaman(int id) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2.0),
      ),
      animType: AnimType.bottomSlide,
      title: 'Konfirmasi Hapus',
      desc: 'Apakah Anda yakin ingin menghapus permohonan peminjaman ini?',
      showCloseIcon: true,
      dismissOnTouchOutside: false,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        setState(() {
          recentlyDeleted =
              peminjamanList.firstWhere((peminjaman) => peminjaman.id == id);
          peminjamanList.removeWhere((peminjaman) => peminjaman.id == id);
          filterPeminjaman();
        });
      },
    ).show();
  }

  // Fungsi untuk membedakan status berdasarkan warna
  Color getStatusColor(String status) {
    if (status.contains("Diterima")) {
      return Colors.green.withOpacity(0.2);
    } else if (status.contains("Ditolak")) {
      return Colors.red.withOpacity(0.2);
    } else {
      return Colors.orange.withOpacity(0.2);
    }
  }

  // Fungsi untuk memberi info detail mengenai peminjaman
  void showDetails(Peminjaman peminjaman) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Detail Peminjaman - ${peminjaman.namaPemohon}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${peminjaman.email}"),
              Text(
                  "Tanggal Peminjaman: ${DateFormat('dd MMM yyyy').format(peminjaman.tanggalPermintaan)}"),
              Text("Waktu awal: ${peminjaman.waktuAwal}"),
              Text("Waktu akhir: ${peminjaman.waktuAkhir}"),
              Text("Jumlah/Satuan: ${peminjaman.jumlahSatuan}"),
              Text("Keperluan: ${peminjaman.keperluan}"),
              Row(
                children: [
                  const Text("Desain Benda: "),
                  GestureDetector(
                    onTap: () {
                      // implementasikan PDF di sini
                    },
                    child: Text(
                      peminjaman.desainBenda,
                      style: GoogleFonts.inter(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk checkbox pada tabel
  void onSelectedRow(bool selected, Peminjaman peminjaman) {
    setState(() {
      if (selected) {
        selectedCheckboxes.add(peminjaman.id);
      } else {
        selectedCheckboxes.remove(peminjaman.id);
      }
    });
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              // vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Data Permintaan Peminjaman",
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6B7888),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    // --- Tombol hapus ---
                    IconButton(
                      onPressed: selectedCheckboxes.isNotEmpty
                          ? () {
                              deletePeminjaman(selectedCheckboxes.first);
                            }
                          : null,
                      icon: const Icon(MingCute.delete_2_line),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size.fromHeight(32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0), //Color(0xFFF2F2F2),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    // --- Dropdown filter ---
                    Container(
                      width: 120.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: const Color(0xFFE0E0E0), //Color(0xFFF2F2F2),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 4.0,
                        right: 4.0,
                      ),
                      child: DropdownButton<String>(
                        hint: const Text("Filter"),
                        value: statusFilter,
                        isExpanded: true,
                        icon: const Icon(BoxIcons.bx_slider_alt),
                        items: filterItem
                            .map(
                              (status) => DropdownMenuItem<String>(
                                value: status,
                                child: Flexible(
                                  child: Text(
                                    status,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(
                            () {
                              statusFilter = value!;
                              filterPeminjaman();
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    // --- Searchbar ---
                    Expanded(
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: "Search",
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            prefixIcon: Icon(
                              MingCute.search_3_line,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              filter = value;
                              filterPeminjaman();
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                // --- Tabel ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    sortAscending: sortAscending,
                    columns: [
                      // -- KOLOM ID --
                      const DataColumn(
                        label: Text("ID"),
                      ),
                      // -- KOLOM NAMA PEMOHON --
                      DataColumn(
                        label: const Text("Nama Pemohon"),
                        onSort: (columnIndex, ascending) {
                          sortPeminjaman();
                        },
                      ),
                      // -- KOLOM STATUS VERIFIKASI --
                      DataColumn(
                        label: const Text("Status Verifikasi"),
                        onSort: (columnIndex, ascending) {
                          sortStatus();
                        },
                      ),
                      // -- KOLOM AKSI --
                      const DataColumn(label: Text("Aksi")),
                    ],
                    rows: filteredList.map(
                      (peminjaman) {
                        return DataRow(
                          selected: selectedCheckboxes.contains(peminjaman.id),
                          onSelectChanged: (selected) {
                            onSelectedRow(selected!, peminjaman);
                          },
                          cells: [
                            // -- BARIS ID --
                            DataCell(
                              Text(
                                peminjaman.id.toString(),
                              ),
                            ),
                            // -- BARIS NAMA PEMOHON --
                            DataCell(
                              Text(
                                peminjaman.namaPemohon,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            // -- BARIS STATUS VERIFIKASI --
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 4.0,
                                ),
                                decoration: BoxDecoration(
                                  color: getStatusColor(peminjaman.status),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Text(
                                  peminjaman.status,
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            // -- BARIS AKSI --
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: peminjaman.status ==
                                            "Sedang diverifikasi"
                                        ? () => approvePeminjaman(peminjaman)
                                        : null,
                                    icon: Icon(
                                      BoxIcons.bx_check_circle,
                                      color: peminjaman.status ==
                                              "Sedang diverifikasi"
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: peminjaman.status ==
                                            "Sedang diverifikasi"
                                        ? () => rejectPeminjaman(peminjaman)
                                        : null,
                                    icon: Icon(
                                      BoxIcons.bx_x_circle,
                                      color: peminjaman.status ==
                                              "Sedang diverifikasi"
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => showDetails(peminjaman),
                                    icon: const Icon(MingCute.information_line),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
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

class Peminjaman {
  final int id;
  final String namaPemohon;
  final DateTime tanggalPermintaan;
  String status;
  final String email;
  final String waktuAwal;
  final String waktuAkhir;
  final String jumlahSatuan;
  final String keperluan;
  final String desainBenda;
  bool isApproved;

  Peminjaman({
    required this.id,
    required this.namaPemohon,
    required this.tanggalPermintaan,
    required this.status,
    required this.email,
    required this.waktuAwal,
    required this.waktuAkhir,
    required this.jumlahSatuan,
    required this.keperluan,
    required this.desainBenda,
    this.isApproved = false,
  });
}
