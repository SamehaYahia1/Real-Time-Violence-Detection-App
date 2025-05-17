class CameraModel {
  final String cameraName;
  final String streamUrl;

  CameraModel({required this.cameraName, required this.streamUrl});

  factory CameraModel.fromJson(Map<String, dynamic> json) {
    return CameraModel(
      cameraName: json['cameraName'],
      streamUrl: json['streamUrl'],
    );
  }
}
