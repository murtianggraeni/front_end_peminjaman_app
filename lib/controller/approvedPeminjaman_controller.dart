// import 'package:get/get.dart';
// import 'dart:convert';
// import 'package:build_app/models/approvedPeminjaman_model.dart';
// import 'package:build_app/provider/api.dart';

// class ApprovedPeminjamanController extends GetxController {
//   final ApiController apiController = ApiController();
//   final Rx<ApprovedPeminjaman?> approvedPeminjaman =
//       Rx<ApprovedPeminjaman?>(null);
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchApprovedPeminjaman();
//   }

//   Future<void> fetchApprovedPeminjaman() async {
//     try {
//       isLoading.value = true;
//       final response = await apiController.getApprovedPeminjaman();
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         approvedPeminjaman.value = ApprovedPeminjaman.fromJson(jsonData);
//       } else {
//         throw Exception('Failed to load approved peminjaman');
//       }
//     } catch (e) {
//       print('Error in fetchApprovedPeminjaman: $e');
//       // You might want to show an error message to the user here
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   List<Datum> getApprovedPeminjamanForDate(DateTime date) {
//     if (approvedPeminjaman.value == null) return [];
//     return approvedPeminjaman.value!.data.where((peminjaman) {
//       final peminjamanDate = DateTime.parse(peminjaman.tanggalPeminjaman);
//       return peminjamanDate.year == date.year &&
//           peminjamanDate.month == date.month &&
//           peminjamanDate.day == date.day;
//     }).toList();
//   }

//   bool hasApprovedPeminjamanForDate(DateTime date) {
//     return getApprovedPeminjamanForDate(date).isNotEmpty;
//   }
// }

import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:build_app/models/approvedPeminjaman_model.dart';
import 'package:build_app/provider/api.dart';

class ApprovedPeminjamanController extends GetxController {
  final ApiController apiController = ApiController();
  final Rx<ApprovedPeminjaman?> approvedPeminjaman = Rx<ApprovedPeminjaman?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('ApprovedPeminjamanController initialized');
    fetchApprovedPeminjaman();
  }

  Future<void> fetchApprovedPeminjaman() async {
    try {
      print('Fetching approved peminjaman...');
      isLoading.value = true;
      final response = await apiController.getApprovedPeminjaman();
      print('API Response status code: ${response.statusCode}');
      print('API Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Decoded JSON data: $jsonData');
        
        approvedPeminjaman.value = ApprovedPeminjaman.fromJson(jsonData);
        print('Parsed Data: ${approvedPeminjaman.value?.data.length} items');
        
        approvedPeminjaman.value?.data.forEach((item) {
          print('Peminjaman item: ${item.toJson()}');
        });
      } else {
        print('Failed to load approved peminjaman. Status code: ${response.statusCode}');
        throw Exception('Failed to load approved peminjaman');
      }
    } catch (e) {
      print('Error in fetchApprovedPeminjaman: $e');
    } finally {
      isLoading.value = false;
      print('Finished fetching approved peminjaman');
    }
  }

  List<Datum> getApprovedPeminjamanForDate(DateTime date) {
    if (approvedPeminjaman.value == null) {
      print('No approved peminjaman data available');
      return [];
    }
    final formatter = DateFormat('yyyy-MM-dd');
    final formattedDate = formatter.format(date);
    print('Checking for approved peminjaman on date: $formattedDate');
    
    final result = approvedPeminjaman.value!.data.where((peminjaman) {
      print('Comparing with peminjaman date: ${peminjaman.tanggalPeminjaman}');
      return peminjaman.tanggalPeminjaman == formattedDate;
    }).toList();
    
    print('Found ${result.length} approved peminjaman for date $formattedDate');
    return result;
  }

  bool hasApprovedPeminjamanForDate(DateTime date) {
    final result = getApprovedPeminjamanForDate(date).isNotEmpty;
    print('Has approved peminjaman for ${DateFormat('yyyy-MM-dd').format(date)}: $result');
    return result;
  }
}