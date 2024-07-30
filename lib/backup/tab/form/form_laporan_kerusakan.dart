import 'dart:io';

import 'package:build_app/page/home/form_peminjaman/form_penggunaan/utility/custom_form_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class formLaporanKerusakanBackup extends StatefulWidget {
  const formLaporanKerusakanBackup({super.key});

  @override
  State<formLaporanKerusakanBackup> createState() =>
      _formLaporanKerusakanBackupState();
}

class _formLaporanKerusakanBackupState
    extends State<formLaporanKerusakanBackup> {
  // Untuk memilih tanggal kerusakan
  void _showDatePicker() async {
    final _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_selectedDate != null) {
      setState(
        () {
          _date.text = DateFormat('EE, d MMM yyyy').format(_selectedDate);
        },
      );
    }
  }

  // Untuk memilih waktu ditemukan kerusakan
  void _showTimePicker() async {
    final _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_selectedTime != null) {
      setState(
        () {
          _time.text = _selectedTime.format(context);
        },
      );
    }
  }

  // Untuk memilih desain benda
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

  void openFile(File file) {
    OpenFile.open(file.path);
  }

  // Sebagai controller dari masing-masing fungsi
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _fileText = TextEditingController();

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
                      controller: _date,
                      judul: "Waktu Kerusakan",
                      returnText: "Silahkan mengisi tanggal kerusakan",
                      hintText: DateFormat('d/MM/yy').format(DateTime.now()),
                      icon: IconButton(
                          onPressed: () {
                            _showDatePicker();
                          },
                          icon: const Icon(MingCute.calendar_month_fill),
                          color: const Color(0xFFB9B9B9)),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Expanded(
                    child: customFormPeminjaman(
                      controller: _time,
                      judul: "",
                      returnText: "Silahkan mengisi jam kerusakan",
                      hintText: DateFormat('hh:mm a').format(DateTime.now()),
                      icon: IconButton(
                        onPressed: () {
                          _showTimePicker();
                        },
                        icon: const Icon(MingCute.time_fill),
                        color: const Color(0xFFB9B9B9),
                      ),
                      keyboardType: TextInputType.datetime,
                      readOnly: true,
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
                controller: _fileText,
                judul: "Bukti Kerusakan",
                returnText: "Silahkan mengisi bukti kerusakan",
                hintText: "Tambahkan file",
                icon: IconButton(
                  onPressed: () {
                    _pickFile();
                  },
                  icon: const Icon(MingCute.upload_2_line),
                  color: const Color(0xFFB9B9B9),
                ),
                keyboardType: TextInputType.datetime,
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
