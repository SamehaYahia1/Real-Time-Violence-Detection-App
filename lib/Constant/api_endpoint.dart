class ApiEndpoints {
  static const String baseUrl =
      'http://192.168.1.69:5000'; //10.0.2.2 if we running on the emulator , but on real device use 192.168.1.69
  static const String login = '$baseUrl/api/Auth/login';
  static const String register = '$baseUrl/api/Auth/register';
  static const String verify = '$baseUrl/api/Auth/verify';
  static const String subscriptionPlans = '$baseUrl/api/SubscriptionPlans';
  //static const String cameras = '$baseUrl/api/Camera/streams';
  static const String AddCamera = '$baseUrl/api/Camera/add';
}
