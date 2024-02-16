import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visivista/api/base_url.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/team_member.dart';

class TeamsApi {
  String baseUrl = GlobalApi.getBaseUrl();

  //getData
  Future<List<TeamMember>> indexMemberByTeam(int idTeam) async {
    Uri url = Uri.parse('${baseUrl}team/indexMember/$idTeam');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<TeamMember> listData = dataFromResponse
          .map<TeamMember>((tempData) => TeamMember.fromJson(tempData))
          .toList();
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //getData
  Future<List<TeamMember>> indexTeamByMember() async {
    Uri url = Uri.parse('${baseUrl}team/indexTeam');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<TeamMember> listData = dataFromResponse
          .map<TeamMember>((tempData) => TeamMember.fromJson(tempData))
          .toList();
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //add Team
  Future addTeam(String teamName) async {
    Uri url = Uri.parse('${baseUrl}team/team');

    final response = await http.post(
      url,
      body: {
        "team_name": teamName,
      },
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 201) {
      // Parse response body to Map
      Map<String, dynamic> responseBody = json.decode(response.body);

      // Access and print the 'id' from the 'data' object in the response
      GlobalItem.newTeamId = responseBody['data']['id'];
      return true;
    } else {
      return false;
    }
  }

  Future inviteToTeam(int idTeam, int idUser) async {
    Uri url = Uri.parse('${baseUrl}team/invite');

    final response = await http.post(
      url,
      body: {
        "id_team": idTeam.toString(),
        "id_user": idUser.toString(),
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

  //add Team
  Future addOwnertoTeam(int idTeam) async {
    Uri url = Uri.parse('${baseUrl}team/addOwner');

    final response = await http.post(
      url,
      body: {
        "id_team": idTeam.toString(),
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

  Future editTeam(int idTeam, String teamName) async {
    Uri url = Uri.parse('${baseUrl}team/team/$idTeam');

    final response = await http.put(
      url,
      body: {
        "team_name": teamName,
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

  // delete
  Future<bool> delete(int idTeam) async {
    final url = Uri.parse('${baseUrl}team/deleteTeam/$idTeam');

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

  Future<bool> quit(int idTeam) async {
    final url = Uri.parse('${baseUrl}team/quitTeam/$idTeam');

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

  //team Notifications
  Future sendNotification(
      int idTeam, int idUser, String? message, String? title) async {
    Uri url = Uri.parse('${baseUrl}team/sendInvitation');

    final response = await http.post(
      url,
      body: {
        "id_team": idTeam.toString(),
        "id_user": idUser.toString(),
        "message": message,
        "title": title,
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
