import 'dart:convert';

import 'package:e_assesment_kader_app/data/responses/kader_list_response.dart';
import 'package:e_assesment_kader_app/data/responses/kader_register_response.dart';
import 'package:e_assesment_kader_app/data/responses/result_kader_response.dart';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class KaderService {
  static const String _baseUrl = "https://kemenkes.tegararsyadani.my.id/api";

  Future<KaderListResponse> getKaderList(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/kaders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return KaderListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load puskesmas list');
    }
  }

  Future<KaderListResponse> getKaderListPaging(String token,
      [int page = 1, int size = 10]) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/kaders?page=$page&size=$size"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return KaderListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load puskesmas list');
    }
  }

  Future<RegisterKaderResponse> postRegisterKader(
      UserModel model, String token) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/users/registerkader"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(model.registerKaderToJson()),
    );

    print("REGISTER CODE: ${response.statusCode}");
    print("REGISTER BODY: ${response.body}");

    if (response.statusCode == 201) {
      return RegisterKaderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create data kader');
    }
  }

  Future<ResultKaderResponse> getResultKader(
      String token, String kaderId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/result/$kaderId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return ResultKaderResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load puskesmas list');
    }
  }
}
