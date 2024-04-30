import 'package:build_app/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class dashboardInformasiPeminjaman extends StatefulWidget {
  const dashboardInformasiPeminjaman({
    super.key,
    required this.namaMesin,
    required this.dataAcc,
    required this.dataTidakAcc,
    required this.dataDiproses,
    required this.alamatInformasiLanjutan,
  });

  final String namaMesin;
  final String dataAcc;
  final String dataTidakAcc;
  final String dataDiproses;
  final Widget alamatInformasiLanjutan;

  @override
  State<dashboardInformasiPeminjaman> createState() =>
      _dashboardInformasiPeminjamanState();
}

class _dashboardInformasiPeminjamanState
    extends State<dashboardInformasiPeminjaman> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.0,
      width: 350.0,
      decoration: BoxDecoration(
        color: pageModeScheme.onPrimary,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(DateTime.now()),
                      style: GoogleFonts.inter(
                        fontSize: 8.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      children: [
                        const Icon(MingCute.information_line,
                            color: Color(0xFF09244B), size: 12.0),
                        const SizedBox(
                          width: 2.0,
                        ),
                        Text(
                          "Informasi Data Peminjaman",
                          style: GoogleFonts.inter(
                            fontSize: 8.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF294D5C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Text(
                      widget.namaMesin,
                      style: GoogleFonts.inter(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF738E99),
                      ),
                    ),
                    const SizedBox(
                      height: 3.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 24.0,
                              width: 75.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                color: Color(0xFFC8D4DA),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      MingCute.checks_line,
                                      color: Color(0xFF09244B),
                                      size: 16.0,
                                    ),
                                    const SizedBox(width: 1.0),
                                    Text(
                                      widget.dataAcc,
                                      style: GoogleFonts.inter(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF142932)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Container(
                              height: 24.0,
                              width: 75.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                color: Color(0xFFC8D4DA),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7.0, vertical: 5.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      MingCute.close_line,
                                      color: Color(0xFF09244B),
                                      size: 16.0,
                                    ),
                                    const SizedBox(width: 1.0),
                                    Text(
                                      widget.dataTidakAcc,
                                      style: GoogleFonts.inter(
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF142932)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3.0),
                        Container(
                          height: 24.0,
                          width: 75.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            color: Color(0xFFC8D4DA),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 6.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  MingCute.loading_3_line,
                                  color: Color(0xFF09244B),
                                  size: 16.0,
                                ),
                                const SizedBox(width: 1.0),
                                Text(
                                  widget.dataDiproses,
                                  style: GoogleFonts.inter(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF142932)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    widget.alamatInformasiLanjutan,
                              ));
                        },
                        style: OutlinedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            minimumSize: const Size(87.0, 17.0),
                            padding: const EdgeInsets.all(
                              10.0,
                            ),
                            backgroundColor: pageModeScheme.secondary,
                            side:
                                BorderSide(color: pageModeScheme.onSecondary)),
                        child: IntrinsicWidth(
                          child: Row(
                            children: [
                              Text('Informasi lebih lanjut',
                                  style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 8.0,
                                  )),
                              const SizedBox(
                                width: 3.0,
                              ),
                              const Icon(
                                Icons.chevron_right,
                                size: 11.0,
                                color: Colors.black,
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                const Flexible(
                    child: Image(
                        image: AssetImage(
                            "assets/images/cartoon_informasi_dua.png")))
              ],
            ),
          )),
    );
  }
}
