class VerifyModel {
  final String email;
  final String verificationCode;

  VerifyModel({required this.email, required this.verificationCode});

  Map<String, dynamic> toJson() {
    return {"email": email, "verificationCode": verificationCode};
  }
}
