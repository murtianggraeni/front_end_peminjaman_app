class MonitoringData {
  final String totalDurationToday;
  final String totalDurationAll;
  final int userCountToday;
  final int userCountAll;
  final List<UserDetail> userDetails;

  MonitoringData({
    required this.totalDurationToday,
    required this.totalDurationAll,
    required this.userCountToday,
    required this.userCountAll,
    required this.userDetails,
  });

  factory MonitoringData.fromJson(Map<String, dynamic> json) {
    var userDetailsList = json['userDetails'] as List;
    List<UserDetail> userDetails = userDetailsList
        .map((userJson) => UserDetail.fromJson(userJson))
        .toList();

    return MonitoringData(
      totalDurationToday: json['totalDurationToday'],
      totalDurationAll: json['totalDurationAll'],
      userCountToday: json['userCountToday'],
      userCountAll: json['userCountAll'],
      userDetails: userDetails,
    );
  }
}

class UserDetail {
  final String nama;
  final String kategori;
  final String detailKeperluan;
  final String durasi;

  UserDetail({
    required this.nama,
    required this.kategori,
    required this.detailKeperluan,
    required this.durasi,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      nama: json['nama'],
      kategori: json['kategori'],
      detailKeperluan: json['detail_keperluan'],
      durasi: json['durasi'],
    );
  }
}