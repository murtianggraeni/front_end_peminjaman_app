// Metode 1
// class MonitoringData {
//   final String totalDurationToday;
//   final String totalDurationAll;
//   final int userCountToday;
//   final int userCountAll;
//   final List<UserDetail> userDetails;

//   MonitoringData({
//     required this.totalDurationToday,
//     required this.totalDurationAll,
//     required this.userCountToday,
//     required this.userCountAll,
//     required this.userDetails,
//   });

//   factory MonitoringData.fromJson(Map<String, dynamic> json) {
//     var userDetailsList = json['userDetails'] as List;
//     List<UserDetail> userDetails = userDetailsList
//         .map((userJson) => UserDetail.fromJson(userJson))
//         .toList();

//     return MonitoringData(
//       totalDurationToday: json['totalDurationToday'],
//       totalDurationAll: json['totalDurationAll'],
//       userCountToday: json['userCountToday'],
//       userCountAll: json['userCountAll'],
//       userDetails: userDetails,
//     );
//   }
// }

// class UserDetail {
//   final String nama;
//   final String kategori;
//   final String detailKeperluan;
//   final String durasi;

//   UserDetail({
//     required this.nama,
//     required this.kategori,
//     required this.detailKeperluan,
//     required this.durasi,
//   });

//   factory UserDetail.fromJson(Map<String, dynamic> json) {
//     return UserDetail(
//       nama: json['nama'],
//       kategori: json['kategori'],
//       detailKeperluan: json['detail_keperluan'],
//       durasi: json['durasi'],
//     );
//   }
// }

// class MonitoringData {
//   final Stats stats;
//   final List<UserDetail> userDetails;

//   MonitoringData({
//     required this.stats,
//     required this.userDetails,
//   });

//   factory MonitoringData.fromJson(Map<String, dynamic> json) {
//     return MonitoringData(
//       stats: Stats.fromJson(json['stats']),
//       userDetails: (json['userDetails'] as List)
//           .map((detail) => UserDetail.fromJson(detail))
//           .toList(),
//     );
//   }

//   // Default constructor for empty state
//   factory MonitoringData.empty() {
//     return MonitoringData(
//       stats: Stats.empty(),
//       userDetails: [],
//     );
//   }
// }

// class Stats {
//   final TodayStats today;
//   final AllStats all;

//   Stats({
//     required this.today,
//     required this.all,
//   });

//   factory Stats.fromJson(Map<String, dynamic> json) {
//     return Stats(
//       today: TodayStats.fromJson(json['today']),
//       all: AllStats.fromJson(json['all']),
//     );
//   }

//   factory Stats.empty() {
//     return Stats(
//       today: TodayStats.empty(),
//       all: AllStats.empty(),
//     );
//   }
// }

// class TodayStats {
//   final String totalDuration;
//   final int userCount;
//   final List<ActiveUser> activeUsers;

//   TodayStats({
//     required this.totalDuration,
//     required this.userCount,
//     required this.activeUsers,
//   });

//   factory TodayStats.fromJson(Map<String, dynamic> json) {
//     return TodayStats(
//       totalDuration: json['totalDuration'],
//       userCount: json['userCount'],
//       activeUsers: (json['activeUsers'] as List)
//           .map((user) => ActiveUser.fromJson(user))
//           .toList(),
//     );
//   }

//   factory TodayStats.empty() {
//     return TodayStats(
//       totalDuration: '0j 0m',
//       userCount: 0,
//       activeUsers: [],
//     );
//   }
// }

// class AllStats {
//   final String totalDuration;
//   final int userCount;
//   final String averageDurationPerUser;

//   AllStats({
//     required this.totalDuration,
//     required this.userCount,
//     required this.averageDurationPerUser,
//   });

//   factory AllStats.fromJson(Map<String, dynamic> json) {
//     return AllStats(
//       totalDuration: json['totalDuration'],
//       userCount: json['userCount'],
//       averageDurationPerUser: json['averageDurationPerUser'],
//     );
//   }

//   factory AllStats.empty() {
//     return AllStats(
//       totalDuration: '0j 0m',
//       userCount: 0,
//       averageDurationPerUser: '0j 0m',
//     );
//   }
// }

// class UserDetail {
//   final String id;
//   final String nama;
//   final String email;
//   final String kategori;
//   final String detailKeperluan;
//   final String durasi;
//   final String tanggal;
//   final String waktuMulai;
//   final String waktuSelesai;
//   final String tipePengguna;
//   final String nomorIdentitas;

//   UserDetail({
//     required this.id,
//     required this.nama,
//     required this.email,
//     required this.kategori,
//     required this.detailKeperluan,
//     required this.durasi,
//     required this.tanggal,
//     required this.waktuMulai,
//     required this.waktuSelesai,
//     required this.tipePengguna,
//     required this.nomorIdentitas,
//   });

//   factory UserDetail.fromJson(Map<String, dynamic> json) {
//     return UserDetail(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       email: json['email'] ?? '',
//       kategori: json['kategori'] ?? '',
//       detailKeperluan: json['detail_keperluan'] ?? '',
//       durasi: json['durasi'] ?? '',
//       tanggal: json['tanggal'] ?? '',
//       waktuMulai: json['waktu_mulai'] ?? '',
//       waktuSelesai: json['waktu_selesai'] ?? '',
//       tipePengguna: json['tipe_pengguna'] ?? '',
//       nomorIdentitas: json['nomor_identitas'] ?? '',
//     );
//   }
// }

// class ActiveUser {
//   final String id;
//   final String nama;
//   final String mulai;
//   final String selesai;

//   ActiveUser({
//     required this.id,
//     required this.nama,
//     required this.mulai,
//     required this.selesai,
//   });

//   factory ActiveUser.fromJson(Map<String, dynamic> json) {
//     return ActiveUser(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       mulai: json['mulai'] ?? '',
//       selesai: json['selesai'] ?? '',
//     );
//   }
// }

// ----------------------------------------------------------------------------------------------------------------- //
// class MonitoringData {
//   final Stats stats;
//   final List<UserDetail> userDetails;
//   final TrendsData trends;
//   final String type;
//   final String date;

//   MonitoringData({
//     required this.stats,
//     required this.userDetails,
//     required this.trends,
//     required this.type,
//     required this.date,
//   });

//   factory MonitoringData.fromJson(Map<String, dynamic> json) {
//     return MonitoringData(
//       stats: Stats.fromJson(json['stats']),
//       userDetails: (json['userDetails'] as List)
//           .map((detail) => UserDetail.fromJson(detail))
//           .toList(),
//       trends: TrendsData.fromJson(json['trends']),
//       type: json['type'] ?? '',
//       date: json['date'] ?? '',
//     );
//   }

//   factory MonitoringData.empty() {
//     return MonitoringData(
//       stats: Stats.empty(),
//       userDetails: [],
//       trends: TrendsData.empty(),
//       type: '',
//       date: '',
//     );
//   }
// }

// class Stats {
//   final TodayStats today;
//   final AllStats all;

//   Stats({
//     required this.today,
//     required this.all,
//   });

//   factory Stats.fromJson(Map<String, dynamic> json) {
//     return Stats(
//       today: TodayStats.fromJson(json['today']),
//       all: AllStats.fromJson(json['all']),
//     );
//   }

//   factory Stats.empty() {
//     return Stats(
//       today: TodayStats.empty(),
//       all: AllStats.empty(),
//     );
//   }
// }

// class TodayStats {
//   final String totalDuration;
//   final int userCount;
//   final List<ActiveUser> activeUsers;
//   final UserTypeStats byUserType;

//   TodayStats({
//     required this.totalDuration,
//     required this.userCount,
//     required this.activeUsers,
//     required this.byUserType,
//   });

//   factory TodayStats.fromJson(Map<String, dynamic> json) {
//     return TodayStats(
//       totalDuration: json['totalDuration'] ?? '0j 0m 0d',
//       userCount: json['userCount'] ?? 0,
//       activeUsers: ((json['activeUsers'] ?? []) as List)
//           .map((user) => ActiveUser.fromJson(user))
//           .toList(),
//       byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
//     );
//   }

//   factory TodayStats.empty() {
//     return TodayStats(
//       totalDuration: '0j 0m 0d',
//       userCount: 0,
//       activeUsers: [],
//       byUserType: UserTypeStats.empty(),
//     );
//   }
// }

// class AllStats {
//   final String totalDuration;
//   final int userCount;
//   final String averageDurationPerUser;
//   final UserTypeStats byUserType;

//   AllStats({
//     required this.totalDuration,
//     required this.userCount,
//     required this.averageDurationPerUser,
//     required this.byUserType,
//   });

//   factory AllStats.fromJson(Map<String, dynamic> json) {
//     return AllStats(
//       totalDuration: json['totalDuration'] ?? '0j 0m 0d',
//       userCount: json['userCount'] ?? 0,
//       averageDurationPerUser: json['averageDurationPerUser'] ?? '0j 0m 0d',
//       byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
//     );
//   }

//   factory AllStats.empty() {
//     return AllStats(
//       totalDuration: '0j 0m 0d',
//       userCount: 0,
//       averageDurationPerUser: '0j 0m 0d',
//       byUserType: UserTypeStats.empty(),
//     );
//   }
// }

// class UserTypeStats {
//   final int mahasiswa;
//   final int pekerja;
//   final int pklMagang;
//   final int external;

//   UserTypeStats({
//     required this.mahasiswa,
//     required this.pekerja,
//     required this.pklMagang,
//     required this.external,
//   });

//   factory UserTypeStats.fromJson(Map<String, dynamic> json) {
//     return UserTypeStats(
//       mahasiswa: json['mahasiswa'] ?? 0,
//       pekerja: json['pekerja'] ?? 0,
//       pklMagang: json['pkl_magang'] ?? 0,
//       external: json['external'] ?? 0,
//     );
//   }

//   factory UserTypeStats.empty() {
//     return UserTypeStats(
//       mahasiswa: 0,
//       pekerja: 0,
//       pklMagang: 0,
//       external: 0,
//     );
//   }

//   int get total => mahasiswa + pekerja + pklMagang + external;
// }

// class TrendsData {
//   final WeeklyTrends weekly;
//   final MonthlyTrends monthly;

//   TrendsData({
//     required this.weekly,
//     required this.monthly,
//   });

//   factory TrendsData.fromJson(Map<String, dynamic> json) {
//     return TrendsData(
//       weekly: WeeklyTrends.fromJson(json['weekly'] ?? {}),
//       monthly: MonthlyTrends.fromJson(json['monthly'] ?? {}),
//     );
//   }

//   factory TrendsData.empty() {
//     return TrendsData(
//       weekly: WeeklyTrends.empty(),
//       monthly: MonthlyTrends.empty(),
//     );
//   }
// }

// class WeeklyTrends {
//   final List<DailyStats> data;
//   final DateRange dateRange;

//   WeeklyTrends({
//     required this.data,
//     required this.dateRange,
//   });

//   factory WeeklyTrends.fromJson(Map<String, dynamic> json) {
//     return WeeklyTrends(
//       data: ((json['data'] ?? []) as List)
//           .map((day) => DailyStats.fromJson(day))
//           .toList(),
//       dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
//     );
//   }

//   factory WeeklyTrends.empty() {
//     return WeeklyTrends(
//       data: [],
//       dateRange: DateRange.empty(),
//     );
//   }
// }

// class MonthlyTrends {
//   final List<WeeklyStats> data;
//   final DateRange dateRange;

//   MonthlyTrends({
//     required this.data,
//     required this.dateRange,
//   });

//   factory MonthlyTrends.fromJson(Map<String, dynamic> json) {
//     return MonthlyTrends(
//       data: ((json['data'] ?? []) as List)
//           .map((week) => WeeklyStats.fromJson(week))
//           .toList(),
//       dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
//     );
//   }

//   factory MonthlyTrends.empty() {
//     return MonthlyTrends(
//       data: [],
//       dateRange: DateRange.empty(),
//     );
//   }
// }

// class DailyStats {
//   final DateTime date;
//   final StatsDetails stats;

//   DailyStats({
//     required this.date,
//     required this.stats,
//   });

//   factory DailyStats.fromJson(Map<String, dynamic> json) {
//     return DailyStats(
//       date: DateTime.parse(json['date']),
//       stats: StatsDetails.fromJson(json['stats']),
//     );
//   }
// }

// class WeeklyStats {
//   final DateTime startDate;
//   final DateTime endDate;
//   final StatsDetails stats;

//   WeeklyStats({
//     required this.startDate,
//     required this.endDate,
//     required this.stats,
//   });

//   factory WeeklyStats.fromJson(Map<String, dynamic> json) {
//     return WeeklyStats(
//       startDate: DateTime.parse(json['startDate']),
//       endDate: DateTime.parse(json['endDate']),
//       stats: StatsDetails.fromJson(json['stats']),
//     );
//   }
// }

// class StatsDetails {
//   final double totalDuration;
//   final String formattedDuration;
//   final int userCount;
//   final String averageDuration;
//   final UserTypeStats byUserType;
//   final List<DetailedUser> detailedUsers;

//   StatsDetails({
//     required this.totalDuration,
//     required this.formattedDuration,
//     required this.userCount,
//     required this.averageDuration,
//     required this.byUserType,
//     required this.detailedUsers,
//   });

//   factory StatsDetails.fromJson(Map<String, dynamic> json) {
//     return StatsDetails(
//       totalDuration: json['totalDuration']?.toDouble() ?? 0.0,
//       formattedDuration: json['formattedDuration'] ?? '0j 0m 0d',
//       userCount: json['userCount'] ?? 0,
//       averageDuration: json['averageDuration'] ?? '0j 0m 0d',
//       byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
//       detailedUsers: ((json['detailedUsers'] ?? []) as List)
//           .map((user) => DetailedUser.fromJson(user))
//           .toList(),
//     );
//   }
// }

// class DetailedUser {
//   final String id;
//   final String nama;
//   final DateTime waktuMulai;
//   final String waktuSelesai;
//   final String tipePengguna;

//   DetailedUser({
//     required this.id,
//     required this.nama,
//     required this.waktuMulai,
//     required this.waktuSelesai,
//     required this.tipePengguna,
//   });

//   factory DetailedUser.fromJson(Map<String, dynamic> json) {
//     return DetailedUser(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       waktuMulai: DateTime.parse(json['waktuMulai']),
//       waktuSelesai: json['waktuSelesai'] ?? '',
//       tipePengguna: json['tipePengguna'] ?? '',
//     );
//   }
// }

// class DateRange {
//   final DateTime start;
//   final DateTime end;

//   DateRange({
//     required this.start,
//     required this.end,
//   });

//   factory DateRange.fromJson(Map<String, dynamic> json) {
//     return DateRange(
//       start: DateTime.parse(json['start']),
//       end: DateTime.parse(json['end']),
//     );
//   }

//   factory DateRange.empty() {
//     final now = DateTime.now();
//     return DateRange(
//       start: now,
//       end: now,
//     );
//   }
// }

// class UserDetail {
//   final String id;
//   final String nama;
//   final String email;
//   final String tipePengguna;
//   final String nomorIdentitas;
//   final String kategori;
//   final String detailKeperluan;
//   final String durasi;
//   final String tanggal;
//   final String waktuAktivasi;
//   final String waktuMulai;
//   final String waktuSelesai;
//   final String statusAktif;

//   UserDetail({
//     required this.id,
//     required this.nama,
//     required this.email,
//     required this.tipePengguna,
//     required this.nomorIdentitas,
//     required this.kategori,
//     required this.detailKeperluan,
//     required this.durasi,
//     required this.tanggal,
//     required this.waktuAktivasi,
//     required this.waktuMulai,
//     required this.waktuSelesai,
//     required this.statusAktif,
//   });

//   factory UserDetail.fromJson(Map<String, dynamic> json) {
//     return UserDetail(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       email: json['email'] ?? '',
//       tipePengguna: json['tipe_pengguna'] ?? '',
//       nomorIdentitas: json['nomor_identitas'] ?? '',
//       kategori: json['kategori'] ?? '',
//       detailKeperluan: json['detail_keperluan'] ?? '',
//       durasi: json['durasi'] ?? '',
//       tanggal: json['tanggal'] ?? '',
//       waktuAktivasi: json['waktu_aktivasi'] ?? '',
//       waktuMulai: json['waktu_mulai'] ?? '',
//       waktuSelesai: json['waktu_selesai'] ?? '',
//       statusAktif: json['status_aktif'] ?? '',
//     );
//   }
// }

// class ActiveUser {
//   final String id;
//   final String nama;
//   final String mulai;
//   final String selesai;

//   ActiveUser({
//     required this.id,
//     required this.nama,
//     required this.mulai,
//     required this.selesai,
//   });

//   factory ActiveUser.fromJson(Map<String, dynamic> json) {
//     return ActiveUser(
//       id: json['id'] ?? '',
//       nama: json['nama'] ?? '',
//       mulai: json['mulai'] ?? '',
//       selesai: json['selesai'] ?? '',
//     );
//   }
// }

// ------------------------------------------------------------------------------------------------------------ //

class MonitoringData {
  final Stats stats;
  final List<UserDetail> userDetails;
  final TrendsData trends;
  final String type;
  final String date;
  final bool success;

  MonitoringData({
    required this.stats,
    required this.userDetails,
    required this.trends,
    required this.type,
    required this.date,
    required this.success,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    return MonitoringData(
      stats: Stats.fromJson(json['stats'] ?? {}),
      userDetails: (json['userDetails'] as List? ?? [])
          .map((detail) => UserDetail.fromJson(detail))
          .toList(),
      trends: TrendsData.fromJson(json['trends'] ?? {}),
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      success: json['success'] ?? false,
    );
  }

  factory MonitoringData.empty() {
    return MonitoringData(
      stats: Stats.empty(),
      userDetails: [],
      trends: TrendsData.empty(),
      type: '',
      date: '',
      success: false,
    );
  }
}

class Stats {
  final TodayStats today;
  final AllStats all;

  Stats({
    required this.today,
    required this.all,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      today: TodayStats.fromJson(json['today'] ?? {}),
      all: AllStats.fromJson(json['all'] ?? {}),
    );
  }

  factory Stats.empty() {
    return Stats(
      today: TodayStats.empty(),
      all: AllStats.empty(),
    );
  }
}

class TodayStats {
  final String totalDuration;
  final int userCount;
  final List<ActiveUser> activeUsers;
  final UserTypeStats byUserType;

  TodayStats({
    required this.totalDuration,
    required this.userCount,
    required this.activeUsers,
    required this.byUserType,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      totalDuration: json['totalDuration'] ?? '0j 0m 0d',
      userCount: json['userCount'] ?? 0,
      activeUsers: ((json['activeUsers'] ?? []) as List)
          .map((user) => ActiveUser.fromJson(user))
          .toList(),
      byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
    );
  }

  factory TodayStats.empty() {
    return TodayStats(
      totalDuration: '0j 0m 0d',
      userCount: 0,
      activeUsers: [],
      byUserType: UserTypeStats.empty(),
    );
  }
}

class AllStats {
  final String totalDuration;
  final int userCount;
  final String averageDurationPerUser;
  final UserTypeStats byUserType;

  AllStats({
    required this.totalDuration,
    required this.userCount,
    required this.averageDurationPerUser,
    required this.byUserType,
  });

  factory AllStats.fromJson(Map<String, dynamic> json) {
    return AllStats(
      totalDuration: json['totalDuration'] ?? '0j 0m 0d',
      userCount: json['userCount'] ?? 0,
      averageDurationPerUser: json['averageDurationPerUser'] ?? '0j 0m 0d',
      byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
    );
  }

  factory AllStats.empty() {
    return AllStats(
      totalDuration: '0j 0m 0d',
      userCount: 0,
      averageDurationPerUser: '0j 0m 0d',
      byUserType: UserTypeStats.empty(),
    );
  }
}

class UserTypeStats {
  final int mahasiswa;
  final int pekerja;
  final int pklMagang;
  final int external;

  UserTypeStats({
    required this.mahasiswa,
    required this.pekerja,
    required this.pklMagang,
    required this.external,
  });

  factory UserTypeStats.fromJson(Map<String, dynamic> json) {
    return UserTypeStats(
      mahasiswa: json['mahasiswa'] ?? 0,
      pekerja: json['pekerja'] ?? 0,
      pklMagang: json['pkl_magang'] ?? 0,
      external: json['external'] ?? 0,
    );
  }

  factory UserTypeStats.empty() {
    return UserTypeStats(
      mahasiswa: 0,
      pekerja: 0,
      pklMagang: 0,
      external: 0,
    );
  }

  int get total => mahasiswa + pekerja + pklMagang + external;
}

class TrendsData {
  final WeeklyTrends weekly;
  final MonthlyTrends monthly;

  TrendsData({
    required this.weekly,
    required this.monthly,
  });

  factory TrendsData.fromJson(Map<String, dynamic> json) {
    return TrendsData(
      weekly: WeeklyTrends.fromJson(json['weekly'] ?? {}),
      monthly: MonthlyTrends.fromJson(json['monthly'] ?? {}),
    );
  }

  factory TrendsData.empty() {
    return TrendsData(
      weekly: WeeklyTrends.empty(),
      monthly: MonthlyTrends.empty(),
    );
  }
}

class WeeklyTrends {
  final List<DailyStats> data;
  final DateRange dateRange;

  WeeklyTrends({
    required this.data,
    required this.dateRange,
  });

  factory WeeklyTrends.fromJson(Map<String, dynamic> json) {
    return WeeklyTrends(
      data: ((json['data'] ?? []) as List)
          .map((day) => DailyStats.fromJson(day))
          .toList(),
      dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
    );
  }

  factory WeeklyTrends.empty() {
    return WeeklyTrends(
      data: [],
      dateRange: DateRange.empty(),
    );
  }
}

class MonthlyTrends {
  final List<WeeklyStats> data;
  final DateRange dateRange;

  MonthlyTrends({
    required this.data,
    required this.dateRange,
  });

  factory MonthlyTrends.fromJson(Map<String, dynamic> json) {
    return MonthlyTrends(
      data: ((json['data'] ?? []) as List)
          .map((week) => WeeklyStats.fromJson(week))
          .toList(),
      dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
    );
  }

  factory MonthlyTrends.empty() {
    return MonthlyTrends(
      data: [],
      dateRange: DateRange.empty(),
    );
  }
}

class DailyStats {
  final DateTime date;
  final StatsDetails stats;

  DailyStats({
    required this.date,
    required this.stats,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      date: DateTime.parse(json['date']),
      stats: StatsDetails.fromJson(json['stats'] ?? {}),
    );
  }
}

class WeeklyStats {
  final DateTime startDate;
  final DateTime endDate;
  final StatsDetails stats;

  WeeklyStats({
    required this.startDate,
    required this.endDate,
    required this.stats,
  });

  factory WeeklyStats.fromJson(Map<String, dynamic> json) {
    return WeeklyStats(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      stats: StatsDetails.fromJson(json['stats'] ?? {}),
    );
  }
}

class StatsDetails {
  final double totalDuration;
  final String formattedDuration;
  final int userCount;
  final String averageDuration;
  final UserTypeStats byUserType;
  final List<DetailedUser> detailedUsers;

  StatsDetails({
    required this.totalDuration,
    required this.formattedDuration,
    required this.userCount,
    required this.averageDuration,
    required this.byUserType,
    required this.detailedUsers,
  });

  factory StatsDetails.fromJson(Map<String, dynamic> json) {
    return StatsDetails(
      totalDuration: json['totalDuration']?.toDouble() ?? 0.0,
      formattedDuration: json['formattedDuration'] ?? '0j 0m 0d',
      userCount: json['userCount'] ?? 0,
      averageDuration: json['averageDuration'] ?? '0j 0m 0d',
      byUserType: UserTypeStats.fromJson(json['byUserType'] ?? {}),
      detailedUsers: ((json['detailedUsers'] ?? []) as List)
          .map((user) => DetailedUser.fromJson(user))
          .toList(),
    );
  }
}

class DetailedUser {
  final String id;
  final String nama;
  final DateTime waktuMulai;
  final String waktuSelesai;
  final String tipePengguna;

  DetailedUser({
    required this.id,
    required this.nama,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.tipePengguna,
  });

  factory DetailedUser.fromJson(Map<String, dynamic> json) {
    return DetailedUser(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      waktuMulai: DateTime.parse(json['waktuMulai']),
      waktuSelesai: json['waktuSelesai'] ?? '',
      tipePengguna: json['tipePengguna'] ?? '',
    );
  }
}

class ActiveUser {
  final String id;
  final String nama;
  final DateTime waktuMulai;
  final String waktuSelesai;
  final String tipePengguna;

  ActiveUser({
    required this.id,
    required this.nama,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.tipePengguna,
  });

  factory ActiveUser.fromJson(Map<String, dynamic> json) {
    return ActiveUser(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      waktuMulai: DateTime.parse(json['waktuMulai']),
      waktuSelesai: json['waktuSelesai'] ?? '',
      tipePengguna: json['tipePengguna'] ?? '',
    );
  }
}

class DateRange {
  final DateTime start;
  final DateTime end;

  DateRange({
    required this.start,
    required this.end,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  factory DateRange.empty() {
    final now = DateTime.now();
    return DateRange(
      start: now,
      end: now,
    );
  }
}

class UserDetail {
  final String id;
  final String nama;
  final String email;
  final String tipePengguna;
  final String nomorIdentitas;
  final String kategori;
  final String detailKeperluan;
  final String durasi;
  final String tanggal;
  final String waktuAktivasi;
  final String waktuMulai;
  final String waktuSelesai;
  final String statusAktif;

  UserDetail({
    required this.id,
    required this.nama,
    required this.email,
    required this.tipePengguna,
    required this.nomorIdentitas,
    required this.kategori,
    required this.detailKeperluan,
    required this.durasi,
    required this.tanggal,
    required this.waktuAktivasi,
    required this.waktuMulai,
    required this.waktuSelesai,
    required this.statusAktif,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] ?? '',
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      tipePengguna: json['tipe_pengguna'] ?? '',
      nomorIdentitas: json['nomor_identitas'] ?? '',
      kategori: json['kategori'] ?? '',
      detailKeperluan: json['detail_keperluan'] ?? '',
      durasi: json['durasi'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktuAktivasi: json['waktu_aktivasi'] ?? '',
      waktuMulai: json['waktu_mulai'] ?? '',
      waktuSelesai: json['waktu_selesai'] ?? '',
      statusAktif: json['status_aktif'] ?? '',
    );
  }
}