// logger_service.dart
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class LoggerService {
  static late File _logFile;
  static const String _fileName = 'app_logs.txt';

  // Format timestamp
  static final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');

  // Initialize logger
  static Future<void> initialize() async {
    try {
      final Directory? externalDir = await getExternalStorageDirectory();

      if (externalDir == null) {
        print('External storage directory is not available');
        return; // Keluar dari fungsi jika direktori tidak ditemukan
      }

      final String logFilePath = '${externalDir.path}/$_fileName';
      print('Log file path (external): $logFilePath');

      _logFile = File(logFilePath);
      if (!await _logFile.exists()) {
        print('Creating log file in external directory');
        await _logFile.create();
      }

      await _log('APP_START', 'Application started');
    } catch (e) {
      print('Error initializing external logger: $e');
    }
  }

  // Method utama untuk logging
  static Future<void> _log(String type, String message) async {
    final timestamp = _dateFormat.format(DateTime.now());
    final logMessage = '[$timestamp][$type] $message\n';

    // Print ke console
    print(logMessage);

    // Tulis ke file
    await _logFile.writeAsString(
      logMessage,
      mode: FileMode.append,
    );
  }

  // Method untuk berbagai tipe log
  static Future<void> debug(String message) async =>
      await _log('DEBUG', message);
  static Future<void> info(String message) async => await _log('INFO', message);
  static Future<void> warning(String message) async =>
      await _log('WARNING', message);
  static Future<void> error(String message, [dynamic error]) async {
    final errorMessage = error != null ? '$message: $error' : message;
    await _log('ERROR', errorMessage);
  }

  // Method untuk membaca semua log
  static Future<String> readLogs() async {
    if (await _logFile.exists()) {
      return await _logFile.readAsString();
    }
    return '';
  }

  // Method untuk membaca N baris terakhir dari log
  static Future<String> readLastLogs(int lines) async {
    if (await _logFile.exists()) {
      final contents = await _logFile.readAsString();
      final allLines = contents.split('\n');
      final lastLines = allLines.length > lines
          ? allLines.sublist(allLines.length - lines)
          : allLines;
      return lastLines.join('\n');
    }
    return '';
  }

  // Method untuk membersihkan log
  static Future<void> clearLogs() async {
    await _logFile.writeAsString('');
    await _log('INFO', 'Logs cleared');
  }

  // Method untuk mendapatkan path file log
  static Future<String> getLogFilePath() async {
    return _logFile.path;
  }
}
