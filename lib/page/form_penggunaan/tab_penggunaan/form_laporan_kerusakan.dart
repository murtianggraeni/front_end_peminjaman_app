import 'package:build_app/page/form_penggunaan/utility/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class formLaporanKerusakan extends StatefulWidget {
  const formLaporanKerusakan({super.key});

  @override
  State<formLaporanKerusakan> createState() => _formLaporanKerusakanState();
}

class _formLaporanKerusakanState extends State<formLaporanKerusakan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customFormPeminjaman(
            returnText: "Silahkan mengisi ID Order",
            judul: "ID Order",
            hintText: DateFormat('d/MM/yy').format(DateTime.now()),
          ),
          Row(
            children: [
              Expanded(
                child: customFormPeminjaman(
                  returnText: "Silahkan mengisi tanggal kerusakan",
                  judul: "Waktu Kerusakan",
                  hintText: DateFormat('d/MM/yy').format(DateTime.now()),
                  icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(MingCute.calendar_month_fill),
                      color: const Color(0xFFB9B9B9)),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(
                width: 6.0,
              ),
              Expanded(
                child: customFormPeminjaman(
                  returnText: "Silahkan mengisi jam kerusakan",
                  judul: "",
                  hintText: DateFormat('hh:mm a').format(DateTime.now()),
                  icon: IconButton(
                    onPressed: () {},
                    icon: const Icon(MingCute.time_fill),
                    color: const Color(0xFFB9B9B9),
                  ),
                  keyboardType: TextInputType.datetime,
                ),
              ),
            ],
          ),
          const customFormPeminjaman(
            returnText: "Silahkan mengisi deskripsi kerusakan mesin",
            judul: "Deskripsi Kerusakan Mesin",
            hintText: "Contoh: 2 Part",
          ),
          customFormPeminjaman(
            returnText: "Silahkan mengisi bukti kerusakan",
            judul: "Bukti Kerusakan",
            hintText: "Tambahkan file",
            icon: IconButton(
              onPressed: () {},
              icon: const Icon(MingCute.upload_2_line),
              color: const Color(0xFFB9B9B9),
            ),
            keyboardType: TextInputType.datetime,
          ),
        ],
      ),
    )));
  }
}
