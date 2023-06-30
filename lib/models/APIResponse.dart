class ApiResponse {
  final String type;
  final String version;
  final String generated_timestamp;
  final List<dynamic> data;

  ApiResponse(
      {required this.type,
      required this.version,
      required this.generated_timestamp,
      required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      type: json['type'],
      version: json['version'],
      generated_timestamp: json['generated_timestamp'],
      data: json['data'],
    );
  }
}
