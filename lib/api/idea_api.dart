import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/idea.dart';
import 'package:visivista/api/base_url.dart';

class IdeaApi {
  String baseUrl = GlobalApi.getBaseUrl();

  //getData
  Future<List<Idea>> getDataIdea() async {
    Uri url = Uri.parse('${baseUrl}idea/ideaIndex');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<Idea> listData = dataFromResponse
          .map<Idea>((tempData) => Idea.fromJson(tempData))
          .toList();
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

// delete
  Future<bool> delete(int idIdea) async {
    final url = Uri.parse('${baseUrl}idea/deleteIdea/$idIdea');

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

//get Idea
  Future<Idea> getIdea(int idIdea) async {
    Uri url = Uri.parse('${baseUrl}idea/getIdea/$idIdea');

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
        return Idea.fromJson(dataUser);
      } else {
        throw Exception('Invalid data format in response');
      }
    } else {
      throw Exception('Failed to connect to $baseUrl');
    }
  }

  //add Idea
  Future addIdea(
      String? title, String? description, String? tglPelaksanaan) async {
    Uri url = Uri.parse('${baseUrl}idea/addIdea');

    final response = await http.post(
      url,
      body: {
        "title": title,
        "description": description,
        "tgl_pelaksanaan": tglPelaksanaan,
      },
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  //edit Idea
  Future editIdea(int idIdea, String? title, String? description,
      String? tglPelaksanaan) async {
    Uri url = Uri.parse('${baseUrl}idea/editIdea/$idIdea');

    final response = await http.put(
      url,
      body: {
        "title": title,
        "description": description,
        "tgl_pelaksanaan": tglPelaksanaan,
      },
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
