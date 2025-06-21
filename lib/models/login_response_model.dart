class LoginResponseModel {
  final int status;
  final String message;

  LoginResponseModel({required this.status, required this.message});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'],
      message: json['message'],
    );
  }
}
