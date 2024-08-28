// status_page.dart

import 'package:build_app/controller/sensor_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:build_app/controller/peminjamanUserAll_controller.dart';
import 'package:build_app/models/peminjamanUserAll_model.dart';
import 'package:build_app/page/main/custom_main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Fungsi helper untuk warna status
Color dapatkanWarnaStatus(String status) {
  switch (status) {
    case 'Disetujui':
      return Colors.green.shade100;
    case 'Diproses':
      return Colors.orange.shade100;
    case 'Ditolak':
      return Colors.red.shade100;
    default:
      return Colors.grey.shade300;
  }
}

// Fungsi helper untuk warna teks status
Color dapatkanWarnaTeksStatus(String status) {
  switch (status) {
    case 'Disetujui':
      return Colors.green[800]!;
    case 'Diproses':
      return Colors.orange[800]!;
    case 'Ditolak':
      return Colors.red[800]!;
    default:
      return Colors.grey[800]!;
  }
}

// Fungsi untuk mendapatkan gambar mesin
String getImageForMachine(String namaMesin) {
  switch (namaMesin) {
    case 'CNC Milling':
      return "assets/images/foto_cnc.png";
    case '3D Printing':
      return 'assets/images/foto_3dp.png';
    case 'Laser Cutting':
      return 'assets/images/foto_lasercut.png';
    default:
      return "assets/images/default_machine.png";
  }
}

// Fungsi agar bagian search bar dan filter bar tidak ikut scroll
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class statusPage extends StatefulWidget {
  const statusPage({Key? key}) : super(key: key);

  @override
  State<statusPage> createState() => _statusPageState();
}

class _statusPageState extends State<statusPage> {
  final PeminjamanUserAllController controller =
      Get.put(PeminjamanUserAllController());
  final SensorController sensorController = Get.put(SensorController());

  // Tambahkan ini untuk melacak tombol yang sudah ditekan
  Set<String> activatedButtons = {};

  @override
  void initState() {
    super.initState();
    _loadActivatedButtons();
  }

  Future<void> _loadActivatedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      activatedButtons = prefs.getStringList('activatedButtons')?.toSet() ?? {};
    });
  }

  Future<void> _saveActivatedButtons() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('activatedButtons', activatedButtons.toList());
  }

  // Fungsi untuk membedakan button Peminjaman
  Color _getButtonColor(Datum peminjaman) {
    if (peminjaman.status == Status.Diproses) return Colors.grey;
    if (peminjaman.status != Status.Disetujui) return Colors.grey;

    DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
    DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
    if (awalPeminjamanDate == null || akhirPeminjamanDate == null)
      return Colors.grey;

    final now = DateTime.now();
    if (now.isBefore(awalPeminjamanDate)) return Colors.grey;
    if (now.isAfter(akhirPeminjamanDate)) return Colors.grey;

    if (activatedButtons.contains(peminjaman.id)) return Colors.blue;
    return const Color(0xFF00A95B); // Hijau
  }

  // Fungsi untuk mengetahui teks dalam button Peminjaman
  String _getButtonText(Datum peminjaman) {
    if (peminjaman.status == Status.Diproses) return "Belum Tersedia";
    if (peminjaman.status != Status.Disetujui) return "Tidak Tersedia";

    DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
    DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;
    if (awalPeminjamanDate == null || akhirPeminjamanDate == null)
      return "Tidak Tersedia";

    final now = DateTime.now();
    if (now.isBefore(awalPeminjamanDate)) return "Mulai Peminjaman";
    if (now.isAfter(akhirPeminjamanDate)) return "Tidak Tersedia";

    if (activatedButtons.contains(peminjaman.id)) return "Peminjaman Aktif";
    return "Mulai Peminjaman";
  }

  // Fungsi untuk button peminjaman
  bool _canActivateButton(Datum peminjaman) {
    print(
        "Checking if button can be activated for Peminjaman ID: ${peminjaman.id}");
    print("Status: ${peminjaman.status}");
    print("Tanggal Peminjaman: ${peminjaman.tanggalPeminjaman}");
    print("Awal Peminjaman (raw): ${peminjaman.awalPeminjaman}");
    print("Akhir Peminjaman (raw): ${peminjaman.akhirPeminjaman}");

    if (peminjaman.status != Status.Disetujui) {
      print("Status bukan Disetujui, button tidak dapat diaktifkan.");
      return false;
    }

    if (activatedButtons.contains(peminjaman.id)) {
      print("Button sudah ditekan sebelumnya, tidak dapat diaktifkan lagi.");
      return false;
    }

    DateTime? awalPeminjamanDate = peminjaman.awalPeminjamanTime;
    DateTime? akhirPeminjamanDate = peminjaman.akhirPeminjamanTime;

    print("Awal Peminjaman (parsed): $awalPeminjamanDate");
    print("Akhir Peminjaman (parsed): $akhirPeminjamanDate");

    if (awalPeminjamanDate == null || akhirPeminjamanDate == null) {
      print(
          "Awal atau Akhir Peminjaman DateTime is null, button cannot be activated.");
      return false;
    }

    final now = DateTime.now();
    bool canActivate =
        now.isAfter(awalPeminjamanDate) && now.isBefore(akhirPeminjamanDate);
    print("Current time: $now");
    print("Can Activate: $canActivate");
    return canActivate;
  }

  // Fungsi filter dialog
  void _showFilterDialog() {
    final filterOpts = filterOptions();
    String localSelectedStatus = controller.selectedStatus.value;
    String localSelectedMachineType = controller.selectedMachineType.value;

    Get.dialog(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text(
              "Filter Peminjaman",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: localSelectedStatus,
                    isExpanded: true,
                    items: filterOpts.statusOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          localSelectedStatus = newValue;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Jenis Mesin',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<String>(
                    value: localSelectedMachineType,
                    isExpanded: true,
                    items: filterOpts.machineTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          localSelectedMachineType = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Batal",
                  style: GoogleFonts.inter(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.setFilters(
                    status: localSelectedStatus,
                    machineType: localSelectedMachineType,
                  );
                  Get.back();
                },
                child: Text(
                  "Terapkan",
                  style: GoogleFonts.inter(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 225, 247),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, String selectedValue,
      List<String> options, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
          ),
        ),
        DropdownButton<String>(
          value: selectedValue,
          isExpanded: true,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return customScaffoldPage(
      body: Column(
        children: [
          const SizedBox(height: 36.0), // Spasi atas
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22.0),
                  topRight: Radius.circular(22.0),
                ),
                child: CustomScrollView(
                  slivers: [
                    // Header
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 120.0,
                        maxHeight: 120.0,
                        child: Container(
                          color: Colors.white,
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
                          child: Column(
                            children: [
                              Text(
                                'Status Peminjaman',
                                style: GoogleFonts.inter(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: searchbar(
                                      onSearch: (value) {
                                        controller.setSearchQuery(value);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    flex: 3,
                                    child:
                                        filterbar(onPressed: _showFilterDialog),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Daftar Peminjaman
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                      sliver:
                          //Obx
                          GetBuilder<PeminjamanUserAllController>(
                              builder: (controller) {
                        // if (controller.peminjaman.isEmpty)
                        final filteredPeminjaman =
                            controller.filteredPeminjaman;
                        //if (controller.filteredPeminjaman.isEmpty)
                        if (filteredPeminjaman.isEmpty) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Text(
                                'Tidak ada data peminjaman',
                                style: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // final peminjaman = controller.peminjaman[index];
                              //final peminjaman = controller.filteredPeminjaman[index];
                              final peminjaman = filteredPeminjaman[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFE3E3E3),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Baris atas: Keperluan Peminjaman dan Status
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                    MingCuteIcons
                                                        .mgc_schedule_line,
                                                    size: 30.0),
                                                const SizedBox(width: 9.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Keperluan Peminjaman",
                                                      style: GoogleFonts.inter(
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Diajukan: ${peminjaman.formattedWaktu}",
                                                      //"Diajukan: ${DateFormat('dd MMM yyyy').format(peminjaman.waktu)}",
                                                      style: GoogleFonts.inter(
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0XFF6B6B6B),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 58.0,
                                              height: 19.0,
                                              // padding: const EdgeInsets.symmetric(
                                              //     horizontal: 3, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: dapatkanWarnaStatus(
                                                    peminjaman.status.name),
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  peminjaman.status.name,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        dapatkanWarnaTeksStatus(
                                                            peminjaman
                                                                .status.name),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          color: Color(0xFFE3E3E3),
                                        ),
                                        // Informasi Mesin
                                        Row(
                                          children: [
                                            Container(
                                              width: 35.0,
                                              height: 35.0,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFCED9DF),
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Image.asset(
                                                  getImageForMachine(
                                                      peminjaman.namaMesin),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 12.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Peminjaman Mesin",
                                                  style: GoogleFonts.inter(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  peminjaman.namaMesin,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 13.0,
                                                    color:
                                                        const Color(0xFF5C5C5C),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8.0),
                                        // Baris bawah: Total Jam dan Tombol
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Total Jam Peminjaman",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10.0,
                                                    color:
                                                        const Color(0xFF5C5C5C),
                                                  ),
                                                ),
                                                Text(
                                                  "10 jam",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        const Color(0xFF1E1E1E),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ElevatedButton(
                                              onPressed: _canActivateButton(
                                                      peminjaman)
                                                  ? () async {
                                                      if (!activatedButtons
                                                          .contains(
                                                              peminjaman.id)) {
                                                        setState(() {
                                                          activatedButtons.add(
                                                              peminjaman.id);
                                                        });
                                                        await _saveActivatedButtons(); // Simpan status tombol

                                                        sensorController
                                                            .turnOnWithTimeout(
                                                          peminjaman.alamatEsp,
                                                          peminjaman
                                                              .akhirPeminjamanTime!,
                                                          peminjaman.id,
                                                          () {
                                                            setState(() {
                                                              activatedButtons
                                                                  .remove(
                                                                      peminjaman
                                                                          .id);
                                                            });
                                                            _saveActivatedButtons();
                                                          },
                                                        );

                                                        Get.snackbar(
                                                          "Peminjaman Dimulai",
                                                          "Mesin ${peminjaman.namaMesin} telah diaktifkan.",
                                                          snackPosition:
                                                              SnackPosition.TOP,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        );
                                                      } else {
                                                        Get.snackbar(
                                                          "Peminjaman Sudah Aktif",
                                                          "Mesin ${peminjaman.namaMesin} sudah diaktifkan sebelumnya.",
                                                          snackPosition:
                                                              SnackPosition.TOP,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              style: ElevatedButton.styleFrom(
                                                minimumSize:
                                                    const Size(90.0, 17.0),
                                                backgroundColor:
                                                    _getButtonColor(peminjaman),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 7.0,
                                                        vertical: 5.0),
                                              ),
                                              child: Text(
                                                _getButtonText(peminjaman),
                                                style: GoogleFonts.inter(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: filteredPeminjaman.length,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class searchbar extends StatelessWidget {
  final Function(String) onSearch;

  const searchbar({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: const Color(0xFFDDDEE3)),
      ),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Cari Keperluan",
          hintStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            color: const Color(0xFF999999),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          prefixIcon: const Icon(
            MingCuteIcons.mgc_search_2_line,
            color: Color(0xFF09244B),
          ),
        ),
        onChanged: onSearch,
      ),
    );
  }
}

class filterbar extends StatelessWidget {
  final Function() onPressed;

  const filterbar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: const Color(0xFFDDDEE3)),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                MingCuteIcons.mgc_filter_line,
                color: Color(0xFF09244B),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                "Filter",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF09244B),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class filterOptions {
  final List<String> statusOptions = [
    'Semua',
    'Diproses',
    'Disetujui',
    'Ditolak',
    'Selesai'
  ];
  final List<String> machineTypes = [
    'Semua',
    'CNC Milling',
    '3D Printing',
    'Laser Cutting'
  ];
  final List<String> timeRanges = [
    'Semua',
    'Minggu Ini',
    'Bulan Ini',
    '3 Bulan Terakhir'
  ];
  final List<String> durationRanges = [
    'Semua',
    '< 5 jam',
    '5 - 10 jam',
    '> 10 jam'
  ];
}
