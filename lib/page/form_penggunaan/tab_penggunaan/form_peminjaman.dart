import 'dart:io';

import 'package:build_app/page/form_penggunaan/utility/custom_form_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

class formPeminjaman extends StatefulWidget {
  const formPeminjaman({super.key});

  @override
  State<formPeminjaman> createState() => _formPeminjamanState();
}

class _formPeminjamanState extends State<formPeminjaman> {
  // Untuk memilih tanggal peminjaman
  void _showDatePicker() async {
    final _selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_selectedDate != null) {
      setState(() {
        _date.text = DateFormat('EE, d MMM yyyy').format(_selectedDate);
      });
    }
  }

  // Untuk memilih waktu peminjaman
  void _showTimePicker(TextEditingController controller) async {
    final _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_selectedTime != null) {
      setState(() {
        controller.text = _selectedTime.format(context);
      });
    }
  }

  // Untuk memilih desain benda
  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null && result.files.single.path != null) {
  //     // untuk menaruh hasil dan detail file
  //     PlatformFile file = result.files.first;
  //     print(file.name);
  //     print(file.bytes);
  //     print(file.size);
  //     print(file.extension);
  //     print(file.path);

  //     File _file = File(result.files.single.path!);
  //     setState(() {
  //       _fileText.text = _file.path;
  //     });
  //   }
  // }

  // void _pickFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();

  //   if (result != null && result.files.single.path != null) {
  //     PlatformFile file = result.files.first;
  //     print(file.name);
  //     print(file.bytes);
  //     print(file.size);
  //     print(file.extension);
  //     print(file.path);

  //     setState(() {
  //       _fileText.text = file.path!;
  //     });
  //   }
  // }

  List<String> pickedFileNames = [];

  Future<void> _pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        if (kIsWeb) {
          pickedFileNames = result.files.map((file) => file.name).toList();
        } else {
          pickedFileNames =
              result.paths.map((path) => path!.split('/').last).toList();
        }
        // Menggabungkan nama file menjadi satu string
        _fileText.text = pickedFileNames.join(", ");
      });
    }
  }

  void openFile(File file) {
    OpenFile.open(file.path);
  }

  // Sebagai controller dari masing-masing fungsi
  TextEditingController _date = TextEditingController();
  TextEditingController _startTime = TextEditingController();
  TextEditingController _endTime = TextEditingController();
  TextEditingController _fileText = TextEditingController();

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
            controller: _date,
            returnText: "Silahkan mengisi batas peminjaman",
            judul: "Tanggal Peminjaman",
            hintText: DateFormat('EE, dd/MMM/yy').format(DateTime.now()),
            icon: IconButton(
                onPressed: () {
                  _showDatePicker();
                },
                icon: const Icon(MingCute.calendar_month_fill),
                color: const Color(0xFFB9B9B9)),
            keyboardType: TextInputType.datetime,
          ),
          Row(
            children: [
              Expanded(
                child: customFormPeminjaman(
                  controller: _startTime,
                  judul: "Awal Peminjaman",
                  returnText: "Silahkan mengisi batas peminjaman",
                  hintText: DateFormat('hh:mm a').format(DateTime.now()),
                  icon: IconButton(
                      onPressed: () {
                        _showTimePicker(_startTime);
                      },
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
                  controller: _endTime,
                  judul: "Akhir Peminjaman",
                  returnText: "Silahkan mengisi batas peminjaman",
                  hintText: DateFormat('hh:mm a').format(DateTime.now()),
                  icon: IconButton(
                    onPressed: () {
                      _showTimePicker(_endTime);
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
            judul: "Jumlah/Satuan",
            returnText: "Silahkan mengisi jumlah yang akan dilakukan pemesinan",
            hintText: "Contoh: 2 Part",
          ),
          const customFormPeminjaman(
            judul: "Detail Keperluan",
            returnText: "Silahkan mengisi alasan keperluan dengan rinci",
            hintText: "Contoh: untuk memenuhi tugas mata kuliah",
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
              icon: const Icon(MingCute.upload_2_line),
              color: const Color(0xFFB9B9B9),
            ),
            keyboardType: TextInputType.datetime,
            readOnly: true,
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: pickedFileNames.length,
          //     itemBuilder: (context, index) {
          //       return ListTile(
          //         title: Text(pickedFileNames[index]),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    )));
  }
}
