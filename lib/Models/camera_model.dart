class CameraModel {
  final String cameraName;
  final String streamUrl;
  String location;

  CameraModel(
      {required this.cameraName,
      required this.streamUrl,
      this.location = "Unknown Location"});

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      cameraName: json['cameraName'],
      streamUrl: json['streamUrl'],
    );
  }
}
