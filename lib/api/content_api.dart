import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visivista/model/content.dart';
import 'package:visivista/api/base_url.dart';
import 'package:visivista/model/global_item.dart';

class ContentApi {
  String baseUrl = GlobalApi.getBaseUrl();

  //getData
  Future<List<Content>> getDataContent() async {
    Uri url = Uri.parse('${baseUrl}content/contentIndex');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<Content> listData = dataFromResponse
          .map<Content>((tempData) => Content.fromJson(tempData))
          .toList();
      GlobalItem.createdContentCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //index
  Future<List<Content>> indexPosted() async {
    Uri url = Uri.parse('${baseUrl}content/contentIndex');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['posted'] as List<dynamic>;
      List<Content> listData = dataFromResponse
          .map<Content>((tempData) => Content.fromJson(tempData))
          .toList();
      GlobalItem.postedContentCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  Future<Content> getContent(int idContent) async {
    Uri url = Uri.parse('${baseUrl}content/getContent/$idContent');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var dataUser = responseData['data'];
      if (dataUser != null && dataUser is Map<String, dynamic>) {
        return Content.fromJson(dataUser);
      } else {
        throw Exception('Invalid data format in response');
      }
    } else {
      throw Exception('Failed to connect to $baseUrl');
    }
  }

  Future<bool> addContent({
    required int idUser,
    int? idIdea,
    String? photo,
    String? video,
    String? title,
    String? caption,
    String? hashtag,
    String? voiceOverTeks,
    String? team,
    String? postScheduled,
  }) async {
    try {
      Uri url = Uri.parse('${baseUrl}content/addContent');

      // Membuat request dengan tipe Multipart
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${GlobalItem.userToken}'
        ..fields.addAll({
          "id_user": idUser.toString(),
          "id_idea": idIdea.toString(),
          "title": title ?? "",
          "caption": caption ?? "",
          "hashtag": hashtag ?? "",
          "voice_over_teks": voiceOverTeks ?? "",
          "team": team ?? "",
          "post_scheduled": postScheduled ?? "",
        });

      // Menambahkan file gambar ke request
      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photo,
          ),
        );
      }
      // Menambahkan file video ke request
      if (video != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'video',
            video,
          ),
        );
      }

      // Mengirim request dan mendapatkan response
      final response = await request.send();

      // print(request);
      // String responseBody = await response.stream.bytesToString();
      // print("=================================================");
      // print(responseBody);
      // print(response.statusCode);
      // print("=================================================");

      // Menanggapi response
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> editContent({
    required int id,
    required int idUser,
    int? idIdea,
    String? photo,
    String? video,
    String? title,
    String? caption,
    String? hashtag,
    String? voiceOverTeks,
    String? team,
    String? postScheduled,
  }) async {
    try {
      Uri url = Uri.parse('${baseUrl}content/editContent/$id');

      // Membuat request dengan tipe Multipart
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${GlobalItem.userToken}'
        ..fields.addAll({
          "id_user": idUser.toString(),
          "id_idea": idIdea.toString(),
          "title": title ?? "",
          "caption": caption ?? "",
          "hashtag": hashtag ?? "",
          "voice_over_teks": voiceOverTeks ?? "",
          "team": team ?? "",
          "post_scheduled": postScheduled ?? "",
        });

      // Menambahkan file gambar ke request
      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photo,
          ),
        );
      }
      // Menambahkan file video ke request
      if (video != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'video',
            video,
          ),
        );
      }

      // Mengirim request dan mendapatkan response
      final response = await request.send();

      // String responseBody = await response.stream.bytesToString();
      // print(id.toString());
      // print("IdUser $idUser");
      // print(responseBody);
      // print(request);
      // print(response.statusCode);

      // Menanggapi response
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> delete(int id) async {
    final url = Uri.parse('${baseUrl}content/deleteContent/$id');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
