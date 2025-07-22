import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:japx/japx.dart';
import 'package:machinetestlilac/Models/chatMessage_Model.dart';
import 'package:machinetestlilac/Models/customer_model.dart';
import 'package:machinetestlilac/constants/functions.dart';
import 'package:machinetestlilac/otpResponse_Model.dart';
import 'package:machinetestlilac/screens/otp_screen.dart';

class MainProvider  with ChangeNotifier {
  /// logins
  TextEditingController phoneNumberController = TextEditingController();

  static const base = 'https://test.myfliqapp.com/api/v1';
  static final dio = Dio(BaseOptions(baseUrl: base));

  static Future<OtpResponse> requestOtp(String phone) async {
    final payload = {
      "data": {
        "type": "registration_otp_codes",
        "attributes": {"phone": phone}
      }
    };

    final res = await dio.post(
      '/auth/registration-otp-codes/actions/phone/send-otp',
      data: payload,
    );

    return OtpResponse.fromJson(res.data);
  }

  bool loading = false;
  String? error;
  int otpNumber = 0;

  Future<void> sendOtp(BuildContext context) async {
    otpNumber = 0;
    loading = true;
    error = null;
    notifyListeners();
    if (phoneNumberController.text.isEmpty) {
      loading = false;
      error = null;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter phone number"),
          backgroundColor: Colors.red,),
      );
      return;
    }
    try {
      final res = await requestOtp('+91${phoneNumberController.text}');
      if (res.status) {
        callNext(OtpScreen(), context);
        otpNumber = res.data;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message)),
        );
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }


  /// VERIFY OTP
  String? accessToken;
  String? loginUserId;


  Future<Map<String, dynamic>> verifyOtp(int otp) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'laravel_session=2p4Cn7NAYhHxMtUIemhF3zMTr4QKaLaUMgovdTSI'
    };

    var request = http.Request(
      'POST',
      Uri.parse(
          'https://test.myfliqapp.com/api/v1/auth/registration-otp-codes/actions/phone/verify-otp'),
    );

    request.body = json.encode({
      "data": {
        "type": "registration_otp_codes",
        "attributes": {
          "phone": "++918087808780", // Fixed: removed extra '+'
          "otp": otp,
          "device_meta": {
            "type": "web",
            "device-name": "HP Pavilion 14-EP0068TU",
            "device-os-version": "Linux x86_64",
            "browser": "Mozilla Firefox Snap for Ubuntu (64-bit)",
            "browser_version": "112.0.2",
            "user-agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0",
            "screen_resolution": "1600x900",
            "language": "en-GB"
          }
        }
      }
    });

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(responseBody);
        final decoded = Japx.decode(jsonMap); // Correct usage
        print('Response: $decoded');
        accessToken = decoded['data']['auth_status']['access_token'];
        loginUserId= decoded['data']['id'];
        print('Access Token: $accessToken');
        print('loginUserId : $loginUserId');
        return decoded;
      } else {
        print('Failed: ${response.statusCode} - ${response.reasonPhrase}');
        return {"error": response.reasonPhrase ?? "Unknown error"};
      }
    } catch (e) {
      print('Exception: $e');
      return {"error": e.toString()};
    }
  }


  Future<List<Customer>> getChatProfiles() async {
    final url = Uri.parse(
        'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/contact-users');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
      'Bearer 994|IUkHmNtxSfRG3LwDQ8f9H5xFmo9kUkSktH2cIBkJ9cb72019',
      'Cookie':
      'laravel_session=2p4Cn7NAYhHxMtUIemhF3zMTr4QKaLaUMgovdTSI',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode the raw response
        final rawJson = json.decode(response.body);

        // Use Japx to decode JSON:API to plain JSON
        final decoded = Japx.decode(rawJson);

        // Extract the list of customers
        final List<dynamic> data = decoded['data'] ?? [];

        return data.map((item) => Customer.fromJson(item)).toList();
      } else {
        print('Failed: ${response.statusCode} - ${response.reasonPhrase}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
  String convertToTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm a').format(dateTime).toLowerCase();
  }

  Future<List<ChatMessage>> getChatBetweenUsers({
    required int senderId,
    required int receiverId,
  }) async {
    print("dddddddddddddd $senderId");
    print("receiverId $receiverId");
    final url = Uri.parse(
      'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/chat-between-users/$senderId/$receiverId',
      // 'https://test.myfliqapp.com/api/v1/chat/chat-messages/queries/chat-between-users/55/81',
    );

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer 994|IUkHmNtxSfRG3LwDQ8f9H5xFmo9kUkSktH2cIBkJ9cb72019',
      'Cookie': 'laravel_session=2p4Cn7NAYhHxMtUIemhF3zMTr4QKaLaUMgovdTSI',
    };

    final request = http.Request('GET', url);
    request.headers.addAll(headers);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final List<dynamic> data = jsonData['data'] ?? [];
      print("ddddddddddddddd :$jsonData");

      return data.map((item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load chat: ${response.reasonPhrase}');
    }
  }



}






