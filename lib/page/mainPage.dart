import 'package:build_app/utility/dashboard_choose.dart';
import 'package:build_app/utility/dashboard_peminjaman.dart';
import 'package:build_app/widget/custom_scaffold_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

const activeDbColor = Color(0xFFD8E5EB);
const inactiveDbColor = Color(0xFFE6EDF0);

class mainPageSatu extends StatefulWidget {
  const mainPageSatu({super.key});

  @override
  State<mainPageSatu> createState() => _mainPageSatuState();
}

class _mainPageSatuState extends State<mainPageSatu> {
  Color cncCardColor = inactiveDbColor;
  Color lasercutCardColor = inactiveDbColor;
  Color printingCardColor = inactiveDbColor;

  void updateColor(int mesin) {
    setState(() {
      // Matikan semua kartu terlebih dahulu
      cncCardColor = inactiveDbColor;
      lasercutCardColor = inactiveDbColor;
      printingCardColor = inactiveDbColor;

      // Kemudian aktifkan kartu yang dipilih
      if (mesin == 1) {
        cncCardColor = activeDbColor;
      } else if (mesin == 2) {
        lasercutCardColor = activeDbColor;
      } else if (mesin == 3) {
        printingCardColor = activeDbColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return customScaffoldMain(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Hi, ",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.white),
                      ),
                      Text(
                        "Nama",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Selamat datang kembali!",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color(0xFFE2E2E2),
                    ),
                  )
                ],
              ),
              Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    color: Color(0xFFDFE7EF)),
                child: const Icon(
                  Icons.notifications_active_sharp,
                  size: 24,
                  color: Color(0xFF1D5973),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 71),
        Expanded(
          flex: 6,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      topRight: Radius.circular(22.0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Row(
                      children: [
                        dbPilih(
                          pilihanMesin: "Mesin CNC dipilih",
                          namaMesin: "CNC",
                          ukuranLebar: 48.0,
                          ukuranTinggi: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        dbPilih(
                          pilihanMesin: "Mesin Laser Cut dipilih",
                          namaMesin: "Laser Cutting",
                          ukuranLebar: 95.0,
                          ukuranTinggi: 24.0,
                        ),
                        SizedBox(width: 8.0),
                        dbPilih(
                          pilihanMesin: "Mesin 3D Printing dipilih",
                          namaMesin: "3D Printing",
                          ukuranLebar: 81.0,
                          ukuranTinggi: 24.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Dashboard Peminjaman",
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print(
                                "Tap View All"); // Fungsi yang akan dijalankan saat tombol ditekan
                          },
                          child: Text(
                            'View All',
                            style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF3D8FEF),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 13),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          dbPeminjaman(
                            colorPage: cncCardColor,
                            mesin: 1,
                            objekDipilih: "Memilih CNC Milling",
                            merekMesin: "MTU 200 M",
                            namaMesin: "CNC Milling",
                            namaLab: "Lab. Elektro Mekanik",
                            gambarMesin: "assets/images/foto_cnc.png",
                            leftImage: 23.0,
                            topImage: 4.0,
                            topArrow: 2.0,
                            onCardTap: updateColor,
                          ),
                          const SizedBox(width: 17.0),
                          dbPeminjaman(
                            colorPage: lasercutCardColor,
                            mesin: 2,
                            objekDipilih: "Memilih Laser Cutting",
                            merekMesin: "TQL-1390",
                            namaMesin: "Laser Cutting",
                            namaLab: "Lab. Elektro Mekanik",
                            gambarMesin: "assets/images/foto_lasercut.png",
                            leftImage: 3.0,
                            topImage: 18.0,
                            topArrow: 11.0,
                            onCardTap: updateColor,
                          ),
                          const SizedBox(width: 17.0),
                          dbPeminjaman(
                            colorPage: printingCardColor,
                            mesin: 3,
                            objekDipilih: "Memilih 3D Printing",
                            merekMesin: "Anycubic 4Max Pro",
                            namaMesin: "3D Printing",
                            namaLab: "Lab. PLC & HMI",
                            gambarMesin: "assets/images/foto_3dp.png",
                            leftImage: 6.0,
                            topImage: 9.0,
                            topArrow: 4.5,
                            onCardTap: updateColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Jadwal Peminjaman",
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "View All",
                          style: GoogleFonts.inter(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3D8FEF)),
                        )
                      ],
                    )
                  ],
                ),
              )),
        )
      ],
    ));
  }
}
