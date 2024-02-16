import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:visivista/api/base_url.dart';
import 'package:visivista/model/global_item.dart';
import 'package:visivista/model/task.dart';

class TaskApi {
  String baseUrl = GlobalApi.getBaseUrl();

  //index
  Future<List<Task>> getDataTask() async {
    Uri url = Uri.parse('${baseUrl}task/taskIndex');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<Task> listData = dataFromResponse
          .map<Task>((tempData) => Task.fromJson(tempData))
          .toList();
      GlobalItem.createdTaskCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //index
  Future<List<Task>> getTaskWithActuator() async {
    Uri url = Uri.parse('${baseUrl}task/indexTeamByActuator');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<Task> listData = dataFromResponse
          .map<Task>((tempData) => Task.fromJson(tempData))
          .toList();
      GlobalItem.createdTaskCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get Task');
    }
  }

  //index
  Future<List<Task>> getTaskTeam(int idTeam) async {
    Uri url = Uri.parse('${baseUrl}task/indexTeamTask/$idTeam');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['data'] as List<dynamic>;

      List<Task> listData = dataFromResponse
          .map<Task>((tempData) => Task.fromJson(tempData))
          .toList();
      GlobalItem.createdTaskCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //index
  Future<List<Task>> indexChecked() async {
    Uri url = Uri.parse('${baseUrl}task/taskIndex');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      var dataFromResponse = responseData['task'] as List<dynamic>;
      List<Task> listData = dataFromResponse
          .map<Task>((tempData) => Task.fromJson(tempData))
          .toList();
      GlobalItem.completedTaskCount = listData.length;
      return listData;
    } else if (response.statusCode == 0) {
      throw Exception('Failed to connect to $baseUrl');
    } else {
      throw Exception('Failed get data member');
    }
  }

  //get
  Future<Task> getTask(int idTask) async {
    Uri url = Uri.parse('${baseUrl}task/getTask/$idTask');

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
        return Task.fromJson(dataUser);
      } else {
        throw Exception('Invalid data format in response');
      }
    } else {
      throw Exception('Failed to connect to $baseUrl');
    }
  }

  //add task
  Future addTask(
    String? idActuator,
    String? idTeam,
    String? title,
    String? description,
    String? actuator,
    String start,
    String end,
  ) async {
    Uri url = Uri.parse('${baseUrl}task/addTask');

    final response = await http.post(
      url,
      body: jsonEncode({
        "id_actuator": idActuator,
        "id_teams": idTeam,
        "title": title,
        "description": description,
        "actuator": actuator,
        "start": start,
        "end": end,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  //edit task
  Future editTask(
    int id,
    String? idActuator,
    String? idTeam,
    String? title,
    String? description,
    String? actuator,
    String start,
    String end,
  ) async {
    Uri url = Uri.parse('${baseUrl}task/editTask/$id');

    final response = await http.put(
      url,
      body: jsonEncode({
        "id_actuator": idActuator,
        "id_teams": idTeam,
        "title": title,
        "description": description,
        "actuator": actuator,
        "start": start,
        "end": end,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${GlobalItem.userToken}',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  //delete
  Future<bool> delete(int idTask) async {
    final url = Uri.parse('${baseUrl}task/deleteTask/$idTask');

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

  //change status
  Future changeStatus(int idTask) async {
    Uri url = Uri.parse('${baseUrl}task/changeStatus/$idTask');
    final response = await http.get(
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
