part of petisland_core.domain;


class LocationResponse {
  List<LocationInfo> predictions;
  String status;
  bool get success => status == 'OK';
  
  LocationResponse.fromJson(Map<String, dynamic> json) {
    final items = json['results'] as List ?? [];
    if (json['status'] != null) {
      status = json['status']['message'];
    }
    predictions = items.map((json) => LocationInfo.fromJson(json)).toList();
  }

  LocationResponse.empty() {
    predictions = [];
    status = 'OK';
  }
}