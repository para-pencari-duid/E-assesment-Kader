import 'dart:convert';

import 'package:e_assesment_kader_app/data/models/modul_model.dart';
import 'package:e_assesment_kader_app/data/responses/answers_post_request.dart';
import 'package:e_assesment_kader_app/data/responses/answers_post_response.dart';
import 'package:e_assesment_kader_app/data/responses/question_list_response.dart';
import 'package:e_assesment_kader_app/data/responses/submodul_list_response.dart';
import 'package:http/http.dart' as http;

class ModulService {
  static const String _baseUrl = "https://kemenkes.tegararsyadani.my.id/api";

  Future<List<ModulModel>> getModulList(String token) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/kompetensi"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return List<ModulModel>.from(
          json.decode(response.body).map((x) => ModulModel.fromJson(x)));
    } else {
      throw Exception('Failed to load model data');
    }
  }

  Future<SubmodulListResponse> getSubmodulList(
      String token, int modulId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/kompetensi/$modulId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return SubmodulListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load model data');
    }
  }

  Future<QuestionListResponse> getQuestionList(
      String token, int submodulId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/users/keterampilan/$submodulId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return QuestionListResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load model data');
    }
  }

  Future<AnswersPostResponse> postAnswers(
      String token, int kaderId, AnswersPostRequest data) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/users/nilai-kader/$kaderId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data.toJson()),
    );

    print("RESPONSE STATUS CODE: ${response.statusCode}");
    print("RESPONSE QUESTIONS: ${response.body}");

    if (response.statusCode == 201) {
      return AnswersPostResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load model data');
    }
  }
}
