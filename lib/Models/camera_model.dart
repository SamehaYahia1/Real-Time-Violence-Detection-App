class CameraModel {
  final String cameraName;
  final String streamUrl;
  String location;
  final String id;

  CameraModel(
      {required this.cameraName,
      required this.streamUrl,
      required this.id,
      this.location = "Unknown Location"});

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      cameraName: json['cameraName'],
      streamUrl: json['streamUrl'],
      id: json['id'],
    );
  }
}
