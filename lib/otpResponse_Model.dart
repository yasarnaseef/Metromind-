class OtpResponse {
  final int data;
  final bool status;
  final String message;

  OtpResponse(this.data, this.status, this.message);

  factory OtpResponse.fromJson(Map<String, dynamic> json) =>
      OtpResponse(json['data'], json['status'], json['message']);
}