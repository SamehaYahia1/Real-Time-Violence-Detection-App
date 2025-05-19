import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/Constant/api_endpoint.dart';
import 'package:flutter_application_1/Constant/token_handler.dart';

class CameraDiscoveryService {
  static const MethodChannel _platform = MethodChannel('onvif_discovery');

  static Future<Map<String, String>?> discoverAndSaveCamera(
      String cameraName) async {
    try {
      final List<dynamic> cameras =
          await _platform.invokeMethod('discoverOnvifCameras');

      if (cameras.isNotEmpty) {
        final ip = cameras[0]['ip'];
        final rtspUrl = "rtsp://admin:admin123456@192.168.1.57:8554/profile0";

        final token = await TokenHandler().getToken();
        if (token == null) {
          print('Token missing');
          return null;
        }

        final response = await http.post(
          Uri.parse('${ApiEndpoints.baseUrl}/api/Camera/add'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'cameraName': cameraName,
            'streamUrl': rtspUrl,
          }),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('Camera added successfully.');
          return {
            'cameraName': cameraName,
            'streamUrl': rtspUrl,
          };
        } else if (response.statusCode == 500) {
          return {'error': 'You have already added this camera.'};
        } else {
          print('Failed to add camera: ${response.body}');
          return {'error': 'Failed to add camera'};
        }
      }
    } catch (e) {
      print('Discovery error: $e');
      return {'error': 'Camera discovery failed'};
    }
    return null;
  }
}
