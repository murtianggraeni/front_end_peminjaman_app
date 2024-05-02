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
  // void _showDatePicker() {
  //   context: context;
  //   initialDate:
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 11.0),
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
                  judul: "Waktu Kerusakan",
                  returnText: "Silahkan mengisi tanggal kerusakan",
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
                  judul: "",
                  returnText: "Silahkan mengisi jam kerusakan",
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
            judul: "Deskripsi Kerusakan Mesin",
            returnText: "Silahkan mengisi deskripsi kerusakan mesin",
            hintText: "Contoh: 2 Part",
          ),
          customFormPeminjaman(
            judul: "Bukti Kerusakan",
            returnText: "Silahkan mengisi bukti kerusakan",
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
