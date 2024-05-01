import 'package:build_app/page/form_penggunaan/utility/custom_form_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class formPeminjaman extends StatefulWidget {
  const formPeminjaman({super.key});

  @override
  State<formPeminjaman> createState() => _formPeminjamanState();
}

class _formPeminjamanState extends State<formPeminjaman> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            child: Padding(
      padding: EdgeInsets.symmetric(vertical: 11.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customFormPeminjaman(
            returnText: "Silahkan mengisi batas peminjaman",
            judul: "Tanggal Peminjaman",
            hintText: DateFormat('d/MM/yy').format(DateTime.now()),
            icon: IconButton(
                onPressed: () {},
                icon: const Icon(MingCute.calendar_month_fill),
                color: const Color(0xFFB9B9B9)),
            keyboardType: TextInputType.datetime,
          ),
          Row(
            children: [
              Expanded(
                child: customFormPeminjaman(
                  returnText: "Silahkan mengisi batas peminjaman",
                  judul: "Awal Peminjaman",
                  hintText: DateFormat('hh:mm a').format(DateTime.now()),
                  icon: IconButton(
                      onPressed: () {},
                      icon: const Icon(MingCute.time_fill),
                      color: const Color(0xFFB9B9B9)),
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(
                width: 6.0,
              ),
              Expanded(
                child: customFormPeminjaman(
                  returnText: "Silahkan mengisi batas peminjaman",
                  judul: "Akhir Peminjaman",
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
            returnText: "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
            judul: "Jumlah/Satuan",
            hintText: "Contoh: 2 Part",
          ),
          const customFormPeminjaman(
            returnText: "Silahkan mengisi alasan keperluan dengan rinci",
            judul: "Detail Keperluan",
            hintText: "Contoh: untuk memenuhi tugas mata kuliah",
          ),
          customFormPeminjaman(
            returnText: "Silahkan mengisi masukan desain benda",
            judul: "Desain Benda",
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
